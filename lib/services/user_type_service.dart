/// Service to manage user type selection (customer or owner)
/// This is stored locally during the auth flow
class UserTypeService {
  static final UserTypeService _instance = UserTypeService._internal();

  factory UserTypeService() {
    return _instance;
  }

  UserTypeService._internal();

  String? _selectedUserType;

  /// Get the currently selected user type
  String? get selectedUserType => _selectedUserType;

  /// Set the user type (customer or owner)
  void setUserType(String userType) {
    _selectedUserType = userType;
  }

  /// Clear the user type (typically after successful login)
  void clearUserType() {
    _selectedUserType = null;
  }
}
