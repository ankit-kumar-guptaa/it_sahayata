import 'package:get/get.dart';
import 'package:it_sahayata/screens/splash_screen.dart';
import 'package:it_sahayata/screens/auth/login_screen.dart';
import 'package:it_sahayata/screens/auth/register_screen.dart';
import 'package:it_sahayata/screens/auth/otp_verification_screen.dart';
import 'package:it_sahayata/screens/customer/customer_home.dart';
import 'package:it_sahayata/screens/customer/ticket_detail_screen.dart';
import 'package:it_sahayata/screens/agent/agent_home.dart';
import '../screens/agent/ticket_detail_agent.dart';
import '../screens/onboarding_screen.dart';

// ============================================
// APP ROUTES
// ============================================
class AppRoutes {
  // Initial route
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';

  // Customer routes
  static const String customerHome = '/customer-home';
  static const String createTicket = '/create-ticket';
  static const String ticketList = '/ticket-list';
  static const String ticketDetail = '/ticket-detail';
  static const String chat = '/chat';
  static const String feedback = '/feedback';

  // Agent routes
  static const String agentHome = '/agent-home';
  static const String assignedTickets = '/assigned-tickets';
  static const String ticketDetailAgent = '/ticket-detail-agent';

  static const String resolution = '/resolution';
  //  static const String ticketDetailAgent = '/ticket-detail-agent';
  // Common routes
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String help = '/help';

  // ============================================
  // ROUTE PAGES
  // ============================================
  static List<GetPage> pages = [
    // Splash
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: onboarding,
      page: () => const OnboardingScreen(),
      transition: Transition.rightToLeft,
    ),
    // Auth pages
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/ticket-detail',
      page: () => const TicketDetailScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: register,
      page: () => const RegisterScreen(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: otpVerification,
      page: () => const OtpVerificationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: ticketDetailAgent,
      page: () => const TicketDetailAgent(),
      transition: Transition.rightToLeft,
    ),
    // Customer pages
    GetPage(
      name: customerHome,
      page: () => const CustomerHome(),
      transition: Transition.fadeIn,
    ),

    // Agent pages
    GetPage(
      name: agentHome,
      page: () => const AgentHome(),
      transition: Transition.fadeIn,
    ),
  ];
}
