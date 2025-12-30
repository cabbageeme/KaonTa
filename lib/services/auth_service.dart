import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../repositories/user_repository.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  final UserRepository _userRepository = UserRepository();

  FirebaseAuth get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (e) {
      // ignore: avoid_print
      print('AuthService: FirebaseAuth not available: $e');
      rethrow;
    }
  }

  // Get current user
  User? get currentUser {
    try {
      return _auth.currentUser;
    } catch (e) {
      return null;
    }
  }

  // Stream to listen to authentication state changes
  Stream<User?> get authStateChanges {
    try {
      return _auth.authStateChanges();
    } catch (e) {
      // Return an empty stream if Firebase isn't initialized
      return Stream.value(null);
    }
  }

  // Sign Up with Mobile (generates email from mobile number)
  Future<User?> signUpWithMobile({
    required String mobile,
    required String password,
    required String username,
  }) async {
    if (kIsWeb) {
      throw 'Sign-up on web is not yet configured. Please configure Firebase with FlutterFire CLI.';
    }

    try {
      // Generate email from mobile number
      final email = '$mobile@kaonta.local';

      // ignore: avoid_print
      print('AuthService: attempting createUserWithEmailAndPassword for $email');

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ignore: avoid_print
      print('AuthService: created user ${credential.user?.uid}');

      // Update display name with username
      await credential.user?.updateDisplayName(username);

      // Save user data to Firestore with mobile
      if (credential.user != null) {
        final userModel = UserModel(
          uid: credential.user!.uid,
          email: email,
          username: username.toLowerCase(),
          displayName: username,
          mobile: mobile,
          createdAt: DateTime.now(),
        );
        try {
          await _userRepository.saveUser(userModel);
        } catch (e) {
          // ignore: avoid_print
          print('Failed to save user to Firestore: $e');
          // Don't throw - user auth succeeded even if Firestore save failed
        }
      }

      return credential.user;
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print('AuthService: FirebaseAuthException during signUp: ${e.code} ${e.message}');
      throw _handleAuthError(e);
    } catch (e) {
      // ignore: avoid_print
      print('AuthService: Unknown sign-up error: $e');
      throw 'Sign-up failed: $e';
    }
  }

  // Email & Password Sign Up (legacy - kept for compatibility)
  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    if (kIsWeb) {
      throw 'Sign-up on web is not yet configured. Please configure Firebase with FlutterFire CLI.';
    }

    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name with username
      await credential.user?.updateDisplayName(username);

      // Save user data to Firestore
      if (credential.user != null) {
        final userModel = UserModel(
          uid: credential.user!.uid,
          email: email,
          username: username.toLowerCase(),
          displayName: username,
          createdAt: DateTime.now(),
        );
        try {
          await _userRepository.saveUser(userModel);
        } catch (e) {
          // ignore: avoid_print
          print('Failed to save user to Firestore: $e');
          // Don't throw - user auth succeeded even if Firestore save failed
        }
      }

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'Sign-up failed: $e';
    }
  }

  // Email & Password Login
  Future<User?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (kIsWeb) {
      throw 'Login on web is not yet configured. Please configure Firebase with FlutterFire CLI.';
    }

    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'Login failed: $e';
    }
  }

  // Login using mobile number (maps to synthesized email)
  Future<User?> loginWithMobile({
    required String mobile,
    required String password,
  }) async {
    if (kIsWeb) {
      throw 'Login on web is not yet configured. Please configure Firebase with FlutterFire CLI.';
    }

    try {
      final email = '$mobile@kaonta.local';
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'Login failed: $e';
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Password Reset
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Delete Account
  Future<void> deleteAccount() async {
    try {
      await currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Error Handling
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}