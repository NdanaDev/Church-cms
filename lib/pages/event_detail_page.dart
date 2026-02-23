import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/event_service.dart';
import '../services/attendance_service.dart';
import '../services/member_service.dart';
import '../models/event.dart';
import '../models/rsvp.dart';
import '../models/attendance.dart';
import '../models/member.dart';

class EventDetailPage extends ConsumerStatefulWidget {
  final int eventId;
  const EventDetailPage({super.key, required this.eventId});

  @override
  ConsumerState<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends ConsumerState<EventDetailPage> {
  Event? _event;
  List<Rsvp> _rsvps = [];
  List<Attendance> _attendance = [];
  List<Member> _members = [];
  bool _loading = true;
  String? _error;

  int? _selectedMemberId;
  RsvpStatus _rsvpStatus = RsvpStatus.GOING;
  bool _submittingRsvp = false;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([
        EventService.get(widget.eventId),
        EventService.listRsvps(widget.eventId),
        AttendanceService.list(widget.eventId),
        MemberService.listAll(),
      ]);
      setState(() {
        _event = results[0] as Event;
        _rsvps = results[1] as List<Rsvp>;
        _attendance = results[2] as List<Attendance>;
        _members = results[3] as List<Member>;
        _loading = false;
      });
    } catch (e) {
      setState(() { _loading = false; _error = e.toString(); });
    }
  }

  Future<void> _submitRsvp() async {
    if (_selectedMemberId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a member first')),
      );
      return;
    }
    setState(() => _submittingRsvp = true);
    try {
      await EventService.createRsvp(Rsvp(
        eventId: widget.eventId,
        memberId: _selectedMemberId!,
        status: _rsvpStatus,
      ));
      await _loadAll();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('RSVP failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _submittingRsvp = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null || _event == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/events'),
          ),
        ),
        body: Center(child: Text(_error ?? 'Event not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_event!.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/events'),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.fact_check),
            label: const Text('Record Attendance'),
            onPressed: () => context.go('/events/${widget.eventId}/attendance'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Event Details',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const Divider(height: 20),
                    _InfoRow(Icons.calendar_today, 'Date', _event!.eventDate),
                    if (_event!.location != null)
                      _InfoRow(Icons.location_on, 'Location', _event!.location!),
                    if (_event!.description != null)
                      _InfoRow(Icons.description, 'Description', _event!.description!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // RSVP section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add RSVP',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _selectedMemberId,
                            decoration: const InputDecoration(
                              labelText: 'Member',
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
                          child: DropdownButtonFormField<RsvpStatus>(
                            value: _rsvpStatus,
                            decoration: const InputDecoration(
                              labelText: 'Response',
                              border: OutlineInputBorder(),
                            ),
                            items: RsvpStatus.values
                                .map((s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(s.name.replaceAll('_', ' ')),
                                    ))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _rsvpStatus = v ?? RsvpStatus.GOING),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _submittingRsvp ? null : _submitRsvp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5C6BC0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          ),
                          child: _submittingRsvp
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Submit'),
                        ),
                      ],
                    ),
                    if (_rsvps.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text('RSVPs (${_rsvps.length})',
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _rsvps.map((r) => Chip(
                          label: Text(
                            '${r.memberName ?? 'Member ${r.memberId}'} — ${r.status.name.replaceAll('_', ' ')}',
                          ),
                          backgroundColor: _rsvpColor(r.status).withOpacity(0.12),
                          labelStyle: TextStyle(color: _rsvpColor(r.status)),
                        )).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Attendance table
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Attendance (${_attendance.length})',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    if (_attendance.isEmpty)
                      const Text('No attendance recorded yet.',
                          style: TextStyle(color: Colors.grey))
                    else
                      DataTable(
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
                                  DataCell(_AttendanceBadge(a.status)),
                                ]))
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _rsvpColor(RsvpStatus s) => switch (s) {
        RsvpStatus.GOING => Colors.green,
        RsvpStatus.NOT_GOING => Colors.red,
        RsvpStatus.MAYBE => Colors.orange,
      };
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _AttendanceBadge extends StatelessWidget {
  final AttendanceStatus status;
  const _AttendanceBadge(this.status);

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      AttendanceStatus.PRESENT => (Colors.green, 'Present'),
      AttendanceStatus.ABSENT => (Colors.red, 'Absent'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}
