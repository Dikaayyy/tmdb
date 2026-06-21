import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_info.dart';
import '../widgets/profile_more_button.dart';

enum LastViewedContentType { movie, series }

class LastViewedContent {
  const LastViewedContent({
    required this.id,
    required this.title,
    required this.type,
  });

  final int id;
  final String title;
  final LastViewedContentType type;
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _email = 'user@example.com';
  static final _joinedAt = DateTime(2026, 6);

  LastViewedContent? _lastViewedContent;

  String get _displayName => _email.split('@').first;

  String get _joinedSince {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return 'Bergabung sejak ${months[_joinedAt.month - 1]} ${_joinedAt.year}';
  }

  String? get _lastViewedLabel {
    final content = _lastViewedContent;
    if (content == null) return null;

    final type = content.type == LastViewedContentType.movie
        ? 'Movie'
        : 'Series';
    return 'Terakhir dilihat: $type - ${content.title}';
  }

  @override
  Widget build(BuildContext context) {
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
                  name: _displayName,
                  email: _email,
                  joinedSince: _joinedSince,
                ),
                const SizedBox(height: 12),
                ProfileMoreButton(onPressed: () {}),
                if (_lastViewedLabel case final label?) ...[
                  const SizedBox(height: 24),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
