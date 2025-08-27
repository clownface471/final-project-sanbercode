import 'package:final_project_sanbercode/app/data/services/ai_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:final_project_sanbercode/app/data/models/note_model.dart';
import 'package:final_project_sanbercode/app/data/services/firestore_service.dart';

class NoteEditorController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  
  var isLoading = false.obs;
  var summarizedText = ''.obs;
  // Variabel untuk menampung note yang sedang diedit (jika ada)
  NoteModel? existingNote;

  @override
  void onInit() {
    super.onInit();
    // Cek apakah ada note yang dikirim sebagai argumen
    if (Get.arguments != null) {
      existingNote = Get.arguments as NoteModel;
      titleController.text = existingNote!.title;
      contentController.text = existingNote!.content;
    }
  }

  void saveNote() async {
    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      Get.snackbar("Error", "Judul dan isi catatan tidak boleh kosong.");
      return;
    }

    if (existingNote != null) {
      // Update catatan yang ada
      await _firestoreService.updateNote(
        existingNote!.id!,
        titleController.text,
        contentController.text,
      );
      Get.back(); // Kembali ke halaman home
      Get.snackbar("Sukses", "Catatan berhasil diperbarui.");
    } else {
      // Tambah catatan baru
      await _firestoreService.addNote(
        titleController.text,
        contentController.text,
      );
      Get.back(); // Kembali ke halaman home
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
          Get.back(); // Tutup dialog
          Get.back(); // Kembali ke halaman home
          Get.snackbar("Sukses", "Catatan berhasil dihapus.");
        },
      );
    }
  }

  Future<void> generateSummary() async {
  await _runAI(
    "Summarize the following text in a concise, single paragraph. The summary must be in the same language as the original text:\n\n${contentController.text}",
  );
}

Future<void> generateContinuation() async {
  await _runAI(
    "You are a helpful AI assistant. Your task is to generate a paragraph of text that is relevant to the user's provided input. The generated text must be in the same language as the original user input:\n\n${contentController.text}",
  );
}

Future<void> fixText() async {
  await _runAI(
    "Review and correct the following text for any grammatical errors, spelling mistakes, or awkward phrasing. The corrected text must be in the same language as the original text. Do not change the overall meaning:\n\n${contentController.text}",
  );
}

  Future<void> _runAI(String prompt) async{
    try {
      
      isLoading.value = true;
      final result = await AIService.generateText(prompt);
      summarizedText.value = result;

      Get.defaultDialog(
        title: 'Hasil AI',
        middleText: result,
        textConfirm: 'OK',
        onConfirm: () => Get.back(),
      );

    } catch (e) {
      Get.snackbar("Error", "Gagal menghasilkan teks AI");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }
}
