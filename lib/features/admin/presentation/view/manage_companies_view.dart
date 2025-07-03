import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/common/snake_bar.dart';
import 'package:kamchaiyo/features/admin/presentation/view_model/admin_bloc.dart';

class ManageCompaniesView extends StatelessWidget {
  const ManageCompaniesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state.message != null) {
          showSnackBar(context: context, message: state.message!, color: Colors.green);
        }
        if (state.error != null) {
          showSnackBar(context: context, message: state.error!, color: Colors.red);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Manage Companies')),
        body: BlocBuilder<AdminBloc, AdminState>(
          builder: (context, state) {
            if (state.status == AdminStatus.loading && state.companies.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.companies.isEmpty) {
              return const Center(child: Text('No companies found.'));
            }
            
            return RefreshIndicator(
              onRefresh: () async { context.read<AdminBloc>().add(AdminDataFetched()); },
              child: ListView.builder(
                itemCount: state.companies.length,
                itemBuilder: (context, index) {
                  final company = state.companies[index];
                  final isToggling = state.togglingCompanyId == company.id;

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: company.logo != null ? NetworkImage(company.logo!) : null,
                        child: company.logo == null ? Text(company.name[0]) : null,
                      ),
                      title: Text(company.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(company.ownerName),
                      trailing: isToggling
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3))
                          : Switch(
                              value: company.verified,
                              onChanged: (newValue) {
                                if (!isToggling) {
                                  context.read<AdminBloc>().add(CompanyVerificationToggled(company.id));
                                }
                              },
                            ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}