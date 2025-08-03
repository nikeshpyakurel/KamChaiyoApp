import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/job/domain/entity/job_entity.dart';
import 'package:kamchaiyo/features/job/domain/use_case/post_job_usecase.dart';
import 'package:kamchaiyo/features/job/domain/use_case/update_job_usecase.dart';
import 'package:kamchaiyo/features/job/presentation/view_model/job_event.dart';
import 'package:kamchaiyo/features/job/presentation/view_model/job_state.dart';
import 'package:kamchaiyo/features/job/presentation/view_model/job_view_model.dart';


class AddEditJobView extends StatefulWidget {
  final JobEntity? job;
  const AddEditJobView({super.key, this.job});

  bool get isEditMode => job != null;

  @override
  State<AddEditJobView> createState() => _AddEditJobViewState();
}

class _AddEditJobViewState extends State<AddEditJobView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _reqsController = TextEditingController();
  final _salaryController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedCompanyId;
  String? _selectedJobType;
  String? _selectedExpLevel;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      final job = widget.job!;
      _titleController.text = job.title;
      _descController.text = job.description;
      _reqsController.text = job.requirements.join(', ');
      _salaryController.text = job.salary.toString();
      _locationController.text = job.location;
      _selectedCompanyId = job.companyId;
      _selectedJobType = job.jobType;
      _selectedExpLevel = job.experienceLevel;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _reqsController.dispose();
    _salaryController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveJob() {
    if (_formKey.currentState!.validate()) {
      final requirements = _reqsController.text.isNotEmpty
          ? _reqsController.text.split(',').map((e) => e.trim()).toList()
          : <String>[];
      final salary = int.tryParse(_salaryController.text) ?? 0;

      if (widget.isEditMode) {
        final params = UpdateJobParams(
          id: widget.job!.id,
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          requirements: requirements,
          salary: salary,
          location: _locationController.text.trim(),
          jobType: _selectedJobType!,
          experienceLevel: _selectedExpLevel!,
          companyId: _selectedCompanyId!,
        );
        context.read<JobViewModel>().add(JobUpdated(params));
      } else {
        final params = PostJobParams(
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          requirements: requirements,
          salary: salary,
          location: _locationController.text.trim(),
          jobType: _selectedJobType!,
          experienceLevel: _selectedExpLevel!,
          companyId: _selectedCompanyId!,
        );
        context.read<JobViewModel>().add(JobPosted(params));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Edit Job' : 'Post New Job'),
      ),
      body: BlocListener<JobViewModel, JobState>(
        listener: (context, state) {
          if (state.status == JobStatus.success && state.message != null && state.message!.isNotEmpty) {
            Navigator.of(context).pop();
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                        labelText: 'Job Title*', prefixIcon: Icon(Icons.title)),
                    validator: (v) => v!.isEmpty ? 'Title is required' : null,
                ),
                const SizedBox(height: 16),
                BlocBuilder<JobViewModel, JobState>(
                  builder: (context, state) {
                    if (state.myCompanies.isEmpty && state.status == JobStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return DropdownButtonFormField<String>(
                      value: _selectedCompanyId,
                      items: state.myCompanies
                          .map((company) => DropdownMenuItem(
                                value: company.id,
                                child: Text(company.name),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedCompanyId = value),
                      decoration: const InputDecoration(
                          labelText: 'Company*', prefixIcon: Icon(Icons.business)),
                      validator: (v) =>
                          v == null ? 'Please select a company' : null,
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(
                        labelText: 'Description*', prefixIcon: Icon(Icons.description)),
                    maxLines: 5,
                    validator: (v) => v!.isEmpty ? 'Description is required' : null),
                const SizedBox(height: 16),
                TextFormField(
                    controller: _reqsController,
                    decoration: const InputDecoration(
                        labelText: 'Requirements (comma-separated)',
                        prefixIcon: Icon(Icons.list_alt))),
                const SizedBox(height: 16),
                TextFormField(
                    controller: _salaryController,
                    decoration: const InputDecoration(
                        labelText: 'Salary*', prefixIcon: Icon(Icons.attach_money)),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) => v!.isEmpty ? 'Salary is required' : null),
                const SizedBox(height: 16),
                TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                        labelText: 'Location*', prefixIcon: Icon(Icons.location_on)),
                    validator: (v) => v!.isEmpty ? 'Location is required' : null),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedJobType,
                  items: ['Full-time', 'Part-time', 'Contract', 'Internship']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedJobType = v),
                  decoration:
                      const InputDecoration(labelText: 'Job Type*', prefixIcon: Icon(Icons.timer)),
                  validator: (v) => v == null ? 'Please select a job type' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedExpLevel,
                  items: ['Entry-level', 'Mid-level', 'Senior-level']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedExpLevel = v),
                  decoration: const InputDecoration(
                      labelText: 'Experience Level*', prefixIcon: Icon(Icons.stairs)),
                  validator: (v) =>
                      v == null ? 'Please select an experience level' : null,
                ),
                const SizedBox(height: 24),
                BlocBuilder<JobViewModel, JobState>(
                  builder: (context, state) {
                    if (state.status == JobStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _saveJob,
                      child: Text(widget.isEditMode ? 'Save Changes' : 'Post Job'),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}