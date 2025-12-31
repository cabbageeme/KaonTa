class AppRoutes {
  // Auth routes
  static const String userType = '/user-type';
  static const String socialLogin = '/social-login';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String locationConfirm = '/location-confirm';
  static const String forgotPassword = '/forgot-password';
  // Customer routes
  static const String customerHome = '/customer-home';
  static const String notifications = '/notifications';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static const String karinderiaMap = '/karinderia-map';
  
  // Owner routes
  static const String ownerDashboard = '/owner-dashboard';
  static const String ownerMenu = '/owner-menu';
  static const String ownerOrders = '/owner-orders';
  static const String ownerProfile = '/owner-profile';
  
  // Shared routes
  static const String welcome = '/welcome';
  static const String splash = '/splash';

  // Utility method to check if route exists
  static bool exists(String route) {
    return [
      userType, socialLogin, login, signup, locationConfirm,
      customerHome, notifications, favorites, profile,
      ownerDashboard, ownerMenu, ownerOrders, ownerProfile,
    ].contains(route);
  }
}