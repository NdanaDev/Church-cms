import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import '../models/rsvp.dart';
import '../services/event_service.dart';

class EventListState {
  final List<Event> events;
  final bool loading;
  final String? error;

  EventListState({this.events = const [], this.loading = false, this.error});

  EventListState copyWith({
    List<Event>? events,
    bool? loading,
    String? error,
  }) =>
      EventListState(
        events: events ?? this.events,
        loading: loading ?? this.loading,
        error: error,
      );
}

class EventNotifier extends StateNotifier<EventListState> {
  EventNotifier() : super(EventListState());

  Future<void> load() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final events = await EventService.list();
      state = state.copyWith(events: events, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<bool> create(Event event) async {
    try {
      await EventService.create(event);
      await load();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> update(int id, Event event) async {
    try {
      await EventService.update(id, event);
      await load();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> delete(int id) async {
    try {
      await EventService.delete(id);
      await load();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

final eventProvider = StateNotifierProvider<EventNotifier, EventListState>(
  (ref) => EventNotifier(),
);

final eventRsvpsProvider =
    FutureProvider.family<List<Rsvp>, int>((ref, eventId) async {
  return EventService.listRsvps(eventId);
});
