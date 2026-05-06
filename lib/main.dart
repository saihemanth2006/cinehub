import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'theme/app_theme.dart';
import 'screens/profile_screen.dart';
import 'screens/portfolio_screen.dart';
import 'screens/collaboration_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/opportunities_screen.dart';
import 'ai_features/ai_features.dart';

void main() {
  runApp(DevicePreview(
    enabled: !const bool.fromEnvironment('dart.vm.product'),
    builder: (context) => const CineHubApp(),
  ));
}

class CineHubApp extends StatelessWidget {
  const CineHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineHub',
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      home: const NavigationApp(),
    );
  }
}

class NavigationApp extends StatefulWidget {
  const NavigationApp({super.key});

  @override
  State<NavigationApp> createState() => _NavigationAppState();
}

class _NavigationAppState extends State<NavigationApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    ProfileScreen(),
    PortfolioScreen(),
    CollaborationScreen(),
    DiscoverScreen(),
    OpportunitiesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CineHub'),
        leading: PopupMenuButton(
          icon: const Icon(Icons.menu),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome),
                  SizedBox(width: 8),
                  Text('AI Script Generator'),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AIScriptGeneratorScreen(
                      apiKey: 'AIzaSyBi7x-m1xNWbRLiZaiFpMyG4oBTyEFqwRE',
                    ),
                  ),
                );
              },
            ),
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.calculate),
                  SizedBox(width: 8),
                  Text('Film Cost Predictor'),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FilmCostPredictorScreen(
                      apiKey: 'AIzaSyBi7x-m1xNWbRLiZaiFpMyG4oBTyEFqwRE',
                    ),
                  ),
                );
              },
            ),
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.movie_creation),
                  SizedBox(width: 8),
                  Text('AI Trailer Generator'),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TrailerGeneratorScreen(
                      apiKey: 'AIzaSyBi7x-m1xNWbRLiZaiFpMyG4oBTyEFqwRE',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.border,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: AppTypography.labelSmall.copyWith(
            color: AppColors.primary,
          ),
          unselectedLabelStyle: AppTypography.labelSmall,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library_outlined),
              activeIcon: Icon(Icons.video_library),
              label: 'Portfolio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Collaborate',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              activeIcon: Icon(Icons.search),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              activeIcon: Icon(Icons.work),
              label: 'Opportunities',
            ),
          ],
        ),
      ),
    );
  }
}
