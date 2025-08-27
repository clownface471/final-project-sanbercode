import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_editor_controller.dart';

class NoteEditorView extends GetView<NoteEditorController> {
  const NoteEditorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        // Menggunakan fungsi handleBackButton yang baru untuk logika kembali yang aman
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF36454F)),
          onPressed: () => controller.handleBackButton(),
        ),
        actions: [
          // Tampilkan tombol hapus hanya jika sedang mengedit catatan yang sudah ada
          if (controller.existingNote != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Color(0xFF36454F)),
              onPressed: () {
                controller.deleteNote();
              },
            ),
          // Tombol untuk menyimpan catatan
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xFF36454F)),
            onPressed: () {
              controller.saveNote();
            },
          ),
        ],
      ),
      // Bungkus body dengan Obx untuk menangani status loading saat refresh di web
      body: Obx(() {
        // Tampilkan loading jika sedang memuat data dari URL
        if (controller.isLoadingNote.value) {
          return const Center(child: CircularProgressIndicator());
        }
        // Tampilkan editor setelah data siap
        return Stack(
          children: [
            Padding(
              // Beri ruang di bawah agar tidak tertutup panel AI
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              child: Column(
                children: [
                  TextField(
                    controller: controller.titleController,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Note Title...",
                    ),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: controller.contentController,
                      decoration: const InputDecoration.collapsed(
                        hintText: "Start writing here...",
                      ),
                      maxLines: null, // Memungkinkan input multiline
                      expands: true, // Memenuhi ruang yang tersedia
                    ),
                  ),
                ],
              ),
            ),
            // Tampilkan overlay loading jika AI sedang bekerja
            if (controller.isAiLoading.value)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            // Tampilkan panel AI di bagian bawah
            _buildAiPanel(),
          ],
        );
      }),
    );
  }

  // Helper widget untuk membangun panel AI
  Widget _buildAiPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: _buildAiButton(
                icon: Icons.format_list_bulleted,
                label: "Ringkas",
                onPressed: () => controller.summarizeNote(),
              ),
            ),
            Expanded(
              child: _buildAiButton(
                icon: Icons.auto_awesome,
                label: "Lanjutkan",
                onPressed: () => controller.continueText(),
              ),
            ),
            Expanded(
              child: _buildAiButton(
                icon: Icons.task_alt,
                label: "Perbaiki",
                onPressed: () => controller.fixGrammar(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk membangun setiap tombol AI
  Widget _buildAiButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF36454F)),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF36454F)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
