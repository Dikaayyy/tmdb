import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/storage/hive_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../../main/main_navigation_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const _splashDuration = Duration(seconds: 2);

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_splashDuration, _goToNextPage);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goToNextPage() {
    if (!mounted) return;

    final isLoggedIn = HiveService.getLoginStatus();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => isLoggedIn
            ? const MainNavigationPage()
            : const LoginPage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 28),
          child: Column(
            children: [
              Spacer(),
              Center(
                child: Image(
                  image: AssetImage('assets/images/logowtxt.png'),
                  width: 124,
                  fit: BoxFit.contain,
                ),
              ),
              Spacer(),
              Image(
                image: AssetImage('assets/images/tiketux.png'),
                width: 84,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
