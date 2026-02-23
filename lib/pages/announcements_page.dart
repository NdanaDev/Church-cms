import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/announcement_provider.dart';

class AnnouncementsPage extends ConsumerStatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  ConsumerState<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends ConsumerState<AnnouncementsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(announcementProvider.notifier).load();
    });
  }

  void _showCreateDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    bool submitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: const Text('New Announcement'),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentCtrl,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Content *',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5C6BC0),
                foregroundColor: Colors.white,
              ),
              onPressed: submitting
                  ? null
                  : () async {
                      if (titleCtrl.text.trim().isEmpty ||
                          contentCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Title and content are required'),
                          ),
                        );
                        return;
                      }
                      setDlgState(() => submitting = true);
                      final ok = await ref
                          .read(announcementProvider.notifier)
                          .create(
                            titleCtrl.text.trim(),
                            contentCtrl.text.trim(),
                          );
                      if (ok && ctx.mounted) Navigator.pop(ctx);
                      if (!ok && ctx.mounted) {
                        setDlgState(() => submitting = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              ref.read(announcementProvider).error ??
                                  'Create failed',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
              child: submitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Announcement'),
        content: const Text('Delete this announcement?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(announcementProvider.notifier).delete(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(announcementProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateDialog,
        icon: const Icon(Icons.add),
        label: const Text('New Announcement'),
        backgroundColor: const Color(0xFF5C6BC0),
        foregroundColor: Colors.white,
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.announcements.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.campaign_outlined,
                          size: 64, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('No announcements yet.',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: state.announcements.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final a = state.announcements[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    a.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      size: 18, color: Colors.red),
                                  tooltip: 'Delete',
                                  onPressed: a.id != null
                                      ? () => _confirmDelete(a.id!)
                                      : null,
                                ),
                              ],
                            ),
                            if (a.createdAt != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                a.createdAt!.split('T').first,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            const Divider(height: 20),
                            Text(a.content),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
