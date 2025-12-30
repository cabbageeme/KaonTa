import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../routes/navigation_service.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startDissolveAnimation();
  }

  void _startDissolveAnimation() async {
    // Wait for 1.5 seconds
    await Future.delayed(Duration(milliseconds: 1500));
    // Debug log
    // ignore: avoid_print
    print('[Splash] delay complete, starting dissolve');
    // Start dissolve animation
    if (mounted) {
      setState(() {
        _opacity = 0.0;
      });
    }

    // Navigate after animation completes
    await Future.delayed(Duration(milliseconds: 500));
    // Debug log
    // ignore: avoid_print
    print('[Splash] animation complete, navigating...');

    if (mounted) {
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() {
    // Check if user is logged in
    // If running on web and Firebase isn't configured, skip auth check
    if (kIsWeb) {
      // ignore: avoid_print
      print('[Splash] running on web - skipping Firebase auth check');
      final targetWeb = AppRoutes.welcome;
      if (NavigationService.navigatorKey.currentState != null) {
        NavigationService.navigateAndRemoveUntil(targetWeb);
        return;
      }
      Navigator.of(context).pushNamedAndRemoveUntil(targetWeb, (route) => false);
      return;
    }

    User? user;
    try {
      user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      // ignore: avoid_print
      print('[Splash] FirebaseAuth access error: $e');
      user = null;
    }

    // Debug: report auth state and navigator availability
    // ignore: avoid_print
    print('[Splash] currentUser: \\${user?.uid}');
    // ignore: avoid_print
    print('[Splash] navigatorKey state: \\${NavigationService.navigatorKey.currentState}');

    final target = (user != null) ? AppRoutes.userType : AppRoutes.welcome;

    // Prefer NavigationService but fallback to Navigator.of(context)
    try {
      if (NavigationService.navigatorKey.currentState != null) {
        NavigationService.navigateAndRemoveUntil(target);
        return;
      }
    } catch (e) {
      // ignore: avoid_print
      print('[Splash] NavigationService failed: \\$e');
    }

    // Fallback using context navigator
    Navigator.of(context).pushNamedAndRemoveUntil(target, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: Duration(milliseconds: 500),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 200,
              ),
              
              SizedBox(height: 40),
              
              // Motto
              _buildMotto(),
              
              SizedBox(height: 60),
              
              // Loading indicator
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE8B931)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMotto() {
    return Column(
      children: [
        Text(
          'Know What\'s Cooking,',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFFE8B931),
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Eat Without Waiting',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFFE8B931),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}