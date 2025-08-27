import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String uid;
  final String email;
  String username;
  String? photoUrl;
  final Timestamp createdAt;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.username,
    this.photoUrl,
    required this.createdAt,
  });

  factory UserProfileModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserProfileModel(
      uid: doc.id,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      photoUrl: data['photoUrl'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
    };
  }
}
