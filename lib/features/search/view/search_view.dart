import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kamchaiyo/common/widgets/empty_state_display.dart';
import 'package:kamchaiyo/features/home/presentation/view_model/home_navigation/home_navigation_cubit.dart';
import 'package:kamchaiyo/features/job_detail/presentation/view/job_detail_view.dart';
import 'package:kamchaiyo/features/my_applications/presentation/view_model/my_applications_bloc.dart';
import 'package:kamchaiyo/features/search/view_model/search_bloc.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _keywordController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(SearchInitialJobsFetched());

    _keywordController.addListener(_onSearchChanged);
    _locationController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    context.read<SearchBloc>().add(
      SearchQueryChanged(
        keyword: _keywordController.text,
        location: _locationController.text,
      ),
    );
  }

  @override
  void dispose() {
    _keywordController.removeListener(_onSearchChanged);
    _locationController.removeListener(_onSearchChanged);
    _keywordController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find a Job')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _keywordController,
                  decoration: InputDecoration(
                    labelText: 'Keyword (e.g., "Flutter", "Sales")',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        _keywordController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => _keywordController.clear(),
                            )
                            : null,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location (e.g., "Kathmandu")',
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    suffixIcon:
                        _locationController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => _locationController.clear(),
                            )
                            : null,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state.status == SearchStatus.loading &&
                    state.jobs.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == SearchStatus.failure) {
                  return Center(
                    child: Text(state.error ?? "An error occurred."),
                  );
                }
                if (state.jobs.isEmpty) {
                  return const EmptyStateDisplay(
                    icon: Icons.search_off,
                    message: "No jobs found matching your criteria.",
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<SearchBloc>().add(SearchInitialJobsFetched());
                  },
                  child: ListView.builder(
                    itemCount: state.jobs.length,
                    itemBuilder: (context, index) {
                      final job = state.jobs[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                job.companyLogo != null
                                    ? NetworkImage(job.companyLogo!)
                                    : null,
                            child:
                                job.companyLogo == null
                                    ? Text(job.companyName[0])
                                    : null,
                          ),
                          title: Text(
                            job.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${job.companyName} • ${job.location}',
                          ),
                          trailing: Text(
                            NumberFormat.compactSimpleCurrency(
                              locale: 'en_IN',
                            ).format(job.salary),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider.value(
                                          value:
                                              context
                                                  .read<HomeNavigationCubit>(),
                                        ),
                                        BlocProvider.value(
                                          value:
                                              context
                                                  .read<MyApplicationsBloc>(),
                                        ),
                                      ],
                                      child: JobDetailView(jobId: job.id),
                                    ),
                              ),
                            );
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
