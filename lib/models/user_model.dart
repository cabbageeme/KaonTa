import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String? username;
  final String? displayName;
  final String? photoUrl;
  final String? mobile;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    this.username,
    this.displayName,
    this.photoUrl,
    this.mobile,
    required this.createdAt,
  });

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'mobile': mobile,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      mobile: map['mobile'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Create from Firebase User
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      username: user.displayName,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      createdAt: DateTime.now(),
    );
  }
}