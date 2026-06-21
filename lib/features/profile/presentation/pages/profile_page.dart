import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart' as iconly;

import '../../../../core/storage/session_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_action_bottom_sheet.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../movies/data/models/movie_model.dart';
import '../../data/datasources/recently_viewed_local_datasource.dart';
import '../widgets/centered_profile_section.dart';
import '../widgets/recently_viewed_section.dart';
import '../widgets/top_profile_section.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  static const _name = 'ilhamrajab';
  static const _email = 'iamidat@outlook.com';
  static const _joinedSince = 'Bergabung sejak November 2023';
  static const _guestName = 'Tiketux TMDB';
  static const _guestEmail = 'tiketux';

  final _sessionStorage = SessionStorage();
  final _recentlyViewedDatasource = RecentlyViewedLocalDatasource();

  List<MovieModel> _recentlyViewedMovies = const [];

  @override
  void initState() {
    super.initState();
    _recentlyViewedMovies = _recentlyViewedDatasource.getMovies();
  }

  void refreshRecentlyViewedMovies() {
    setState(() {
      _recentlyViewedMovies = _recentlyViewedDatasource.getMovies();
    });
  }

  Future<void> _handleLogout() async {
    await _sessionStorage.logout();
    await _recentlyViewedDatasource.clearMovies();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  Future<void> _goToLogin() async {
    await _sessionStorage.logout();
    await _recentlyViewedDatasource.clearMovies();

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
    final isGuest = _sessionStorage.getGuestStatus();
    final hasRecentlyViewed = _recentlyViewedMovies.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: hasRecentlyViewed
            ? ListView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                children: [
                  TopProfileSection(
                    name: isGuest ? _guestName : _name,
                    email: isGuest ? _guestEmail : _email,
                    joinedSince: isGuest ? null : _joinedSince,
                    isGuest: isGuest,
                    onLogin: _goToLogin,
                    onMore: _showProfileActions,
                  ),
                  RecentlyViewedSection(movies: _recentlyViewedMovies),
                ],
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: CenteredProfileSection(
                    name: isGuest ? _guestName : _name,
                    email: isGuest ? _guestEmail : _email,
                    joinedSince: isGuest ? null : _joinedSince,
                    isGuest: isGuest,
                    onLogin: _goToLogin,
                    onMore: _showProfileActions,
                  ),
                ),
              ),
      ),
    );
  }
}
