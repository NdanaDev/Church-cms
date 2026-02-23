import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/announcement.dart';
import '../services/announcement_service.dart';

class AnnouncementState {
  final List<Announcement> announcements;
  final bool loading;
  final String? error;

  AnnouncementState({
    this.announcements = const [],
    this.loading = false,
    this.error,
  });

  AnnouncementState copyWith({
    List<Announcement>? announcements,
    bool? loading,
    String? error,
  }) =>
      AnnouncementState(
        announcements: announcements ?? this.announcements,
        loading: loading ?? this.loading,
        error: error,
      );
}

class AnnouncementNotifier extends StateNotifier<AnnouncementState> {
  AnnouncementNotifier() : super(AnnouncementState());

  Future<void> load() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final list = await AnnouncementService.list();
      state = state.copyWith(
        announcements: list.reversed.toList(),
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<bool> create(String title, String content) async {
    try {
      await AnnouncementService.create(
        Announcement(title: title, content: content),
      );
      await load();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> delete(int id) async {
    try {
      await AnnouncementService.delete(id);
      await load();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

final announcementProvider =
    StateNotifierProvider<AnnouncementNotifier, AnnouncementState>(
  (ref) => AnnouncementNotifier(),
);
