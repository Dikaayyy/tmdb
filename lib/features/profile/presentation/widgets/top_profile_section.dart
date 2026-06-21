import 'package:flutter/material.dart';

import '../../../auth/presentation/widgets/auth_button.dart';
import 'profile_avatar.dart';
import 'profile_info.dart';
import 'profile_more_button.dart';

class TopProfileSection extends StatelessWidget {
  const TopProfileSection({
    super.key,
    required this.name,
    required this.email,
    required this.isGuest,
    required this.onLogin,
    required this.onMore,
    this.joinedSince,
  });

  final String name;
  final String email;
  final String? joinedSince;
  final bool isGuest;
  final VoidCallback onLogin;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const ProfileAvatar(),
              const SizedBox(width: 12),
              Expanded(
                child: ProfileInfo(
                  name: name,
                  email: email,
                  joinedSince: joinedSince,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              if (!isGuest) ...[
                const SizedBox(width: 12),
                ProfileMoreButton(onPressed: onMore),
              ],
            ],
          ),
          if (isGuest) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: AuthButton(label: 'Login', onPressed: onLogin),
            ),
          ],
        ],
      ),
    );
  }
}
