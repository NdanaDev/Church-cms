import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_summary.dart';
import '../services/report_service.dart';

final reportSummaryProvider = FutureProvider<ReportSummary>((ref) async {
  return ReportService.getSummary();
});
