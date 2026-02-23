enum AttendanceStatus { PRESENT, ABSENT }

class Attendance {
  final int? id;
  final int eventId;
  final int memberId;
  final String? memberName;
  final AttendanceStatus status;

  Attendance({
    this.id,
    required this.eventId,
    required this.memberId,
    this.memberName,
    required this.status,
  });

  factory Attendance.fromJson(Map<String, dynamic> j) => Attendance(
        id: j['id'],
        eventId: j['eventId'] ?? 0,
        memberId: j['memberId'] ?? 0,
        memberName: j['memberName'],
        status: AttendanceStatus.values.firstWhere(
          (e) => e.name == (j['status'] ?? 'PRESENT'),
          orElse: () => AttendanceStatus.PRESENT,
        ),
      );

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'memberId': memberId,
        'status': status.name,
      };
}

class AttendanceSummary {
  final int eventId;
  final int present;
  final int absent;
  final int total;

  AttendanceSummary({
    required this.eventId,
    required this.present,
    required this.absent,
    required this.total,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> j) =>
      AttendanceSummary(
        eventId: j['eventId'] ?? 0,
        present: j['present'] ?? 0,
        absent: j['absent'] ?? 0,
        total: j['total'] ?? 0,
      );
}
