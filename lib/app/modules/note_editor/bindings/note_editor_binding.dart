import 'package:get/get.dart';
import '../controllers/note_editor_controller.dart';

class NoteEditorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoteEditorController>(
      () => NoteEditorController(),
    );
  }
}
