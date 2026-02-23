enum RsvpStatus { GOING, NOT_GOING, MAYBE }

class Rsvp {
  final int? id;
  final int eventId;
  final int memberId;
  final String? memberName;
  final RsvpStatus status;

  Rsvp({
    this.id,
    required this.eventId,
    required this.memberId,
    this.memberName,
    required this.status,
  });

  factory Rsvp.fromJson(Map<String, dynamic> j) => Rsvp(
        id: j['id'],
        eventId: j['eventId'] ?? 0,
        memberId: j['memberId'] ?? 0,
        memberName: j['memberName'],
        status: RsvpStatus.values.firstWhere(
          (e) => e.name == (j['status'] ?? 'GOING'),
          orElse: () => RsvpStatus.GOING,
        ),
      );

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'memberId': memberId,
        'status': status.name,
      };
}
