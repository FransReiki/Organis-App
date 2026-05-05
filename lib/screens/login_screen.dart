import 'package:flutter/material.dart';
import '../constants.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variabel untuk kontrol lihat/sembunyi password
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Buat background scaffold bening agar Stack di bawahnya terlihat full
      backgroundColor: Colors.transparent,
      // Mencegah keyboard merusak tata letak background
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          /// 1. BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_image.png',
              fit: BoxFit.cover,
            ),
          ),

          /// 2. DARK OVERLAY
          // Ubah opacity dari 0 ke 0.3 jika teks sulit dibaca
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0))),

          /// 3. KONTEN UTAMA
          SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  // physics ini memastikan scroll tetap halus di semua kondisi
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      // PAKSA tinggi konten minimal sama dengan tinggi layar
                      // Ini rahasia agar tidak ada area hitam/putih di bawah
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 60),

                          // LOGO & JUDUL
                          const Icon(
                            Icons.church,
                            size: 100,
                            color: Color(0xFFFFD700),
                          ),
                          const Text('ORGANIST APP', style: h1),

                          const SizedBox(height: 50),

                          // INPUT BOX (Glassmorphism Effect)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                _buildTextField(
                                  hint: 'Enter your email',
                                  label: 'Email',
                                  icon: Icons.email_outlined,
                                ),
                                const Divider(height: 1, color: Colors.grey),
                                _buildTextField(
                                  hint: 'Enter your password',
                                  label: 'Password',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // TOMBOL LOGIN (Gradient)
                          GestureDetector(
                            onTap: () => print("Login ditekan!"),
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
                              child: const Center(
                                child: Text(
                                  'Login',
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

                          // FORGOT PASSWORD
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                          const Text('Belum punya akun?', style: body),
                          const SizedBox(height: 10),

                          // TOMBOL REGISTER (Gradient Kecil)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: orangeGradient,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          // Spasi tambahan di paling bawah agar tidak mepet sistem navigasi
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

  /// Helper untuk membuat TextField secara efisien
  Widget _buildTextField({
    required String hint,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextField(
        obscureText: isPassword ? isObscure : false,
        style: const TextStyle(
          color: Colors.black,
        ), // Teks input berwarna hitam
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.blueGrey),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.blueGrey),
          hintText: hint,
          suffixIcon: isPassword
              ? TextButton(
                  onPressed: () => setState(() => isObscure = !isObscure),
                  child: Text(
                    isObscure ? 'SHOW' : 'HIDE',
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
