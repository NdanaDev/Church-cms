import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class ScaffoldWithNav extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNav({super.key, required this.child});

  static const _navItems = [
    _NavItem(Icons.dashboard_outlined, Icons.dashboard, 'Dashboard', '/dashboard'),
    _NavItem(Icons.people_outline, Icons.people, 'Members', '/members'),
    _NavItem(Icons.event_outlined, Icons.event, 'Events', '/events'),
    _NavItem(Icons.campaign_outlined, Icons.campaign, 'Announcements', '/announcements'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: MediaQuery.of(context).size.width >= 900,
            backgroundColor: const Color(0xFF3949AB),
            selectedIconTheme:
                const IconThemeData(color: Colors.white),
            unselectedIconTheme:
                const IconThemeData(color: Colors.white70),
            selectedLabelTextStyle:
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            unselectedLabelTextStyle:
                const TextStyle(color: Colors.white70),
            selectedIndex: _selectedIndex(location),
            onDestinationSelected: (i) =>
                context.go(_navItems[i].route),
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  const Icon(Icons.church, color: Colors.white, size: 32),
                  const SizedBox(height: 4),
                  if (MediaQuery.of(context).size.width >= 900)
                    const Text(
                      'Church CMS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: IconButton(
                icon: const Icon(Icons.logout, color: Colors.white70),
                tooltip: 'Logout',
                onPressed: () async {
                  await logout();
                },
              ),
            ),
            destinations: _navItems
                .map(
                  (item) => NavigationRailDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selectedIcon),
                    label: Text(item.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }

  int _selectedIndex(String location) {
    for (int i = 0; i < _navItems.length; i++) {
      if (location.startsWith(_navItems[i].route)) return i;
    }
    return 0;
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;
  const _NavItem(this.icon, this.selectedIcon, this.label, this.route);
}
