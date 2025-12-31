import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String? username;
  final String? displayName;
  final String? photoUrl;
  final String? mobile;
  final String? userType; // 'customer' or 'owner'
  final double? latitude; // Owner's karinderia location
  final double? longitude;
  final bool? isStoreOpen; // Owner store status
  final String? storeName; // Owner's karinderia name
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    this.username,
    this.displayName,
    this.photoUrl,
    this.mobile,
    this.userType,
    this.latitude,
    this.longitude,
    this.isStoreOpen,
    this.storeName,
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
      'userType': userType,
      'latitude': latitude,
      'longitude': longitude,
      'isStoreOpen': isStoreOpen,
      'storeName': storeName,
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
      userType: map['userType'],
      latitude: map['latitude'] as double?,
      longitude: map['longitude'] as double?,
      isStoreOpen: map['isStoreOpen'] as bool?,
      storeName: map['storeName'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Create from Firebase User
  factory UserModel.fromFirebaseUser(User user, {String? userType}) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      username: user.displayName,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      userType: userType,
      createdAt: DateTime.now(),
    );
  }
}