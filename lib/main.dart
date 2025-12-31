import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/auth/user_type_screen.dart';
import 'screens/auth/social_login_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/shared/location_confirm_screen.dart';
import 'screens/owner/owner_home_screen.dart'; 
import 'screens/owner/owner_profile_screen.dart';
import 'screens/owner/owner_menu_screen.dart';
import 'screens/customer/customer_home_screen.dart';
import 'screens/customer/notifications_screen.dart';
import 'screens/customer/favorites_screen.dart';
import 'screens/customer/profile_screen.dart';
import 'screens/customer/karinderia_map_screen.dart';
import 'routes/app_routes.dart';
import 'routes/navigation_service.dart';
import 'screens/shared/welcome_screen.dart';
import 'screens/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // ignore: avoid_print
    print('Firebase.initializeApp() error: $e');
  }

  runApp(const KarinderiaApp());
}

class KarinderiaApp extends StatelessWidget {
  const KarinderiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      title: 'Karinderia Spotlight',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => SplashScreen(),
        AppRoutes.welcome: (context) => const WelcomeScreen(),        
        AppRoutes.userType: (context) => const UserTypeScreen(),
        AppRoutes.socialLogin: (context) => const SocialLoginScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.signup: (context) => const SignUpScreen(),
        AppRoutes.locationConfirm: (context) => const LocationConfirmScreen(),
        // Use Screen/Page widgets instead of App wrappers to avoid nested MaterialApp
        AppRoutes.customerHome: (context) => const KarinderiaHomePage(),
        AppRoutes.ownerDashboard: (context) => const OwnerDashboard(),
        AppRoutes.notifications: (context) => const EnhancedNotificationsScreen(),
        AppRoutes.favorites: (context) => const EnhancedFavoritesScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
        AppRoutes.karinderiaMap: (context) => const KarinderiaMapScreen(),
        AppRoutes.ownerProfile: (context) => const OwnerProfileScreen(),
        '/owner-menu': (context) => const OwnerMenuScreen(),
      },
    );
  }
}