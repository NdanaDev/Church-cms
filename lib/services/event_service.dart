import '../core/api_client.dart';
import '../models/event.dart';
import '../models/rsvp.dart';

class EventService {
  static Future<List<Event>> list() async {
    final data = await ApiClient.get('/events');
    return (data as List).map((e) => Event.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<Event> get(int id) async {
    final data = await ApiClient.get('/events/$id');
    return Event.fromJson(data as Map<String, dynamic>);
  }

  static Future<Event> create(Event event) async {
    final data = await ApiClient.post('/events', event.toJson());
    return Event.fromJson(data as Map<String, dynamic>);
  }

  static Future<Event> update(int id, Event event) async {
    final data = await ApiClient.put('/events/$id', event.toJson());
    return Event.fromJson(data as Map<String, dynamic>);
  }

  static Future<void> delete(int id) => ApiClient.delete('/events/$id');

  static Future<List<Rsvp>> listRsvps(int eventId) async {
    final data = await ApiClient.get('/events/$eventId/rsvps');
    return (data as List).map((e) => Rsvp.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<Rsvp> createRsvp(Rsvp rsvp) async {
    final data = await ApiClient.post('/events/${rsvp.eventId}/rsvps', rsvp.toJson());
    return Rsvp.fromJson(data as Map<String, dynamic>);
  }
}
