import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  
  // Controllers untuk Login
  final loginInputController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Controllers untuk Register
  final registerUsernameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();

  var isLoginView = true.obs;
  var isLoading = false.obs;

  Future<void> login() async {
    if (loginInputController.text.isEmpty || loginPasswordController.text.isEmpty) {
      Get.snackbar("Error", "Input dan Password tidak boleh kosong.");
      return;
    }

    isLoading.value = true;
    try {
      String email;
      final userInput = loginInputController.text.trim();

      if (userInput.contains('@')) {
        email = userInput;
      } else {
        final foundEmail = await _firestoreService.getEmailFromUsername(userInput);
        if (foundEmail == null) {
          throw FirebaseAuthException(code: 'user-not-found', message: 'Username tidak ditemukan.');
        }
        email = foundEmail;
      }

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: loginPasswordController.text.trim(),
      );
      Get.offAllNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error Login", e.message ?? "Terjadi kesalahan");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (registerUsernameController.text.isEmpty ||
        registerEmailController.text.isEmpty ||
        registerPasswordController.text.isEmpty ||
        registerConfirmPasswordController.text.isEmpty) {
      Get.snackbar("Error", "Semua field harus diisi.");
      return;
    }
    if (registerPasswordController.text != registerConfirmPasswordController.text) {
      Get.snackbar("Error", "Password dan Konfirmasi Password tidak cocok.");
      return;
    }
    isLoading.value = true;
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: registerEmailController.text.trim(),
        password: registerPasswordController.text.trim(),
      );

      if (userCredential.user != null) {
        await _firestoreService.createUserProfile(userCredential.user!, registerUsernameController.text.trim());
      }

      Get.snackbar("Sukses", "Akun berhasil dibuat. Silakan login.");
      isLoginView.value = true;
      _clearRegisterFields();
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error Register", e.message ?? "Terjadi kesalahan");
    } finally {
      isLoading.value = false;
    }
  }
  
  void _clearRegisterFields() {
      registerUsernameController.clear();
      registerEmailController.clear();
      registerPasswordController.clear();
      registerConfirmPasswordController.clear();
  }

  @override
  void onClose() {
    loginInputController.dispose();
    loginPasswordController.dispose();
    registerUsernameController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
    super.onClose();
  }
}
