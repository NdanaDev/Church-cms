import '../core/api_client.dart';
import '../models/report_summary.dart';

class ReportService {
  static Future<ReportSummary> getSummary() async {
    final data = await ApiClient.get('/reports/summary');
    return ReportSummary.fromJson(data as Map<String, dynamic>);
  }
}
