import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart' as iconly;

import '../../../../core/storage/session_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_action_bottom_sheet.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/widgets/auth_button.dart';
import '../../../movies/data/models/movie_model.dart';
import '../../../movies/presentation/pages/movie_detail_page.dart';
import '../../../movies/presentation/widgets/new_release_movie_card.dart';
import '../../data/datasources/recently_viewed_local_datasource.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_info.dart';
import '../widgets/profile_more_button.dart';

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
                  _TopProfileSection(
                    name: isGuest ? _guestName : _name,
                    email: isGuest ? _guestEmail : _email,
                    joinedSince: isGuest ? null : _joinedSince,
                    isGuest: isGuest,
                    onLogin: _goToLogin,
                    onMore: _showProfileActions,
                  ),
                  _RecentlyViewedSection(movies: _recentlyViewedMovies),
                ],
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: _CenteredProfileSection(
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

class _TopProfileSection extends StatelessWidget {
  const _TopProfileSection({
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

class _CenteredProfileSection extends StatelessWidget {
  const _CenteredProfileSection({
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

class _RecentlyViewedSection extends StatelessWidget {
  const _RecentlyViewedSection({required this.movies});

  final List<MovieModel> movies;

  @override
  Widget build(BuildContext context) {
    final visibleMovies = movies.take(6).toList();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = (screenWidth - 56) / 2;
    final imageHeight = cardWidth * (241.14 / 160);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Terakhir dilihat',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visibleMovies.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              mainAxisExtent: imageHeight,
            ),
            itemBuilder: (context, index) {
              final movie = visibleMovies[index];

              return NewReleaseMovieCard(
                movie: movie,
                width: cardWidth,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => MovieDetailPage(movie: movie),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
