// Unit tests for the Event model's JSON serialization.
//
// The previous file was the default Flutter counter template, which referenced
// a non-existent `MyApp` widget and a counter UI this app does not have, so it
// failed to compile. These tests cover real application logic instead.

import 'package:flutter_test/flutter_test.dart';
import 'package:cms/models/event.dart';

void main() {
  group('Event.fromJson', () {
    test('parses a fully populated payload', () {
      final event = Event.fromJson({
        'id': 7,
        'title': 'Sunday Service',
        'description': 'Morning worship',
        'eventDate': '2026-06-28',
        'location': 'Main Hall',
      });

      expect(event.id, 7);
      expect(event.title, 'Sunday Service');
      expect(event.description, 'Morning worship');
      expect(event.eventDate, '2026-06-28');
      expect(event.location, 'Main Hall');
    });

    test('defaults missing title and eventDate to empty strings', () {
      final event = Event.fromJson({});

      expect(event.id, isNull);
      expect(event.title, '');
      expect(event.eventDate, '');
      expect(event.description, isNull);
      expect(event.location, isNull);
    });
  });

  group('Event.toJson', () {
    test('omits null optional fields', () {
      final json = Event(title: 'Prayer Meeting', eventDate: '2026-07-01').toJson();

      expect(json, {'title': 'Prayer Meeting', 'eventDate': '2026-07-01'});
      expect(json.containsKey('description'), isFalse);
      expect(json.containsKey('location'), isFalse);
    });

    test('includes optional fields when present', () {
      final json = Event(
        title: 'Bible Study',
        eventDate: '2026-07-03',
        description: 'Book of Acts',
        location: 'Room 2',
      ).toJson();

      expect(json['description'], 'Book of Acts');
      expect(json['location'], 'Room 2');
    });
  });
}
