import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String? id;
  final String title;
  final String content;
  final Timestamp createdAt;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory NoteModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt,
    };
  }
}