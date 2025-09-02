import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_editor_controller.dart';

class NoteEditorView extends GetView<NoteEditorController> {
  const NoteEditorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Tidak perlu lagi mendefinisikan warna AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => controller.handleBackButton(),
        ),
        actions: [
          if (controller.existingNote != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                controller.deleteNote();
              },
            ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              controller.saveNote();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingNote.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              child: Column(
                children: [
                  TextField(
                    controller: controller.titleController,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Note Title...",
                    ),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: controller.contentController,
                      decoration: const InputDecoration.collapsed(
                        hintText: "Start writing here...",
                      ),
                      maxLines: null,
                      expands: true,
                    ),
                  ),
                ],
              ),
            ),
            if (controller.isAiLoading.value)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            _buildAiPanel(context), // <-- Kirim context ke build panel
          ],
        );
      }),
    );
  }

  Widget _buildAiPanel(BuildContext context) { // <-- Terima context
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(12),
        // Gunakan warna dari tema
        color: Theme.of(context).cardColor,
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

  Widget _buildAiButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    // Tombol AI bisa tetap sama, warnanya akan mengikuti tema
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}