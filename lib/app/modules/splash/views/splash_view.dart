import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF36454F),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 150,),
              const Text(
                "ARCHI",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(26),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.edit_document,
                  color: Colors.white,
                  size: 80,
                ),
              ),
              const SizedBox(height: 24),
              const Spacer(),
              const Text(
                "Version 1.0.0",
                style: TextStyle(
                  color: Color(0xFFB2BEB5),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}