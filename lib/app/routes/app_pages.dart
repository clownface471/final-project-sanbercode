import 'package:get/get.dart';

import 'package:final_project_sanbercode/app/modules/auth/bindings/auth_binding.dart';
import 'package:final_project_sanbercode/app/modules/auth/views/auth_view.dart';
import 'package:final_project_sanbercode/app/modules/home/bindings/home_binding.dart';
import 'package:final_project_sanbercode/app/modules/home/views/home_view.dart';
import 'package:final_project_sanbercode/app/modules/splash/bindings/splash_binding.dart';
import 'package:final_project_sanbercode/app/modules/splash/views/splash_view.dart';

// Bagian 1: Definisikan nama rute sebagai konstanta.
// Ini menghilangkan kebutuhan akan file terpisah (app_routes.dart).
abstract class Routes {
  static const SPLASH = '/splash';
  static const AUTH = '/auth';
  static const HOME = '/home';
}

// Bagian 2: Hubungkan nama rute dengan halaman (View) dan controllernya (Binding).
class AppPages {
  // Variabel untuk rute awal aplikasi.
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
  ];
}
