import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/common/snake_bar.dart';
import 'package:kamchaiyo/features/admin/presentation/view_model/admin_bloc.dart';

class ChatbotSettingsView extends StatefulWidget {
  const ChatbotSettingsView({super.key});
  @override
  State<ChatbotSettingsView> createState() => _ChatbotSettingsViewState();
}

class _ChatbotSettingsViewState extends State<ChatbotSettingsView> {
  final _promptController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state.chatbotSettings != null && _promptController.text.isEmpty) {
          _promptController.text = state.chatbotSettings!.systemPrompt;
        }
        if (state.error != null) {
          showSnackBar(context: context, content: state.error!, color: Colors.red);
        }
      },
      builder: (context, state) {
        if (state.status == AdminStatus.loading && state.chatbotSettings == null) return const Center(child: CircularProgressIndicator());
        
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('System Prompt', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('This is the core instruction set for the AI assistant. It defines its personality, rules, and knowledge base access. Edit with care.', style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _promptController,
                  maxLines: 18,
                  decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter the system prompt here...'),
                  validator: (value) => value!.isEmpty ? 'Prompt cannot be empty' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.status == AdminStatus.loading ? null : () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AdminBloc>().add(ChatbotSettingsUpdated(_promptController.text));
                      }
                    },
                    child: state.status == AdminStatus.loading ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white)) : const Text('Save Settings'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}