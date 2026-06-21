import 'package:flutter/material.dart';

import '../../../auth/presentation/widgets/auth_button.dart';
import 'profile_avatar.dart';
import 'profile_info.dart';
import 'profile_more_button.dart';

class CenteredProfileSection extends StatelessWidget {
  const CenteredProfileSection({
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ProfileAvatar(),
        const SizedBox(height: 12),
        ProfileInfo(
          name: name,
          email: email,
          joinedSince: joinedSince,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        const SizedBox(height: 12),
        if (isGuest)
          SizedBox(
            width: 80,
            child: AuthButton(label: 'Login', onPressed: onLogin),
          )
        else
          ProfileMoreButton(onPressed: onMore),
      ],
    );
  }
}
