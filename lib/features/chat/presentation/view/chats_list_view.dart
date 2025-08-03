import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kamchaiyo/app/service_locator/service_locator.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart'; 
import 'package:kamchaiyo/features/chat/presentation/view/conversation_view.dart';
import 'package:kamchaiyo/features/chat/presentation/view_model/chats_list_view_model/chats_list_event.dart';
import 'package:kamchaiyo/features/chat/presentation/view_model/chats_list_view_model/chats_list_state.dart';
import 'package:kamchaiyo/features/chat/presentation/view_model/chats_list_view_model/chats_list_view_model.dart';
import 'package:kamchaiyo/features/chat/presentation/view_model/conversation_view_model/conversation_event.dart';
import 'package:kamchaiyo/features/chat/presentation/view_model/conversation_view_model/conversation_view_model.dart';

class ChatsListView extends StatefulWidget {
  const ChatsListView({super.key});

  @override
  State<ChatsListView> createState() => _ChatsListViewState();
}

class _ChatsListViewState extends State<ChatsListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (mounted) {
      context
          .read<ChatsListViewModel>()
          .add(ChatsListSearched(_searchController.text));
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userRole = context.read<AuthViewModel>().state.user?.role;
    final isStudent = userRole == 'student';

    return BlocProvider(
      create: (context) => sl<ChatsListViewModel>()..add(ChatsListFetched()),
      child: Scaffold(
        appBar: isStudent
            ? AppBar(
                title: const Text('Messages'),
              )
            : null, 
        body: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: BlocBuilder<ChatsListViewModel, ChatsListState>(
                builder: (context, state) {
                  if (state.status == ChatsListStatus.loading &&
                      state.chats.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == ChatsListStatus.failure) {
                    return Center(
                        child: Text(state.error ?? 'Failed to load chats.'));
                  }

                  if (state.filteredChats.isEmpty) {
                    return _buildEmptyState(
                        isSearching: state.searchQuery.isNotEmpty);
                  }

                  return RefreshIndicator(
                    onRefresh: () async => context
                        .read<ChatsListViewModel>()
                        .add(ChatsListFetched()),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: state.filteredChats.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        indent: 88,
                        endIndent: 16,
                      ),
                      itemBuilder: (context, index) {
                        final chat = state.filteredChats[index];
                        final latestMessage = chat.latestMessage;
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                Theme.of(context).primaryColor.withAlpha(50),
                            child: Text(
                              chat.otherUser.fullName.isNotEmpty
                                  ? chat.otherUser.fullName[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          title: Text(chat.otherUser.fullName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            latestMessage?.content ?? 'No messages yet',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          trailing: latestMessage != null
                              ? Text(
                                  DateFormat.jm().format(
                                      latestMessage.createdAt.toLocal()),
                                  style: Theme.of(context).textTheme.bodySmall,
                                )
                              : null,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (context) => sl<ConversationViewModel>()
                                  ..add(ConversationOpened(chat.id)),
                                child: ConversationView(chat: chat),
                              ),
                            ),
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
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search chats...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildEmptyState({required bool isSearching}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          isSearching
              ? 'No chats found for your search.'
              : 'You have no conversations yet.\nWhen a recruiter starts a chat, it will appear here.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}