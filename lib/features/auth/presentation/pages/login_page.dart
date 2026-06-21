import 'package:flutter/material.dart';

import '../../../../core/storage/hive_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_error_toast.dart';
import '../../../../main/main_navigation_page.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/auth_separator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showEmailError = false;
  bool _showPasswordError = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final emailEmpty = _emailController.text.trim().isEmpty;
    final passwordEmpty = _passwordController.text.trim().isEmpty;

    setState(() {
      _showEmailError = emailEmpty;
      _showPasswordError = passwordEmpty;
    });

    if (emailEmpty || passwordEmpty) {
      AppErrorToast.show(context, message: 'Isi form yang dibutuhkan');
      return;
    }

    await HiveService.saveLogin(true);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const MainNavigationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final isKeyboardVisible = keyboardInset > 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 470,
              child: Image.asset(
                'assets/images/headerimage.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Transform.translate(
                    offset: Offset(0, isKeyboardVisible ? -120 : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 186),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/logowtxt.png',
                                width: 124,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 32),
                              const Text(
                                'Siap-siaplah untuk terjun ke dalam kisah-kisah terhebat di TV dan Film',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 48),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              AuthInputField(
                                hintText: 'Alamat Email',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                isError: _showEmailError,
                              ),
                              const SizedBox(height: 8),
                              AuthInputField(
                                hintText: 'Kata Sandi',
                                controller: _passwordController,
                                obscureText: true,
                                isError: _showPasswordError,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: AuthButton(
                            label: 'Login',
                            onPressed: _handleLogin,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: AuthSeparator(),
                        ),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: AuthButton(
                            label: 'Masuk Sebagai Tamu',
                            isPrimary: false,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isKeyboardVisible)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text:
                                'Dengan membuat akun atau masuk, Anda setuju dengan ',
                          ),
                          TextSpan(
                            text: 'Ketentuan Layanan',
                            style: TextStyle(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: ' dan '),
                          TextSpan(
                            text: 'Kebijakan Privasi',
                            style: TextStyle(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: ' kami.'),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
