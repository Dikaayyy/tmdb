import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart' as iconly;

import '../core/widgets/floating_bottom_nav_bar.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/watchlist/presentation/pages/watchlist_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  final _profileKey = GlobalKey<ProfilePageState>();

  static const _items = [
    FloatingBottomNavBarItem(
      label: 'Beranda',
      icon: iconly.IconlyLight.home,
      activeIcon: iconly.IconlyBold.home,
    ),
    FloatingBottomNavBarItem(
      label: 'Watchlist',
      icon: iconly.IconlyLight.bookmark,
      activeIcon: iconly.IconlyBold.bookmark,
    ),
    FloatingBottomNavBarItem(
      label: 'Profil',
      icon: iconly.IconlyLight.profile,
      activeIcon: iconly.IconlyBold.profile,
    ),
  ];

  late final _pages = [
    const HomePage(),
    const WatchlistPage(),
    ProfilePage(key: _profileKey),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _pages),
          Positioned.fill(
            child: FloatingBottomNavBar(
              currentIndex: _currentIndex,
              items: _items,
              onItemSelected: (index) {
                if (_currentIndex == index) return;

                setState(() => _currentIndex = index);
                if (index == 2) {
                  _profileKey.currentState?.refreshRecentlyViewedMovies();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
