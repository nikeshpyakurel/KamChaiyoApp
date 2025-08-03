import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kamchaiyo/app/service_locator/service_locator.dart';
import 'package:kamchaiyo/common/widgets/empty_state_display.dart';
import 'package:kamchaiyo/features/company/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/company_detail/presentation/view_model/company_detail_bloc.dart';
import 'package:kamchaiyo/features/home/presentation/view_model/home_navigation/home_navigation_cubit.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/job_detail/presentation/view/job_detail_view.dart';
import 'package:kamchaiyo/features/my_applications/presentation/view_model/my_applications_bloc.dart';

class CompanyDetailView extends StatelessWidget {
  final String companyId;
  const CompanyDetailView({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<CompanyDetailBloc>()..add(CompanyDetailFetched(companyId)),
      child: Scaffold(
        body: BlocBuilder<CompanyDetailBloc, CompanyDetailState>(
          builder: (context, state) {
            if (state.status == CompanyDetailStatus.loading ||
                state.status == CompanyDetailStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == CompanyDetailStatus.failure ||
                state.details == null) {
              return Center(
                  child:
                      Text(state.error ?? 'Could not load company details.'));
            }

            final company = state.details!.company;
            final jobs = state.filteredJobs;

            return CustomScrollView(
              slivers: [
                _buildSliverAppBar(context, company),
                SliverToBoxAdapter(child: _buildCompanyInfo(context, company)),
                SliverToBoxAdapter(child: _buildJobsHeader(context)),
                _buildJobsList(context, jobs),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, CompanyEntity company) {
    return SliverAppBar(
      expandedHeight: 200.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(company.name,
            style: const TextStyle(shadows: [Shadow(blurRadius: 8)])),
        background: company.logo != null
            ? Image.network(company.logo!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Theme.of(context).primaryColor))
            : Container(color: Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _buildCompanyInfo(BuildContext context, CompanyEntity company) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(company.description ?? 'No description provided.',
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16),
              const SizedBox(width: 8),
              Text(company.location ?? 'N/A'),
            ],
          ),
          const SizedBox(height: 8),
          if (company.website != null && company.website!.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.link_outlined, size: 16),
                const SizedBox(width: 8),
                Text(company.website!,
                    style: TextStyle(color: Theme.of(context).primaryColor)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildJobsHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Open Positions',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search for a job title...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) {
              context
                  .read<CompanyDetailBloc>()
                  .add(CompanyJobsSearchQueryChanged(query));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildJobsList(BuildContext context, List<JobEntity> jobs) {
    if (jobs.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: EmptyStateDisplay(
            icon: Icons.work_off_outlined,
            message: 'This company has no open positions at the moment.',
          ),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final job = jobs[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ListTile(
              title: Text(job.title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(job.location),
              trailing: Text(
                NumberFormat.compactSimpleCurrency(locale: 'en_IN')
                    .format(job.salary),
              ),
              onTap: () {
                
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                          value: context.read<HomeNavigationCubit>()),
                      BlocProvider.value(
                          value: context.read<MyApplicationsBloc>()),
                    ],
                    child: JobDetailView(jobId: job.id),
                  ),
                ));
              },
            ),
          );
        },
        childCount: jobs.length,
      ),
    );
  }
}