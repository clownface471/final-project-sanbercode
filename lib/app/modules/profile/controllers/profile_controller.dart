import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/user_profile_model.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  var userProfile = UserProfileModel(
    uid: '', email: '', username: 'Loading...', createdAt: Timestamp.now()
  ).obs;
  
  var noteCount = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    userProfile.bindStream(_firestoreService.getUserProfileStream().map((snapshot) {
      if(snapshot.exists) {
        return snapshot.data()!;
      }
      // Fallback jika dokumen belum ada
      return UserProfileModel(uid: _auth.currentUser!.uid, email: _auth.currentUser!.email!, username: '...', createdAt: Timestamp.now());
    }));
    noteCount.bindStream(_firestoreService.getNotesStream().map((snapshot) => snapshot.docs.length));
  }

  Future<void> pickImageAndUpdateProfile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      isLoading.value = true;
      try {
        final photoUrl = await _firestoreService.uploadProfilePicture(File(image.path));
        await _firestoreService.updateUserProfile(userProfile.value.username, photoUrl);
        Get.snackbar("Sukses", "Foto profil berhasil diperbarui.");
      } catch (e) {
        Get.snackbar("Error", "Gagal mengunggah foto: ${e.toString()}");
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> updateUsername(String newUsername) async {
    if (newUsername.trim().isEmpty || newUsername.trim() == userProfile.value.username) {
      Get.back();
      return;
    }
    isLoading.value = true;
    try {
      await _firestoreService.updateUserProfile(newUsername.trim(), userProfile.value.photoUrl);
      Get.back();
      Get.snackbar("Sukses", "Username berhasil diperbarui.");
    } catch (e) {
      Get.snackbar("Error", "Gagal memperbarui username: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Apakah Anda yakin ingin keluar?",
      textConfirm: "Ya, Keluar",
      textCancel: "Batal",
      onConfirm: () async {
        await _auth.signOut();
        Get.offAllNamed(Routes.AUTH);
      },
    );
  }
}
