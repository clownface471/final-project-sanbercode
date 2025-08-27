import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  "ARCHI",
                  style: TextStyle(
                    color: Color(0xFF36454F),
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              
              // Tampilkan form Login atau Register berdasarkan state
              Obx(() => controller.isLoginView.value ? _buildLoginForm() : _buildRegisterForm()),
              
              const SizedBox(height: 24),
              _buildToggleText(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk Form Login
  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(
          controller: controller.loginInputController,
          label: 'Email atau Username',
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: controller.loginPasswordController,
          label: 'Password',
          isPassword: true,
        ),
        const SizedBox(height: 40),
        _buildAuthButton(isLogin: true),
      ],
    );
  }

  // Widget untuk Form Register
  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(
          controller: controller.registerUsernameController,
          label: 'Username',
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: controller.registerEmailController,
          label: 'Email',
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: controller.registerPasswordController,
          label: 'Password',
          isPassword: true,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: controller.registerConfirmPasswordController,
          label: 'Confirm Password',
          isPassword: true,
        ),
        const SizedBox(height: 40),
        _buildAuthButton(isLogin: false),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFB2BEB5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF36454F)),
        ),
      ),
    );
  }

  Widget _buildAuthButton({required bool isLogin}) {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading.value ? null : () {
          isLogin ? controller.login() : controller.register();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF36454F),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                height: 20, width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(isLogin ? 'Login' : 'Register'),
      ),
    );
  }

  Widget _buildToggleText() {
    return Center(
      child: Obx(
        () => RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black54, fontSize: 14),
            children: [
              TextSpan(
                text: controller.isLoginView.value
                    ? "Don't have an account? "
                    : "Already have an account? ",
              ),
              TextSpan(
                text: controller.isLoginView.value ? 'Register here' : 'Login here',
                style: const TextStyle(
                  color: Color(0xFF36454F),
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    controller.isLoginView.value = !controller.isLoginView.value;
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
