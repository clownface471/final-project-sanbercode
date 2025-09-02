import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../data/models/note_model.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var notes = <NoteModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    notes.bindStream(_firestoreService.getNotesStream().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()).toList()));
  }

  void goToAddPage() {
    Get.toNamed(Routes.NOTE_EDITOR);
  }

  void goToEditPage(NoteModel note) {
    Get.toNamed('${Routes.NOTE_EDITOR}/${note.id}');
  }
  
  void goToProfilePage() {
    Get.toNamed(Routes.PROFILE);
  }

  Future<void> deleteNoteFromHome(String noteId) async {
    try {
      await _firestoreService.deleteNote(noteId);
      Get.snackbar(
        "Sukses",
        "Catatan berhasil dihapus.",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12), 
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal menghapus catatan: $e",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12), 
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.AUTH);
  }
}