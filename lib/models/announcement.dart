class Announcement {
  final int? id;
  final String title;
  final String content;
  final String? createdAt;

  Announcement({
    this.id,
    required this.title,
    required this.content,
    this.createdAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> j) => Announcement(
        id: j['id'],
        title: j['title'] ?? '',
        content: j['content'] ?? '',
        createdAt: j['createdAt'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
      };
}
