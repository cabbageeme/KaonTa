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
      backgroundColor: Color.fromARGB(255, 243, 156, 33),
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: Duration(milliseconds: 500),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x66000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.restaurant,
                  size: 60,
                  color: Color.fromARGB(255, 33, 243, 68),
                ),
              ),
              
              SizedBox(height: 32),
              
              // App Title
              Text(
                'KaonTa',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              
              SizedBox(height: 16),
              
              // Tagline
              Text(
                'Your Local Food Hub',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.2,
                ),
              ),
              
              SizedBox(height: 60),
              
              // Loading indicator
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}