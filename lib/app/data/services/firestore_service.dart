import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project_sanbercode/app/data/models/note_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mendapatkan collection 'notes' untuk pengguna yang sedang login
  CollectionReference<NoteModel> getNotesCollection() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .withConverter<NoteModel>(
          fromFirestore: (snapshot, _) => NoteModel.fromFirestore(snapshot),
          toFirestore: (note, _) => note.toFirestore(),
        );
  }

  // CREATE: Menambahkan catatan baru
  Future<void> addNote(String title, String content) async {
    final notesCollection = getNotesCollection();
    await notesCollection.add(
      NoteModel(
        title: title,
        content: content,
        createdAt: Timestamp.now(),
      ),
    );
  }

  // READ: Mendapatkan stream (aliran data real-time) dari semua catatan
  Stream<QuerySnapshot<NoteModel>> getNotesStream() {
    return getNotesCollection().orderBy('createdAt', descending: true).snapshots();
  }

  // UPDATE: Memperbarui catatan yang sudah ada
  Future<void> updateNote(String id, String title, String content) async {
    await getNotesCollection().doc(id).update({
      'title': title,
      'content': content,
    });
  }

  // DELETE: Menghapus catatan
  Future<void> deleteNote(String id) async {
    await getNotesCollection().doc(id).delete();
  }
}
