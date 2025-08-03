import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kamchaiyo/features/company/domain/entity/company_entity.dart';
import 'package:kamchaiyo/features/company/domain/use_case/get_my_companies_usecase.dart';
import 'package:kamchaiyo/features/company/domain/use_case/update_company_usecase.dart';
import 'package:kamchaiyo/features/company/presentation/view_model/company_event.dart';
import 'package:kamchaiyo/features/company/presentation/view_model/company_state.dart';
import 'package:kamchaiyo/features/company/presentation/view_model/company_view_model.dart';

class AddEditCompanyView extends StatefulWidget {
  final CompanyEntity? company;
  const AddEditCompanyView({super.key, this.company});

  @override
  State<AddEditCompanyView> createState() => _AddEditCompanyViewState();
}

class _AddEditCompanyViewState extends State<AddEditCompanyView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _websiteController = TextEditingController();
  final _locationController = TextEditingController();
  File? _logo;

  bool get isEditMode => widget.company != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final company = widget.company!;
      _nameController.text = company.name;
      _descController.text = company.description ?? '';
      _websiteController.text = company.website ?? '';
      _locationController.text = company.location ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _websiteController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _logo = File(pickedFile.path);
      });
    }
  }

  void _saveCompany() {
    if (_formKey.currentState!.validate()) {
      if (isEditMode) {
        final params = UpdateCompanyParams(
          id: widget.company!.id,
          name: _nameController.text.trim(),
          description: _descController.text.trim(),
          website: _websiteController.text.trim(),
          location: _locationController.text.trim(),
          logo: _logo,
        );
        context.read<CompanyViewModel>().add(CompanyUpdated(params));
      } else {
        final params = CreateCompanyParams(
          name: _nameController.text.trim(),
          description: _descController.text.trim(),
          website: _websiteController.text.trim(),
          location: _locationController.text.trim(),
          logo: _logo,
        );
        context.read<CompanyViewModel>().add(CompanyCreated(params));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Company' : 'Create New Company'),
      ),
      body: BlocListener<CompanyViewModel, CompanyState>(
        listener: (context, state) {
          if (state.status == CompanyStatus.success && state.message != null) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          } else if (state.status == CompanyStatus.failure && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _logo != null
                            ? FileImage(_logo!)
                            : (isEditMode && widget.company!.logo != null
                                ? NetworkImage(widget.company!.logo!)
                                : null) as ImageProvider?,
                        child: _logo == null && (widget.company?.logo == null)
                            ? const Icon(Icons.business, size: 40)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          child: const CircleAvatar(
                            radius: 18,
                            child: Icon(Icons.camera_alt, size: 20),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: 'Company Name*',
                      prefixIcon: Icon(Icons.business)),
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Company name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                      labelText: 'Company Description',
                      prefixIcon: Icon(Icons.description)),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _websiteController,
                  decoration: const InputDecoration(
                      labelText: 'Website URL', prefixIcon: Icon(Icons.language)),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                      labelText: 'Location',
                      prefixIcon: Icon(Icons.location_on)),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<CompanyViewModel, CompanyState>(
                    builder: (context, state) {
                      if (state.status == CompanyStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _saveCompany,
                        child: Text(isEditMode ? 'Save Changes' : 'Create Company'),
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