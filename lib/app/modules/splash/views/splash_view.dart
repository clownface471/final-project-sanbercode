import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Memanggil controller agar terinisialisasi
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: const Color(0xFF36454F), // Charcoal
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ganti dengan logo/ikon dari Figma
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.edit_document, // Placeholder icon
                color: Colors.white,
                size: 80,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "ARCHI", 
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const Spacer(),
            const Text(
              "Version 1.0.0",
              style: TextStyle(
                color: Color(0xFFB2BEB5), // Ash Grey
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

