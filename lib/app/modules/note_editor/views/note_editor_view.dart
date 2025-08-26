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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF36454F)),
          onPressed: () => Get.back(),
        ),
        actions: [
          // Tampilkan tombol hapus hanya jika sedang mengedit
          if (controller.existingNote != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Color(0xFF36454F)),
              onPressed: () {
                controller.deleteNote();
              },
            ),
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xFF36454F)),
            onPressed: () {
              controller.saveNote();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
      // Di sini kita akan tambahkan Panel AI nanti
    );
  }
}
