import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/app/service_locator/service_locator.dart';
import 'package:kamchaiyo/common/widgets/shimmers/list_tile_shimmer.dart';
import 'package:kamchaiyo/common/widgets/shimmers/shimmer_loading.dart';
import 'package:kamchaiyo/features/chat/presentation/view/chats_list_view.dart';
import 'package:kamchaiyo/features/chat/presentation/view_model/chats_list_view_model/chats_list_view_model.dart';
import 'package:kamchaiyo/features/company_detail/presentation/view/company_detail_view.dart';
import 'package:kamchaiyo/features/home/presentation/view_model/companies/companies_bloc.dart';
import 'package:kamchaiyo/features/home/presentation/view_model/home_navigation/home_navigation_cubit.dart';
import 'package:kamchaiyo/features/my_applications/presentation/view_model/my_applications_bloc.dart';
import 'package:kamchaiyo/features/notification/presentation/view/notifications_view.dart';
import 'package:kamchaiyo/features/notification/presentation/view_model/notification_cubit.dart';

class CompaniesView extends StatefulWidget {
  const CompaniesView({super.key});

  @override
  State<CompaniesView> createState() => _CompaniesViewState();
}

class _CompaniesViewState extends State<CompaniesView> {
  @override
  void initState() {
    super.initState();
    context.read<CompaniesBloc>().add(CompaniesFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Companies'),
        actions: [
          IconButton(
            icon: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                return Badge(
                  label: Text(state.unreadCount.toString()),
                  isLabelVisible: state.unreadCount > 0,
                  child: const Icon(Icons.notifications_outlined),
                );
              },
            ),

            onPressed: () {
              final notificationCubit = sl<NotificationCubit>();
              notificationCubit.markAllAsRead();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: notificationCubit,
                  child: const NotificationsView(),
                ),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.message_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ChatsListViewModel>(),
                    child: const ChatsListView(),
                  ),
                ),
              );
            },
            tooltip: 'Messages',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search for a company...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                context
                    .read<CompaniesBloc>()
                    .add(CompaniesSearchQueryChanged(query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<CompaniesBloc, CompaniesState>(
              builder: (context, state) {
                if (state.status == CompaniesStatus.loading) {
                  return const ShimmerLoading(child: ListTileShimmer());
                }
                if (state.status == CompaniesStatus.failure) {
                  return Center(
                      child: Text(state.error ?? 'Failed to load companies.'));
                }
                if (state.filteredCompanies.isEmpty) {
                  return const Center(child: Text('No companies found.'));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<CompaniesBloc>().add(CompaniesFetched());
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: state.filteredCompanies.length,
                    itemBuilder: (context, index) {
                      final company = state.filteredCompanies[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: company.logo != null
                                ? NetworkImage(company.logo!)
                                : null,
                            child: company.logo == null
                                ? Text(company.name[0])
                                : null,
                          ),
                          title: Text(company.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(company.location ?? 'N/A'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                    value: context.read<HomeNavigationCubit>(),
                                  ),
                                  BlocProvider.value(
                                    value: context.read<MyApplicationsBloc>(),
                                  ),
                                ],
                                child: CompanyDetailView(companyId: company.id),
                              ),
                            ));
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}