import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../pages/login_page.dart';
import '../pages/scaffold_with_nav.dart';
import '../pages/dashboard_page.dart';
import '../pages/members_page.dart';
import '../pages/member_form_page.dart';
import '../pages/events_page.dart';
import '../pages/event_detail_page.dart';
import '../pages/announcements_page.dart';
import '../pages/attendance_page.dart';

Session? _session() => Supabase.instance.client.auth.currentSession;

final router = GoRouter(
  initialLocation: '/dashboard',
  redirect: (context, state) {
    final loggedIn = _session() != null;
    final onLogin = state.matchedLocation == '/login';
    if (!loggedIn && !onLogin) return '/login';
    if (loggedIn && onLogin) return '/dashboard';
    return null;
  },
  refreshListenable: GoRouterRefreshStream(
    Supabase.instance.client.auth.onAuthStateChange,
  ),
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithNav(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/members',
          builder: (context, state) => const MembersPage(),
        ),
        GoRoute(
          path: '/members/new',
          builder: (context, state) => const MemberFormPage(),
        ),
        GoRoute(
          path: '/members/:id/edit',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return MemberFormPage(memberId: id);
          },
        ),
        GoRoute(
          path: '/events',
          builder: (context, state) => const EventsPage(),
        ),
        GoRoute(
          path: '/events/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return EventDetailPage(eventId: id);
          },
        ),
        GoRoute(
          path: '/events/:id/attendance',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return AttendancePage(eventId: id);
          },
        ),
        GoRoute(
          path: '/announcements',
          builder: (context, state) => const AnnouncementsPage(),
        ),
      ],
    ),
  ],
);

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _sub = stream.listen((_) => notifyListeners());
  }

  late final dynamic _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
