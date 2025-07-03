part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();
  @override
  List<Object> get props => [];
}

class AdminDataFetched extends AdminEvent {}
class CompanyVerificationToggled extends AdminEvent {
  final String companyId;
  const CompanyVerificationToggled(this.companyId);
  @override
  List<Object> get props => [companyId];
}
class ChatbotSettingsUpdated extends AdminEvent {
  final String newPrompt;
  const ChatbotSettingsUpdated(this.newPrompt);
  @override
  List<Object> get props => [newPrompt];
}