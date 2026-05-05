import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final supabase = Supabase.instance.client;

  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController gerejaController = TextEditingController();
  final TextEditingController kotaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    gerejaController.dispose();
    kotaController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String gereja = gerejaController.text.trim();
    String kota = kotaController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // cek field kosong
    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        gereja.isEmpty ||
        kota.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showErrorPopup('Semua field harus diisi');
      return;
    }

    // cek email valid
    if (!email.contains('@') || !email.contains('.')) {
      _showErrorPopup('Format email tidak valid');
      return;
    }

    // cek nomor hp
    if (!phone.startsWith('08')) {
      _showErrorPopup('Nomor HP harus diawali 08');
      return;
    }

    // cek password sama
    if (password != confirmPassword) {
      _showErrorPopup('Password tidak sama');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // hanya daftar ke Supabase Auth dulu
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (user != null) {
        _showSuccessPopup();
      } else {
        _showErrorPopup('Register gagal. Coba lagi.');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showErrorPopup('Terjadi error: $e');
    }
  }

  void _showSuccessPopup() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Berhasil',
      barrierColor: Colors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
            Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFFFD700),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.orange,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA726)],
                          ),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Registrasi Berhasil',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Akun berhasil dibuat.\nSilakan cek email untuk verifikasi.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // tutup popup
                            Navigator.pop(context); // balik ke login
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFA726),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  void _showErrorPopup(String message) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Error',
      barrierColor: Colors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
            Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFFFA726),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.orange,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Icon(
                        Icons.info_outline,
                        color: Colors.orange,
                        size: 52,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Perhatian',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        message,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFA726),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Tutup',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_image.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0))),
          SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          const SizedBox(height: 60),
                          const Icon(
                            Icons.church,
                            size: 100,
                            color: Color(0xFFFFD700),
                          ),
                          const Text('HALAMAN REGISTRASI', style: h1),
                          const SizedBox(height: 40),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                _buildTextField(
                                  controller: nameController,
                                  hint: 'Masukkan nama Anda',
                                  label: 'Nama',
                                  icon: Icons.person_outline,
                                ),
                                const Divider(height: 1, color: Colors.grey),
                                _buildTextField(
                                  controller: emailController,
                                  hint: 'Masukkan email Anda',
                                  label: 'Email',
                                  icon: Icons.email_outlined,
                                ),
                                const Divider(height: 1, color: Colors.grey),
                                _buildTextField(
                                  controller: phoneController,
                                  hint: 'Contoh: 08xxxxxxxx',
                                  label: 'Nomor HP',
                                  icon: Icons.phone_outlined,
                                ),
                                const Divider(height: 1, color: Colors.grey),
                                _buildTextField(
                                  controller: gerejaController,
                                  hint: 'Contoh: Paroki Santo Paulus',
                                  label: 'Nama Gereja',
                                  icon: Icons.church_outlined,
                                ),
                                const Divider(height: 1, color: Colors.grey),
                                _buildTextField(
                                  controller: kotaController,
                                  hint: 'Masukkan kota',
                                  label: 'Kota',
                                  icon: Icons.location_on_outlined,
                                ),
                                const Divider(height: 1, color: Colors.grey),
                                _buildTextField(
                                  controller: passwordController,
                                  hint: 'Masukkan password Anda',
                                  label: 'Password',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                ),
                                const Divider(height: 1, color: Colors.grey),
                                _buildTextField(
                                  controller: confirmPasswordController,
                                  hint: 'Masukkan kembali password Anda',
                                  label: 'Konfirmasi Password',
                                  icon: Icons.lock_outline,
                                  isConfirmPassword: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap: isLoading ? null : _handleRegister,
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: orangeGradient,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: isLoading
                                    ? const SizedBox(
                                        width: 28,
                                        height: 28,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : const Text(
                                        'Register',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Sudah punya akun? Kembali ke Login',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isConfirmPassword = false,
  }) {
    bool obscureText = false;

    if (isPassword) {
      obscureText = isPasswordObscure;
    } else if (isConfirmPassword) {
      obscureText = isConfirmPasswordObscure;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.blueGrey),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.blueGrey),
          hintText: hint,
          suffixIcon: isPassword
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      isPasswordObscure = !isPasswordObscure;
                    });
                  },
                  child: Text(
                    isPasswordObscure ? 'SHOW' : 'HIDE',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : isConfirmPassword
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      isConfirmPasswordObscure = !isConfirmPasswordObscure;
                    });
                  },
                  child: Text(
                    isConfirmPasswordObscure ? 'SHOW' : 'HIDE',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
