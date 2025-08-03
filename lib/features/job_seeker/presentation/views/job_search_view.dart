import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/app/service_locator/service_locator.dart';
import 'package:kamchaiyo/common/snake_bar.dart';
import 'package:kamchaiyo/features/job_seeker/presentation/view_models/job_search/job_search_bloc.dart';
import 'package:kamchaiyo/features/job_seeker/presentation/views/job_detail_view.dart';
import 'package:timeago/timeago.dart' as timeago;

class JobSearchView extends StatelessWidget {
  const JobSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<JobSearchBloc>()..add(SearchSubmitted()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Find Your Dream Job'),
          automaticallyImplyLeading: false,
        ),
        body: const _JobSearchContent(),
      ),
    );
  }
}

class _JobSearchContent extends StatefulWidget {
  const _JobSearchContent();

  @override
  State<_JobSearchContent> createState() => __JobSearchContentState();
}

class __JobSearchContentState extends State<_JobSearchContent> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<JobSearchBloc>().add(NextPageRequested());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JobSearchBloc, JobSearchState>(
      listener: (context, state) {
        if (state.status == JobSearchStatus.applySuccess) {
          showSnackBar(context: context, message: state.successMessage!, color: Colors.green);
        } else if (state.status == JobSearchStatus.applyFailure) {
          showSnackBar(context: context, message: state.errorMessage!, color: Colors.red);
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by keyword, company...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (term) {
                context.read<JobSearchBloc>().add(SearchTermChanged(term));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<JobSearchBloc, JobSearchState>(
              builder: (context, state) {
                switch (state.status) {
                  case JobSearchStatus.failure:
                    return Center(child: Text(state.errorMessage ?? 'Failed to fetch jobs'));
                  case JobSearchStatus.initial:
                  case JobSearchStatus.loading:
                    if (state.jobs.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    break;
                  default:
                    if (state.jobs.isEmpty) {
                      return const Center(child: Text('No jobs found.'));
                    }
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: state.hasReachedMax
                      ? state.jobs.length
                      : state.jobs.length + 1,
                  itemBuilder: (context, index) {
                    return index >= state.jobs.length
                        ? const Center(child: CircularProgressIndicator())
                        : _JobCard(job: state.jobs[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final dynamic job;
  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<JobSearchBloc>(),
              child: JobDetailView(job: job),
            ),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: job.companyLogo != null
                        ? NetworkImage(job.companyLogo!)
                        : null,
                    child:
                        job.companyLogo == null ? Text(job.companyName[0]) : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(job.companyName, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                job.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(job.location, style: theme.textTheme.bodyMedium),
                  const Spacer(),
                  Text(timeago.format(job.createdAt.toLocal()), style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}