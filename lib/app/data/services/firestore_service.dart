import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note_model.dart';
import '../models/user_profile_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      return docSnapshot.data();
    }
    return null;
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

  Future<void> updateUserProfile(String username) async {
    await getUserProfileDoc().update({'username': username});
  }
}