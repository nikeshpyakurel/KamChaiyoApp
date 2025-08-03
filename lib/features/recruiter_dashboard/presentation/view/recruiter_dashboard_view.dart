import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/app/service_locator/service_locator.dart';
import 'package:kamchaiyo/common/widgets/custom_app_bar.dart';
import 'package:kamchaiyo/features/application/presentation/view/recruiter_all_applications_view.dart';
import 'package:kamchaiyo/features/auth/presentation/view/login_view.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:kamchaiyo/features/chat/presentation/view/chats_list_view.dart';
import 'package:kamchaiyo/features/company/presentation/view/manage_companies_view.dart';
import 'package:kamchaiyo/features/company/presentation/view_model/company_event.dart';
import 'package:kamchaiyo/features/company/presentation/view_model/company_view_model.dart';
import 'package:kamchaiyo/features/job/presentation/view/manage_jobs_view.dart';
import 'package:kamchaiyo/features/job/presentation/view_model/job_event.dart';
import 'package:kamchaiyo/features/my_interviews/presentation/view_model/my_interviews_view_model.dart';
import 'package:kamchaiyo/features/notification/presentation/view/notifications_view.dart';
import 'package:kamchaiyo/features/job/presentation/view_model/job_view_model.dart';
import 'package:kamchaiyo/features/my_interviews/presentation/view/my_interviews_view.dart';
import 'package:kamchaiyo/features/my_interviews/presentation/view_model/my_interviews_event.dart';
import 'package:kamchaiyo/features/notification/presentation/view_model/notification_cubit.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/presentation/view_model/recruiter_dashboard_event.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/presentation/view_model/recruiter_dashboard_view_model.dart';
import 'package:kamchaiyo/features/recruiter_profile/presentation/view/recruiter_profile_view.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/presentation/view/recruiter_stats_view.dart';

class RecruiterDashboardView extends StatefulWidget {
  const RecruiterDashboardView({super.key});

  @override
  State<RecruiterDashboardView> createState() => _RecruiterDashboardViewState();
}

class _RecruiterDashboardViewState extends State<RecruiterDashboardView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  final _pages = [
    _NavigationPage(
      title: 'Dashboard',
      icon: Icons.dashboard_outlined,
      body: const RecruiterStatsView(),
    ),
    _NavigationPage(
      title: 'My Companies',
      icon: Icons.business_outlined,
      body: const ManageCompaniesView(),
    ),
    _NavigationPage(
      title: 'My Jobs',
      icon: Icons.work_outline,
      body: const ManageJobsView(),
    ),
    _NavigationPage(
      title: 'Applicants',
      icon: Icons.people_outline,
      body: const RecruiterAllApplicationsView(),
    ),
    _NavigationPage(
      title: 'Interviews',
      icon: Icons.calendar_today_outlined,
      body: const MyInterviewsView(),
    ),
    _NavigationPage(
      title: 'Messages',
      icon: Icons.message_outlined,
      body: const ChatsListView(),
    ),
    _NavigationPage(
      title: 'My Profile',
      icon: Icons.person_outline,
      body: const RecruiterProfileView(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.of(context).pop();
  }

  void _logout(BuildContext context) {
    context.read<AuthViewModel>().add(LogoutRequested());
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().state.user;
    final theme = Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) =>
                sl<RecruiterDashboardViewModel>()..add(RecruiterStatsFetched())),
        BlocProvider(
            create: (_) => sl<CompanyViewModel>()..add(MyCompaniesFetched())),
        BlocProvider(
            create: (_) => sl<JobViewModel>()..add(MyJobsAndCompaniesFetched())),
        BlocProvider(
            create: (_) =>
                sl<MyInterviewsViewModel>()..add(MyInterviewsFetched())),
        BlocProvider.value(value: sl<NotificationCubit>()),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: CustomAppBar(
              title: _pages[_currentIndex].title,
              scaffoldKey: _scaffoldKey,
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
                    final notificationCubit = context.read<NotificationCubit>();
                    notificationCubit.markAllAsRead();

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: notificationCubit,
                        child: const NotificationsView(),
                      ),
                    ));
                  },
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(user?.fullName ?? 'Recruiter Name',
                        style: theme.textTheme.titleLarge
                            ?.copyWith(color: Colors.white)),
                    accountEmail: Text(user?.email ?? 'recruiter@email.com',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white70)),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: user?.profile?.avatar != null
                          ? NetworkImage(user!.profile!.avatar!)
                          : null,
                      child: user?.profile?.avatar == null
                          ? Text(user?.fullName[0] ?? '?')
                          : null,
                    ),
                    decoration: BoxDecoration(color: theme.primaryColor),
                  ),
                  ...List.generate(_pages.length, (index) {
                    final page = _pages[index];
                    return ListTile(
                      leading: Icon(page.icon),
                      title: Text(page.title),
                      selected: _currentIndex == index,
                      onTap: () => _onItemTapped(index),
                    );
                  }),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () => _logout(context),
                  ),
                ],
              ),
            ),
            body: _pages[_currentIndex].body,
          );
        }
      ),
    );
  }
}

class _NavigationPage {
  final String title;
  final IconData icon;
  final Widget body;

  _NavigationPage(
      {required this.title, required this.icon, required this.body});
}