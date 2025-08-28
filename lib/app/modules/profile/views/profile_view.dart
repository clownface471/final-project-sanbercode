import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameEditController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF36454F)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(color: Color(0xFF36454F), fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.userProfile.value.uid.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        usernameEditController.text = controller.userProfile.value.username;

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFFB2BEB5),
                        child: Text(
                          controller.userProfile.value.username.isNotEmpty
                              ? controller.userProfile.value.username.substring(0, 1).toUpperCase()
                              : '?',
                          style: const TextStyle(fontSize: 48, color: Color(0xFF36454F), fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.userProfile.value.username,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () {
                              Get.defaultDialog(
                                title: "Ubah Username",
                                content: TextField(
                                  controller: usernameEditController,
                                  autofocus: true,
                                ),
                                textConfirm: "Simpan",
                                textCancel: "Batal",
                                onConfirm: () => controller.updateUsername(usernameEditController.text),
                              );
                            },
                          ),
                        ],
                      ),
                      Text(
                        controller.userProfile.value.email,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.note_alt_outlined, color: Color(0xFF36454F)),
                          const SizedBox(width: 16),
                          const Text("Total Notes Created"),
                          const Spacer(),
                          Text(
                            controller.noteCount.value.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      controller.logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF36454F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Logout'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withAlpha(128),
                child: const Center(child: CircularProgressIndicator(color: Colors.white)),
              ),
          ],
        );
      }),
    );
  }
}