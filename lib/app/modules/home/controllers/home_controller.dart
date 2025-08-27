import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../data/models/note_model.dart';
import '../../../data/services/firestore_service.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var notes = <NoteModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    notes.bindStream(_firestoreService.getNotesStream().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()).toList()));
  }

  void goToAddPage() {
    Get.toNamed(Routes.NOTE_EDITOR);
  }

  void goToEditPage(NoteModel note) {
    // Navigasi dengan menyertakan ID di URL
    Get.toNamed('${Routes.NOTE_EDITOR}/${note.id}');
  }
  
  void goToProfilePage() {
    Get.toNamed(Routes.PROFILE);
  }

  void logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.AUTH);
  }
}