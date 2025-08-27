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
    await Future.delayed(const Duration(seconds: 3));
    if (_auth.currentUser != null) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.AUTH);
    }
  }
}