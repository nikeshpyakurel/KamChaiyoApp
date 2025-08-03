import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/app/service_locator/service_locator.dart';
import 'package:kamchaiyo/common/widgets/shake_detector_wrapper.dart';
import 'package:kamchaiyo/features/chat/presentation/view_model/chats_list_view_model/chats_list_view_model.dart';
import 'package:kamchaiyo/features/chatbot/presentation/view/chatbot_view.dart';
import 'package:kamchaiyo/features/chatbot/presentation/view_model/chatbot_bloc.dart';
import 'package:kamchaiyo/features/home/presentation/view/companies_view.dart';
import 'package:kamchaiyo/features/home/presentation/view/job_feed_view.dart';
import 'package:kamchaiyo/features/home/presentation/view_model/companies/companies_bloc.dart';
import 'package:kamchaiyo/features/home/presentation/view_model/home_navigation/home_navigation_cubit.dart';
import 'package:kamchaiyo/features/home/presentation/view_model/job_feed/job_feed_bloc.dart';
import 'package:kamchaiyo/features/my_applications/presentation/view/my_applications_view.dart';
import 'package:kamchaiyo/features/my_applications/presentation/view_model/my_applications_bloc.dart';
import 'package:kamchaiyo/features/my_interviews/presentation/view/student_my_interviews_view.dart';
import 'package:kamchaiyo/features/my_interviews/presentation/view_model/my_interviews_view_model.dart';
import 'package:kamchaiyo/features/notification/presentation/view_model/notification_cubit.dart'; // 1. IMPORT NotificationCubit
import 'package:kamchaiyo/features/profile/presentation/view/profile_view.dart';
import 'package:kamchaiyo/features/profile/presentation/view_model/profile_bloc.dart';
import 'package:kamchaiyo/features/search/view/search_view.dart';
import 'package:kamchaiyo/features/search/view_model/search_bloc.dart';


class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ShakeDetectorWrapper(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => HomeNavigationCubit()),
          BlocProvider(create: (context) => sl<CompaniesBloc>()),
          BlocProvider(create: (context) => sl<MyApplicationsBloc>()),
          BlocProvider(create: (context) => sl<SearchBloc>()),
          BlocProvider(create: (context) => sl<ProfileBloc>()),
          BlocProvider(create: (context) => sl<ChatbotBloc>()),
          BlocProvider(create: (context) => sl<MyInterviewsViewModel>()),
          BlocProvider(create: (context) => sl<ChatsListViewModel>()),
          BlocProvider.value(value: sl<NotificationCubit>()),
        ],
        child: BlocBuilder<HomeNavigationCubit, int>(
          builder: (context, activeIndex) {
            final List<Widget> pages = [
              const CompaniesView(),
              const MyApplicationsView(),
              const StudentMyInterviewsView(),
              const SearchView(),
              const ProfileView(),
            ];
      
            return Scaffold(
              body: IndexedStack(
                index: activeIndex,
                children: pages,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<ChatbotBloc>(),
                        child: const ChatbotView(),
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.support_agent),
                tooltip: 'AI Helper',
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: activeIndex,
                onTap: (index) =>
                    context.read<HomeNavigationCubit>().changeTab(index),
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.article_outlined),
                    activeIcon: Icon(Icons.article),
                    label: 'Applications',
                  ),
                                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today_outlined),
                    activeIcon: Icon(Icons.calendar_today),
                    label: 'Interviews',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search_outlined),
                    activeIcon: Icon(Icons.search),
                    label: 'Search',
                  ),
                  
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}