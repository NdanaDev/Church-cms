import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/attendance_service.dart';
import '../services/member_service.dart';
import '../models/attendance.dart';
import '../models/member.dart';

class AttendancePage extends ConsumerStatefulWidget {
  final int eventId;
  const AttendancePage({super.key, required this.eventId});

  @override
  ConsumerState<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends ConsumerState<AttendancePage> {
  List<Member> _members = [];
  List<Attendance> _attendance = [];
  bool _loading = true;
  String? _error;

  int? _selectedMemberId;
  AttendanceStatus _status = AttendanceStatus.PRESENT;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([
        MemberService.listAll(),
        AttendanceService.list(widget.eventId),
      ]);
      setState(() {
        _members = results[0] as List<Member>;
        _attendance = results[1] as List<Attendance>;
        _loading = false;
      });
    } catch (e) {
      setState(() { _loading = false; _error = e.toString(); });
    }
  }

  Future<void> _submit() async {
    if (_selectedMemberId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a member')),
      );
      return;
    }
    setState(() => _submitting = true);
    try {
      await AttendanceService.record(Attendance(
        eventId: widget.eventId,
        memberId: _selectedMemberId!,
        status: _status,
      ));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attendance recorded'), backgroundColor: Colors.green),
        );
        setState(() => _selectedMemberId = null);
        await _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Attendance'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/events/${widget.eventId}'),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mark Attendance',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: DropdownButtonFormField<int>(
                                      value: _selectedMemberId,
                                      decoration: const InputDecoration(
                                        labelText: 'Select Member',
                                        border: OutlineInputBorder(),
                                      ),
                                      items: _members
                                          .map((m) => DropdownMenuItem(
                                                value: m.id,
                                                child: Text(m.name),
                                              ))
                                          .toList(),
                                      onChanged: (v) =>
                                          setState(() => _selectedMemberId = v),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: DropdownButtonFormField<AttendanceStatus>(
                                      value: _status,
                                      decoration: const InputDecoration(
                                        labelText: 'Status',
                                        border: OutlineInputBorder(),
                                      ),
                                      items: AttendanceStatus.values
                                          .map((s) => DropdownMenuItem(
                                                value: s,
                                                child: Text(s.name),
                                              ))
                                          .toList(),
                                      onChanged: (v) => setState(
                                          () => _status = v ?? AttendanceStatus.PRESENT),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed: _submitting ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF5C6BC0),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                    ),
                                    child: _submitting
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              color: Colors.white, strokeWidth: 2),
                                          )
                                        : const Text('Record'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Recorded (${_attendance.length})',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      if (_attendance.isEmpty)
                        const Text('No attendance recorded yet.',
                            style: TextStyle(color: Colors.grey))
                      else
                        Expanded(
                          child: Card(
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(
                                const Color(0xFFF5F5F5),
                              ),
                              columns: const [
                                DataColumn(label: Text('Member')),
                                DataColumn(label: Text('Status')),
                              ],
                              rows: _attendance
                                  .map((a) => DataRow(cells: [
                                        DataCell(Text(
                                          a.memberName ?? 'Member ${a.memberId}',
                                        )),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: (a.status ==
                                                          AttendanceStatus.PRESENT
                                                      ? Colors.green
                                                      : Colors.red)
                                                  .withOpacity(0.12),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              a.status.name,
                                              style: TextStyle(
                                                color: a.status ==
                                                        AttendanceStatus.PRESENT
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]))
                                  .toList(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}
