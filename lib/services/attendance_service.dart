import '../core/api_client.dart';
import '../models/attendance.dart';

class AttendanceService {
  static Future<List<Attendance>> list(int eventId) async {
    final data = await ApiClient.get('/events/$eventId/attendance');
    return (data as List)
        .map((e) => Attendance.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<Attendance> record(Attendance attendance) async {
    final data = await ApiClient.post(
      '/events/${attendance.eventId}/attendance',
      attendance.toJson(),
    );
    return Attendance.fromJson(data as Map<String, dynamic>);
  }

  static Future<AttendanceSummary> summary(int eventId) async {
    final data = await ApiClient.get('/events/$eventId/attendance/summary');
    return AttendanceSummary.fromJson(data as Map<String, dynamic>);
  }
}
