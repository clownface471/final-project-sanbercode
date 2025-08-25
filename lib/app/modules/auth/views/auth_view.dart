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
          child: Obx(
            () => Column(
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

                // Email Field
                _buildTextField(
                  controller: controller.emailController,
                  hint: 'youremail@example.com',
                  label: 'Email',
                ),
                const SizedBox(height: 20),

                // Password Field
                _buildTextField(
                  controller: controller.passwordController,
                  hint: 'Password',
                  label: 'Password',
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                
                // Confirm Password Field (hanya tampil saat register)
                if (!controller.isLogin.value)
                  _buildTextField(
                    controller: controller.confirmPasswordController,
                    hint: 'Confirm Password',
                    label: 'Confirm Password',
                    isPassword: true,
                  ),
                if (!controller.isLogin.value) const SizedBox(height: 40),

                // Tombol Aksi (Login/Register)
                _buildAuthButton(),
                const SizedBox(height: 24),

                // Teks untuk beralih mode
                _buildToggleText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String label,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
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

  Widget _buildAuthButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : () {
                if (controller.isLogin.value) {
                  controller.login();
                } else {
                  controller.register();
                }
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
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(controller.isLogin.value ? 'Login' : 'Register'),
      ),
    );
  }

  Widget _buildToggleText() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black54, fontSize: 14),
          children: [
            TextSpan(
              text: controller.isLogin.value
                  ? "Don't have an account? "
                  : "Already have an account? ",
            ),
            TextSpan(
              text: controller.isLogin.value ? 'Register here' : 'Login here',
              style: const TextStyle(
                color: Color(0xFF36454F),
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  controller.isLogin.value = !controller.isLogin.value;
                },
            ),
          ],
        ),
      ),
    );
  }
}
