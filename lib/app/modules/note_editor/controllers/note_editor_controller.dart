import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/note_model.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/services/ai_service.dart';
import '../../../routes/app_pages.dart';

class NoteEditorController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  NoteModel? existingNote;
  var isAiLoading = false.obs;
  // State untuk menandakan jika data sedang dimuat dari URL
  var isLoadingNote = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Cek apakah ada note yang dikirim sebagai argumen (dari navigasi normal)
    if (Get.arguments != null) {
      existingNote = Get.arguments as NoteModel;
      titleController.text = existingNote!.title;
      contentController.text = existingNote!.content;
    } else if (Get.parameters['id'] != null) {
      // Jika tidak ada argumen, cek parameter URL (untuk kasus refresh web)
      final noteId = Get.parameters['id']!;
      loadNoteFromId(noteId);
    }
  }

  // Fungsi untuk memuat data dari Firestore berdasarkan ID
  Future<void> loadNoteFromId(String id) async {
    isLoadingNote.value = true;
    try {
      final note = await _firestoreService.getNoteById(id);
      if (note != null) {
        existingNote = note;
        titleController.text = note.title;
        contentController.text = note.content;
      } else {
        Get.snackbar("Error", "Catatan tidak ditemukan.");
        Get.offAllNamed(Routes.HOME); // Kembali ke home jika catatan tidak ada
      }
    } finally {
      isLoadingNote.value = false;
    }
  }

  // FUNGSI BARU: Logika untuk tombol kembali
  void handleBackButton() {
    // Cek jika ada perubahan yang belum disimpan
    bool hasChanges = false;
    if (existingNote != null) {
      if (titleController.text != existingNote!.title ||
          contentController.text != existingNote!.content) {
        hasChanges = true;
      }
    } else if (titleController.text.isNotEmpty || contentController.text.isNotEmpty) {
      hasChanges = true;
    }

    if (hasChanges) {
      Get.defaultDialog(
        title: "Perubahan Belum Disimpan",
        middleText: "Apakah Anda yakin ingin keluar?",
        textConfirm: "Ya, Keluar",
        textCancel: "Batal",
        onConfirm: () => Get.offAllNamed(Routes.HOME),
      );
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }

  void summarizeNote() async {
    if (contentController.text.trim().isEmpty) {
      Get.snackbar("Info", "Tidak ada teks untuk diringkas.");
      return;
    }
    isAiLoading.value = true;
    try {
      final prompt = "Ringkas teks berikut menjadi poin-poin penting:\n\n${contentController.text}";
      final result = await AIService.generateText(prompt);
      
      Get.defaultDialog(
        title: "Ringkasan AI",
        content: SizedBox(
          height: Get.height * 0.4, 
          child: SingleChildScrollView(child: Text(result)),
        ),
        textConfirm: "Tutup",
        onConfirm: () => Get.back(),
      );
    } finally {
      isAiLoading.value = false;
    }
  }

  void continueText() async {
    if (contentController.text.trim().isEmpty) {
      Get.snackbar("Info", "Tulis sesuatu terlebih dahulu untuk dilanjutkan.");
      return;
    }
    isAiLoading.value = true;
    try {
      final prompt = "Lanjutkan tulisan berikut secara natural:\n\n${contentController.text}";
      final result = await AIService.generateText(prompt);
      contentController.text += result;
    } finally {
      isAiLoading.value = false;
    }
  }

  void fixGrammar() async {
    if (contentController.text.trim().isEmpty) {
      Get.snackbar("Info", "Tidak ada teks untuk diperbaiki.");
      return;
    }
    isAiLoading.value = true;
    try {
      final prompt = "Perbaiki tata bahasa dan ejaan dari teks berikut tanpa mengubah maknanya:\n\n${contentController.text}";
      final result = await AIService.generateText(prompt);

      Get.defaultDialog(
        title: "Saran Perbaikan AI",
        content: SizedBox(
          height: Get.height * 0.4, 
          child: SingleChildScrollView(child: Text(result)),
        ),
        textCancel: "Tutup",
        textConfirm: "Gunakan Teks Ini",
        onConfirm: () {
          contentController.text = result;
          Get.back();
        },
      );
    } finally {
      isAiLoading.value = false;
    }
  }

  void saveNote() async {
    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      Get.snackbar("Error", "Judul dan isi catatan tidak boleh kosong.");
      return;
    }
    if (existingNote != null) {
      await _firestoreService.updateNote(
        existingNote!.id!,
        titleController.text,
        contentController.text,
      );
      Get.back();
      Get.snackbar("Sukses", "Catatan berhasil diperbarui.");
    } else {
      await _firestoreService.addNote(
        titleController.text,
        contentController.text,
      );
      Get.back();
      Get.snackbar("Sukses", "Catatan berhasil ditambahkan.");
    }
  }

  void deleteNote() async {
    if (existingNote != null) {
      Get.defaultDialog(
        title: "Hapus Catatan",
        middleText: "Apakah Anda yakin ingin menghapus catatan ini?",
        textConfirm: "Ya, Hapus",
        textCancel: "Batal",
        onConfirm: () async {
          await _firestoreService.deleteNote(existingNote!.id!);
          Get.back();
          Get.back();
          Get.snackbar("Sukses", "Catatan berhasil dihapus.");
        },
      );
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }
}