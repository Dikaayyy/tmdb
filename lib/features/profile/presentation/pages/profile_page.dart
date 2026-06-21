import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart' as iconly;

import '../../../../core/storage/hive_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_action_bottom_sheet.dart';
import '../../../auth/presentation/widgets/auth_button.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_info.dart';
import '../widgets/profile_more_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _name = 'ilhamrajab';
  static const _email = 'iamidat@outlook.com';
  static const _joinedSince = 'Bergabung sejak November 2023';
  static const _guestName = 'Tiketux TMDB';
  static const _guestEmail = 'tiketux';

  Future<void> _handleLogout() async {
    await HiveService.logout();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  Future<void> _goToLogin() async {
    await HiveService.logout();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  void _showProfileActions() {
    showAppActionBottomSheet<void>(
      context: context,
      title: 'Pengaturan Akun',
      items: [
        AppActionBottomSheetItem(
          icon: iconly.IconlyLight.logout,
          title: 'Log Out',
          subtitle:
              'Pastikan untuk log out agar informasi akunmu tetap terlindungi',
          mirrorIcon: true,
          onTap: _handleLogout,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = HiveService.getGuestStatus();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ProfileAvatar(),
                const SizedBox(height: 12),
                ProfileInfo(
                  name: isGuest ? _guestName : _name,
                  email: isGuest ? _guestEmail : _email,
                  joinedSince: isGuest ? null : _joinedSince,
                ),
                const SizedBox(height: 12),
                if (isGuest)
                  SizedBox(
                    width: 80,
                    child: AuthButton(label: 'Login', onPressed: _goToLogin),
                  )
                else
                  ProfileMoreButton(onPressed: _showProfileActions),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
