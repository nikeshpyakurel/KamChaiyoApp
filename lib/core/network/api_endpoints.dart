
class ApiEndpoints {
  ApiEndpoints._();

  // static const String baseUrl = "http://10.0.2.2:8000/api/v1/"; 
  static const String baseUrl = "http://localhost:8000/api/v1/";

  // Auth Endpoints
  static const String login = "users/login";
  static const String register = "users/register";
  static const String currentUser = "users/current-user";
  static const String updateProfile = "users/update-profile";

  // Admin Endpoints
  static const String adminGetAllUsers = "admin/users";
  static const String adminGetAllCompanies = "admin/companies";
  
  // THE FIX: Define the base path for admin company actions
  static const String adminCompanies = "admin/companies"; 
  
  static const String adminChatbotSettings = "admin/chatbot-settings";

  // Job Endpoints
  static const String jobs = "jobs";

  // Recruiter Dashboard Endpoints
  static const String recruiterStats = "recruiter-dashboard/stats";
}