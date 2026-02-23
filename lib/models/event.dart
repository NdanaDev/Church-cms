class Event {
  final int? id;
  final String title;
  final String? description;
  final String eventDate;
  final String? location;

  Event({
    this.id,
    required this.title,
    this.description,
    required this.eventDate,
    this.location,
  });

  factory Event.fromJson(Map<String, dynamic> j) => Event(
        id: j['id'],
        title: j['title'] ?? '',
        description: j['description'],
        eventDate: j['eventDate'] ?? '',
        location: j['location'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        if (description != null) 'description': description,
        'eventDate': eventDate,
        if (location != null) 'location': location,
      };
}
