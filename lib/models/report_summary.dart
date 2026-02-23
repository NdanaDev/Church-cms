class ReportSummary {
  final int totalMembers;
  final int upcomingEvents;
  final int weeklyAttendance;

  ReportSummary({
    required this.totalMembers,
    required this.upcomingEvents,
    required this.weeklyAttendance,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> j) => ReportSummary(
        totalMembers: j['totalMembers'] ?? 0,
        upcomingEvents: j['upcomingEvents'] ?? 0,
        weeklyAttendance: j['weeklyAttendance'] ?? 0,
      );
}

class WeeklyAttendance {
  final String weekStart;
  final int count;

  WeeklyAttendance({required this.weekStart, required this.count});

  factory WeeklyAttendance.fromJson(Map<String, dynamic> j) => WeeklyAttendance(
        weekStart: j['weekStart'] ?? '',
        count: j['count'] ?? 0,
      );
}
