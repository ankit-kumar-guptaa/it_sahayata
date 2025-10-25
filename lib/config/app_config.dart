class AppConfig {
  // ============================================
  // API BASE URL
  // ============================================
  // Local development ke liye
  static const String baseUrl =
      'https://apis.itsahayata.com'; // Android Emulator
  // static const String baseUrl = 'http://localhost/it-sahayata-api'; // iOS Simulator
  // static const String baseUrl = 'http://192.168.1.100/it-sahayata-api'; // Real device (apna IP daal)

  // Production ke liye
  // static const String baseUrl = 'https://itsahayata.com/api';

  // ============================================
  // API ENDPOINTS
  // ============================================
  static const String apiAuth = '$baseUrl/api/auth';
  static const String apiTickets = '$baseUrl/api/tickets';
  static const String apiMessages = '$baseUrl/api/messages';
  static const String apiFeedback = '$baseUrl/api/feedback';
  static const String apiAgent = '$baseUrl/api/agent';
  static const String apiAdmin = '$baseUrl/api/admin';

  // Auth endpoints
  static const String loginEndpoint = '$apiAuth/login.php';
  static const String registerEndpoint = '$apiAuth/register.php';
  static const String verifyOtpEndpoint = '$apiAuth/verify_otp.php';
  static const String resendOtpEndpoint = '$apiAuth/resend_otp.php';
  static const String logoutEndpoint = '$apiAuth/logout.php';

  // Ticket endpoints
  static const String createTicketEndpoint = '$apiTickets/create.php';
  static const String listTicketsEndpoint = '$apiTickets/list.php';
  static const String ticketDetailEndpoint = '$apiTickets/detail.php';
  static const String updateStatusEndpoint = '$apiTickets/update_status.php';

  // Message endpoints
  static const String sendMessageEndpoint = '$apiMessages/send.php';
  static const String getMessagesEndpoint = '$apiMessages/get_messages.php';
  static const String uploadFileEndpoint = '$apiMessages/upload_file.php';

  // Feedback endpoint
  static const String submitFeedbackEndpoint = '$apiFeedback/submit.php';

  // Agent endpoints
  static const String assignedTicketsEndpoint =
      '$apiAgent/assigned_tickets.php';
  static const String updateResolutionEndpoint =
      '$apiAgent/update_resolution.php';

  // ============================================
  // APP CONSTANTS
  // ============================================
  static const String appName = 'IT Sahayata';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Tech Trouble? IT Sahayata Hai Na!';

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String roleKey = 'user_role';
  static const String isLoggedInKey = 'is_logged_in';

  // Request timeout
  static const Duration timeoutDuration = Duration(seconds: 30);

  // File upload limits
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png'];
  static const List<String> allowedFileTypes = ['pdf', 'doc', 'docx'];

  // Pagination
  static const int itemsPerPage = 20;

  // ============================================
  // TICKET CATEGORIES
  // ============================================
  static const List<String> ticketCategories = [
    'Hardware',
    'Software',
    'Internet',
    'Other',
  ];

  static const Map<String, String> categoryIcons = {
    'hardware': '🖥️',
    'software': '💻',
    'internet': '🌐',
    'other': '🔧',
  };

  // ============================================
  // PRIORITY LEVELS
  // ============================================
  static const List<String> priorityLevels = [
    'Low',
    'Medium',
    'High',
  ];

  // ============================================
  // TICKET STATUS
  // ============================================
  static const List<String> ticketStatuses = [
    'Pending',
    'Assigned',
    'In Progress',
    'Resolved',
    'Closed',
  ];

  // ============================================
  // VALIDATION RULES
  // ============================================
  static const int minPasswordLength = 6;
  static const int minDescriptionLength = 10;
  static const int maxDescriptionLength = 500;

  // ============================================
  // ERROR MESSAGES
  // ============================================
  static const String networkError =
      'No internet connection. Please check your network.';
  static const String serverError = 'Server error. Please try again later.';
  static const String timeoutError = 'Request timeout. Please try again.';
  static const String unauthorizedError =
      'Session expired. Please login again.';

  // ============================================
  // SUCCESS MESSAGES
  // ============================================
  static const String loginSuccess = 'Login successful!';
  static const String registerSuccess =
      'Registration successful! Please verify OTP.';
  static const String ticketCreatedSuccess = 'Ticket created successfully!';
  static const String feedbackSuccess = 'Thank you for your feedback!';
}
