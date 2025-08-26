import 'package:get/get.dart';

import 'package:final_project_sanbercode/app/modules/auth/bindings/auth_binding.dart';
import 'package:final_project_sanbercode/app/modules/auth/views/auth_view.dart';
import 'package:final_project_sanbercode/app/modules/home/bindings/home_binding.dart';
import 'package:final_project_sanbercode/app/modules/home/views/home_view.dart';
import 'package:final_project_sanbercode/app/modules/note_editor/bindings/note_editor_binding.dart';
import 'package:final_project_sanbercode/app/modules/note_editor/views/note_editor_view.dart';
import 'package:final_project_sanbercode/app/modules/profile/bindings/profile_binding.dart';
import 'package:final_project_sanbercode/app/modules/profile/views/profile_view.dart';
import 'package:final_project_sanbercode/app/modules/splash/bindings/splash_binding.dart';
import 'package:final_project_sanbercode/app/modules/splash/views/splash_view.dart';

abstract class Routes {
  static const SPLASH = '/splash';
  static const AUTH = '/auth';
  static const HOME = '/home';
  static const NOTE_EDITOR = '/note-editor';
  static const PROFILE = '/profile';
}

class AppPages {
  static const initial = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.NOTE_EDITOR,
      page: () => const NoteEditorView(),
      binding: NoteEditorBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
