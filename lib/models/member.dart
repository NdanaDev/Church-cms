enum MemberRole { MEMBER, LEADER, ADMIN }

enum MemberStatus { ACTIVE, INACTIVE }

class Member {
  final int? id;
  final String name;
  final String email;
  final String? phone;
  final MemberRole role;
  final MemberStatus status;
  final String? joinDate;

  Member({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.status,
    this.joinDate,
  });

  factory Member.fromJson(Map<String, dynamic> j) => Member(
        id: j['id'],
        name: j['name'] ?? '',
        email: j['email'] ?? '',
        phone: j['phone'],
        role: MemberRole.values.firstWhere(
          (e) => e.name == (j['role'] ?? 'MEMBER'),
          orElse: () => MemberRole.MEMBER,
        ),
        status: MemberStatus.values.firstWhere(
          (e) => e.name == (j['status'] ?? 'ACTIVE'),
          orElse: () => MemberStatus.ACTIVE,
        ),
        joinDate: j['joinDate'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        if (phone != null) 'phone': phone,
        'role': role.name,
        'status': status.name,
        if (joinDate != null) 'joinDate': joinDate,
      };
}

class PagedMembers {
  final List<Member> content;
  final int totalPages;
  final int totalElements;
  final int number;

  PagedMembers({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.number,
  });

  factory PagedMembers.fromJson(Map<String, dynamic> j) => PagedMembers(
        content: (j['content'] as List? ?? [])
            .map((e) => Member.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalPages: j['totalPages'] ?? 1,
        totalElements: j['totalElements'] ?? 0,
        number: j['number'] ?? 0,
      );
}
