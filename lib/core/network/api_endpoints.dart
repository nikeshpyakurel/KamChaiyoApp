class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = "http://192.168.1.5:8000/api/v1/";
  // static const String baseUrl = "http://localhost:8000/api/v1/";

  static const String login = "users/login-mobile";
  static const String register = "users/register-mobile";
  static const String currentUser = "users/current-user";
  static const String updateProfile = "users/update-profile";

  static const String adminGetAllUsers = "admin/users";
  static const String adminGetAllCompanies = "admin/companies";

  static const String adminCompanies = "admin/companies";

  static const String adminChatbotSettings = "admin/chatbot-settings";

  static const String jobs = "jobs";

  static const String company = "companies";

  static const String recruiterStats = "recruiter-dashboard/stats";

  static const String applications = "applications";
  static const String publicJobDetail = "jobs/public/";
  static const String chatbotQuery = "chatbot/query";


  static const String myApplications = "applications/my-applications";
  static const String publicJobs = "jobs/public"; 
  static const String applyForJob = "applications/apply/"; 


  static const String userProfile = "users/profile";
  static const String scheduleInterview = "interviews/schedule";
  static const String myInterviews = "interviews/my-interviews";
  static const String chats = "chats";
  static const String chatMessages = "chats/messages";
  static const String publicCompanies = "companies/public"; 
  static const String publicCompanyDetail = "companies/public/"; 

   static const String getJobRecommendations = "users/recommendations"; 

}
