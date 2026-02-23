import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/member_provider.dart';
import '../models/member.dart';
import '../services/member_service.dart';

class MemberFormPage extends ConsumerStatefulWidget {
  final int? memberId;
  const MemberFormPage({super.key, this.memberId});

  @override
  ConsumerState<MemberFormPage> createState() => _MemberFormPageState();
}

class _MemberFormPageState extends ConsumerState<MemberFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  MemberRole _role = MemberRole.MEMBER;
  MemberStatus _status = MemberStatus.ACTIVE;
  String? _joinDate;
  bool _loading = false;
  bool _initialLoading = false;

  bool get isEdit => widget.memberId != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) _loadMember();
  }

  Future<void> _loadMember() async {
    setState(() => _initialLoading = true);
    try {
      final m = await MemberService.get(widget.memberId!);
      _nameCtrl.text = m.name;
      _emailCtrl.text = m.email;
      _phoneCtrl.text = m.phone ?? '';
      _role = m.role;
      _status = m.status;
      _joinDate = m.joinDate;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load member: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _initialLoading = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final member = Member(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      role: _role,
      status: _status,
      joinDate: _joinDate,
    );

    bool ok;
    if (isEdit) {
      ok = await ref
          .read(memberProvider.notifier)
          .update(widget.memberId!, member);
    } else {
      ok = await ref.read(memberProvider.notifier).create(member);
    }

    if (mounted) {
      setState(() => _loading = false);
      if (ok) {
        context.go('/members');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ref.read(memberProvider).error ?? 'Save failed',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _joinDate = picked.toIso8601String().split('T').first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Member' : 'Add Member'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/members'),
        ),
      ),
      body: _initialLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    width: 480,
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEdit ? 'Edit Member' : 'New Member',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _nameCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Full Name *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) =>
                                v == null || v.trim().isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Required';
                              if (!v.contains('@')) return 'Invalid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<MemberRole>(
                            value: _role,
                            decoration: const InputDecoration(
                              labelText: 'Role',
                              border: OutlineInputBorder(),
                            ),
                            items: MemberRole.values
                                .map((r) => DropdownMenuItem(
                                      value: r,
                                      child: Text(r.name),
                                    ))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _role = v ?? MemberRole.MEMBER),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<MemberStatus>(
                            value: _status,
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(),
                            ),
                            items: MemberStatus.values
                                .map((s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(s.name),
                                    ))
                                .toList(),
                            onChanged: (v) => setState(
                                () => _status = v ?? MemberStatus.ACTIVE),
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: _pickDate,
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Join Date',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              child: Text(
                                _joinDate ?? 'Select date',
                                style: TextStyle(
                                  color: _joinDate == null
                                      ? Colors.grey
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => context.go('/members'),
                                child: const Text('Cancel'),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: _loading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5C6BC0),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 14,
                                  ),
                                ),
                                child: _loading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(isEdit ? 'Update' : 'Create'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
