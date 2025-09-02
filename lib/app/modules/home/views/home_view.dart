import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              controller.goToProfilePage();
            },
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.notes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_add_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No Notes Yet",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Press the '+' button to create your first note.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.notes.length,
            itemBuilder: (context, index) {
              final note = controller.notes[index];
              return Dismissible(
                key: Key(note.id!),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.redAccent,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                // --- PERBAIKAN DI SINI ---
                confirmDismiss: (direction) async {
                  // Tambahkan onConfirm dan onCancel
                  return await Get.defaultDialog<bool>(
                    title: "Hapus Catatan",
                    middleText:
                        "Apakah Anda yakin ingin menghapus catatan ini?",
                    textConfirm: "Ya, Hapus",
                    textCancel: "Batal",
                    // Ini akan mengembalikan 'true' saat ditekan
                    onConfirm: () => Get.back(result: true),
                    // Ini akan mengembalikan 'false' saat ditekan
                    onCancel: () => Get.back(result: false),
                  );
                },
                // -------------------------
                onDismissed: (direction) {
                  controller.deleteNoteFromHome(note.id!);
                },
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    title: Text(note.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat.yMMMd()
                              .add_jm()
                              .format(note.createdAt.toDate()),
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    onTap: () {
                      controller.goToEditPage(note);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.goToAddPage();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}