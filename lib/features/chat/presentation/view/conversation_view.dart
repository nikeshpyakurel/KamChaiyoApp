import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:kamchaiyo/features/chat/domain/entity/chat_entity.dart';
import 'package:kamchaiyo/features/chat/presentation/view_model/conversation_view_model/conversation_event.dart';
import 'package:kamchaiyo/features/chat/presentation/view_model/conversation_view_model/conversation_state.dart';
import 'package:kamchaiyo/features/chat/presentation/view_model/conversation_view_model/conversation_view_model.dart';
import 'package:flutter/foundation.dart' as foundation;

class ConversationView extends StatefulWidget {
  final ChatEntity chat;
  const ConversationView({super.key, required this.chat});

  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _typingTimer;
  bool _showEmojiPicker = false;

  @override
  void dispose() {
    context.read<ConversationViewModel>().add(TypingStopped());
    _typingTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }


  void _sendMessage(BuildContext context) {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      context.read<ConversationViewModel>().add(TypingStopped());
      _typingTimer?.cancel();
      context.read<ConversationViewModel>().add(MessageSent(content));
      _messageController.clear();
      if (_showEmojiPicker) {
        setState(() {
          _showEmojiPicker = false;
        });
      }
    }
  }

  void _handleTyping(BuildContext context, String value) {
    if (_typingTimer?.isActive ?? false) _typingTimer!.cancel();

    if (value.isNotEmpty) {
      context.read<ConversationViewModel>().add(TypingStarted());
    }

    _typingTimer = Timer(const Duration(milliseconds: 1500), () {
      context.read<ConversationViewModel>().add(TypingStopped());
    });
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onEmojiIconPressed() {
    FocusScope.of(context).unfocus(); 
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });
  }

  void _onTextFieldTapped() {
    if (_showEmojiPicker) {
      setState(() {
        _showEmojiPicker = false; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthViewModel>().state.user!.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.otherUser.fullName),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ConversationViewModel, ConversationState>(
              listenWhen: (previous, current) =>
                  previous.messages.length != current.messages.length,
              listener: (context, state) {
                _scrollToBottom(); 
              },
              builder: (context, state) {
                if (state.status == ConversationStatus.loading && state.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.messages.isEmpty && !state.isTyping) {
                  return const Center(child: Text("Say hello!"));
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    final isMe = message.sender.id == currentUserId;
                    return _MessageBubble(isMe: isMe, message: message.content);
                  },
                );
              },
            ),
          ),
          BlocBuilder<ConversationViewModel, ConversationState>(
            buildWhen: (prev, current) => prev.isTyping != current.isTyping,
            builder: (context, state) {
              if (state.isTyping) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(children: [
                    Text("Typing...", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  ]),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          _MessageInputField(
            controller: _messageController,
            onSend: () => _sendMessage(context),
            onChanged: (value) => _handleTyping(context, value),
            onEmojiTap: _onEmojiIconPressed,
            onTextFieldTap: _onTextFieldTapped,
          ),
          if (_showEmojiPicker) _buildEmojiPicker(),
        ],
      ),
    );
  }

  Widget _buildEmojiPicker() {
    return EmojiPicker(
      onEmojiSelected: (category, emoji) {
        _messageController.text += emoji.emoji;
        _messageController.selection = TextSelection.fromPosition(
            TextPosition(offset: _messageController.text.length));
      },
      onBackspacePressed: () {
        _messageController.text =
            _messageController.text.characters.skipLast(1).toString();
        _messageController.selection = TextSelection.fromPosition(
            TextPosition(offset: _messageController.text.length));
      },
      config: Config(
        height: 250,
        checkPlatformCompatibility: true,
        emojiViewConfig: EmojiViewConfig(
          columns: 8,
          emojiSizeMax: 28 * (foundation.kIsWeb ? 1.30 : 1.0),
          recentsLimit: 28,
          noRecents: const Text(
            'No Recents',
            style: TextStyle(fontSize: 20, color: Colors.black26),
            textAlign: TextAlign.center,
          ),
          backgroundColor: const Color(0xFFF2F2F2),
        ),
        categoryViewConfig: CategoryViewConfig(
          indicatorColor: Theme.of(context).primaryColor,
          iconColorSelected: Theme.of(context).primaryColor,
          backgroundColor: const Color(0xFFF2F2F2),
        ),
        bottomActionBarConfig: BottomActionBarConfig(
          enabled: true,
          buttonColor: Colors.transparent,
          buttonIconColor: Colors.grey,
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  const _MessageBubble({required this.isMe, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? Theme.of(context).primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(4),
            bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(20),
          ),
        ),
        child: Text(message, style: TextStyle(color: isMe ? Colors.white : Colors.black87)),
      ),
    );
  }
}

class _MessageInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onEmojiTap;
  final VoidCallback onTextFieldTap;
  final ValueChanged<String> onChanged;

  const _MessageInputField({
    required this.controller,
    required this.onSend,
    required this.onChanged,
    required this.onEmojiTap,
    required this.onTextFieldTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.emoji_emotions_outlined),
              onPressed: onEmojiTap,
              color: Colors.grey,
            ),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                onTap: onTextFieldTap,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onSubmitted: (_) => onSend(),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              icon: const Icon(Icons.send),
              onPressed: onSend,
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(12),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}