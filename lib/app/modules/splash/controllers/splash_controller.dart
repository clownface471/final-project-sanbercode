import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:final_project_sanbercode/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Beri jeda 3 detik untuk menampilkan splash screen
    await Future.delayed(const Duration(seconds: 3));

    // Cek status autentikasi pengguna
    if (_auth.currentUser != null) {
      // Jika pengguna sudah login, arahkan ke halaman home
      Get.offAllNamed(Routes.HOME);
    } else {
      // Jika belum login, arahkan ke halaman autentikasi
      Get.offAllNamed(Routes.AUTH);
    }
  }
}
