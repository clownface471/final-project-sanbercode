import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/note_model.dart';
import '../models/user_profile_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // --- Note Management ---
  CollectionReference<NoteModel> getNotesCollection() {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");
    return _db.collection('users').doc(user.uid).collection('notes').withConverter<NoteModel>(
          fromFirestore: (snapshot, _) => NoteModel.fromFirestore(snapshot),
          toFirestore: (note, _) => note.toFirestore(),
        );
  }

  Stream<QuerySnapshot<NoteModel>> getNotesStream() {
    return getNotesCollection().orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> addNote(String title, String content) async {
    await getNotesCollection().add(NoteModel(title: title, content: content, createdAt: Timestamp.now()));
  }

  Future<void> updateNote(String id, String title, String content) async {
    await getNotesCollection().doc(id).update({'title': title, 'content': content});
  }

  Future<void> deleteNote(String id) async {
    await getNotesCollection().doc(id).delete();
  }

  Future<NoteModel?> getNoteById(String id) async {
    final docSnapshot = await getNotesCollection().doc(id).get();
    if (docSnapshot.exists) {
      // .data() akan otomatis mengkonversi ke NoteModel berkat withConverter
      return docSnapshot.data();
    }
    return null; // Kembalikan null jika dokumen tidak ditemukan
  }

  // --- User Profile Management ---

  DocumentReference<UserProfileModel> getUserProfileDoc() {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");
    return _db.collection('users').doc(user.uid).withConverter<UserProfileModel>(
          fromFirestore: (snapshot, _) => UserProfileModel.fromFirestore(snapshot),
          toFirestore: (profile, _) => profile.toFirestore(),
        );
  }

  Future<void> createUserProfile(User user, String username) async {
    final newUserProfile = UserProfileModel(
      uid: user.uid,
      email: user.email!,
      username: username,
      createdAt: Timestamp.now(),
    );
    await _db.collection('users').doc(user.uid).set(newUserProfile.toFirestore());
  }

  Stream<DocumentSnapshot<UserProfileModel>> getUserProfileStream() {
    return getUserProfileDoc().snapshots();
  }

  Future<String?> getEmailFromUsername(String username) async {
    final querySnapshot = await _db.collection('users').where('username', isEqualTo: username).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data()['email'] as String?;
    }
    return null;
  }

  Future<String> uploadProfilePicture(File image) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");
    final storageRef = _storage.ref().child('profile_pictures').child(user.uid);
    final uploadTask = await storageRef.putFile(image);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<void> updateUserProfile(String username, String? photoUrl) async {
    final updateData = <String, dynamic>{'username': username};
    if (photoUrl != null) {
      updateData['photoUrl'] = photoUrl;
    }
    await getUserProfileDoc().update(updateData);
  }
}
