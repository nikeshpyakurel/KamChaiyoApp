import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/common/snake_bar.dart';
import 'package:kamchaiyo/features/company/presentation/view/add_edit_company_view.dart';
import 'package:kamchaiyo/features/company/presentation/view_model/company_event.dart';
import 'package:kamchaiyo/features/company/presentation/view_model/company_state.dart';
import 'package:kamchaiyo/features/company/presentation/view_model/company_view_model.dart';

class ManageCompaniesView extends StatelessWidget {
  const ManageCompaniesView({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: BlocConsumer<CompanyViewModel, CompanyState>(
        listener: (context, state) {
          if (state.message != null) {
            showSnackBar(context: context, message: state.message!, color: Colors.green);
          }
          if (state.error != null) {
            showSnackBar(context: context, message: state.error!, color: Colors.red);
          }
        },
        builder: (context, state) {
          if (state.status == CompanyStatus.loading && state.myCompanies.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.myCompanies.isEmpty) {
            return const Center(
              child: Text(
                'No companies found.\nTap the + to add your first company.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<CompanyViewModel>().add(MyCompaniesFetched());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: state.myCompanies.length,
              itemBuilder: (context, index) {
                final company = state.myCompanies[index];
                final bool isDeleting = state.deletingCompanyId == company.id;

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: company.logo != null ? NetworkImage(company.logo!) : null,
                      child: company.logo == null ? Text(company.name[0]) : null,
                    ),
                    title: Text(company.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(company.location ?? 'No location provided'),
                    trailing: isDeleting
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                        : PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                // Navigate to edit screen
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: BlocProvider.of<CompanyViewModel>(context),
                                    child: AddEditCompanyView(company: company),
                                  ),
                                ));
                              } else if (value == 'delete') {
                                // Show confirmation dialog
                                _showDeleteConfirmation(context, company.id, company.name);
                              }
                            },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: BlocBuilder<CompanyViewModel, CompanyState>(builder: (context, state) {
        return FloatingActionButton(
          heroTag: 'company-fab',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<CompanyViewModel>(context),
                  child: const AddEditCompanyView(),
                ),
              ),
            );
          },
          
          child: const Icon(Icons.add),
        );
      }),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String companyId, String companyName) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete "$companyName"? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () {
                context.read<CompanyViewModel>().add(CompanyDeleted(companyId));
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}