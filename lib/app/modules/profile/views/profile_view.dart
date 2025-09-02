import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/theme_controller.dart'; // Pastikan ini di-import
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameEditController = TextEditingController();
    // Panggil ThemeController langsung dari view
    final ThemeController themeController = Get.find();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // Get.back() akan berfungsi setelah error di-resolve
          onPressed: () => Get.back(),
        ),
        title: const Text('My Profile'),
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  themeController.isDarkMode.value
                      ? Icons.wb_sunny
                      : Icons.nightlight_round,
                ),
                onPressed: () {
                  // Panggil fungsi langsung dari themeController
                  themeController.switchTheme();
                },
                tooltip: 'Ubah Tema',
              )),
        ],
      ),
      // ... sisa kode tidak perlu diubah, sudah benar dari perbaikan sebelumnya ...
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
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          controller.userProfile.value.username.isNotEmpty
                              ? controller.userProfile.value.username
                                  .substring(0, 1)
                                  .toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 48,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              controller.userProfile.value.username,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
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
                                onConfirm: () => controller
                                    .updateUsername(usernameEditController.text),
                              );
                            },
                          ),
                        ],
                      ),
                      Text(
                        controller.userProfile.value.email,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.note_alt_outlined,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 16),
                          const Text("Total Notes Created"),
                          const Spacer(),
                          Obx(() => Text(
                                controller.noteCount.value.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => controller.logout(),
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
            Obx(() => controller.isLoading.value
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                : const SizedBox.shrink()),
          ],
        );
      }),
    );
  }
}