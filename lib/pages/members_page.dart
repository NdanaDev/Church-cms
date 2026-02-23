import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/member_provider.dart';
import '../models/member.dart';

class MembersPage extends ConsumerStatefulWidget {
  const MembersPage({super.key});

  @override
  ConsumerState<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends ConsumerState<MembersPage> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(memberProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(int id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Member'),
        content: Text('Delete "$name"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      final ok = await ref.read(memberProvider.notifier).delete(id);
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.read(memberProvider).error ?? 'Delete failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(memberProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Member'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5C6BC0),
              foregroundColor: Colors.white,
            ),
            onPressed: () => context.go('/members/new'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Search members...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (v) {
                      if (v.isEmpty) {
                        ref.read(memberProvider.notifier).load();
                      }
                    },
                    onSubmitted: (v) =>
                        ref.read(memberProvider.notifier).search(v),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => ref
                      .read(memberProvider.notifier)
                      .search(_searchCtrl.text),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (state.loading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.error != null && state.members.isEmpty)
              Expanded(
                child: Center(child: Text(state.error!)),
              )
            else
              Expanded(
                child: Card(
                  elevation: 1,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        const Color(0xFFF5F5F5),
                      ),
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Phone')),
                        DataColumn(label: Text('Role')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Join Date')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: state.members.map((m) {
                        return DataRow(cells: [
                          DataCell(Text(m.name)),
                          DataCell(Text(m.email)),
                          DataCell(Text(m.phone ?? '-')),
                          DataCell(_RoleBadge(m.role)),
                          DataCell(_StatusBadge(m.status)),
                          DataCell(Text(m.joinDate ?? '-')),
                          DataCell(Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 18),
                                tooltip: 'Edit',
                                onPressed: () =>
                                    context.go('/members/${m.id}/edit'),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    size: 18, color: Colors.red),
                                tooltip: 'Delete',
                                onPressed: () =>
                                    _confirmDelete(m.id!, m.name),
                              ),
                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${state.totalElements} member(s)  |  Page ${state.currentPage + 1} of ${state.totalPages}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: state.currentPage > 0
                      ? () => ref.read(memberProvider.notifier).prevPage()
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: state.currentPage < state.totalPages - 1
                      ? () => ref.read(memberProvider.notifier).nextPage()
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final MemberRole role;
  const _RoleBadge(this.role);

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (role) {
      MemberRole.ADMIN => (Colors.purple, 'Admin'),
      MemberRole.LEADER => (Colors.blue, 'Leader'),
      MemberRole.MEMBER => (Colors.grey, 'Member'),
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

class _StatusBadge extends StatelessWidget {
  final MemberStatus status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      MemberStatus.ACTIVE => (Colors.green, 'Active'),
      MemberStatus.INACTIVE => (Colors.orange, 'Inactive'),
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
