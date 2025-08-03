import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kamchaiyo/common/snake_bar.dart';
import 'package:kamchaiyo/features/interview/domain/use_case/schedule_interview_usecase.dart';
import 'package:kamchaiyo/features/interview/presentation/view_model/interview_event.dart';
import 'package:kamchaiyo/features/interview/presentation/view_model/interview_state.dart';
import 'package:kamchaiyo/features/interview/presentation/view_model/interview_view_model.dart';

class ScheduleInterviewView extends StatefulWidget {
  final String applicationId;
  final String applicantName;
  const ScheduleInterviewView(
      {super.key, required this.applicationId, required this.applicantName});

  @override
  State<ScheduleInterviewView> createState() => _ScheduleInterviewViewState();
}

class _ScheduleInterviewViewState extends State<ScheduleInterviewView> {
  final _formKey = GlobalKey<FormState>();
  final _locationLinkController = TextEditingController();

  String _interviewType = 'online';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _locationLinkController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  void _onSchedule() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        showSnackBar(
            context: context,
            message: 'Please select a date and time.',
            color: Colors.orange);
        return;
      }

      final timeString =
          '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';

      final params = ScheduleInterviewParams(
        applicationId: widget.applicationId,
        interviewType: _interviewType,
        date: _selectedDate!,
        time: timeString,
        locationOrLink: _locationLinkController.text.trim(),
      );

      // This context.read() call is now safe.
      context.read<InterviewViewModel>().add(InterviewScheduled(params));
    }
  }

  @override
  Widget build(BuildContext context) {
    // The BlocProvider has been removed from this file.
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule for ${widget.applicantName}'),
      ),
      body: BlocListener<InterviewViewModel, InterviewState>(
        listener: (context, state) {
          if (state.status == InterviewScheduleStatus.success) {
            showSnackBar(
                context: context,
                message: state.successMessage!,
                color: Colors.green);
            Navigator.of(context).pop();
          }
          if (state.status == InterviewScheduleStatus.failure) {
            showSnackBar(
                context: context, message: state.error!, color: Colors.red);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Interview Type',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                RadioListTile<String>(
                  title: const Text('Online Meeting'),
                  value: 'online',
                  groupValue: _interviewType,
                  onChanged: (v) => setState(() => _interviewType = v!),
                ),
                RadioListTile<String>(
                  title: const Text('In-Office'),
                  value: 'inoffice',
                  groupValue: _interviewType,
                  onChanged: (v) => setState(() => _interviewType = v!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationLinkController,
                  decoration: InputDecoration(
                    labelText: _interviewType == 'online'
                        ? 'Meeting Link (Zoom, Meet, etc.)'
                        : 'Office Location / Address',
                  ),
                  validator: (v) =>
                      v!.isEmpty ? 'This field is required' : null,
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(_selectedDate == null
                      ? 'Select Date'
                      : DateFormat.yMMMd().format(_selectedDate!)),
                  onTap: _pickDate,
                ),
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: Text(_selectedTime == null
                      ? 'Select Time'
                      : _selectedTime!.format(context)),
                  onTap: _pickTime,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<InterviewViewModel, InterviewState>(
                    builder: (context, state) {
                      if (state.status == InterviewScheduleStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton.icon(
                        icon: const Icon(Icons.send),
                        label: const Text('Schedule & Notify Applicant'),
                        onPressed: _onSchedule,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}