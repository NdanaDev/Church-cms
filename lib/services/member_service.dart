import '../core/api_client.dart';
import '../models/member.dart';

class MemberService {
  static Future<PagedMembers> list({int page = 0, int size = 10, String? search}) async {
    final query = StringBuffer('/members?page=$page&size=$size');
    if (search != null && search.isNotEmpty) query.write('&search=$search');
    final data = await ApiClient.get(query.toString());
    return PagedMembers.fromJson(data as Map<String, dynamic>);
  }

  static Future<Member> get(int id) async {
    final data = await ApiClient.get('/members/$id');
    return Member.fromJson(data as Map<String, dynamic>);
  }

  static Future<Member> create(Member member) async {
    final data = await ApiClient.post('/members', member.toJson());
    return Member.fromJson(data as Map<String, dynamic>);
  }

  static Future<Member> update(int id, Member member) async {
    final data = await ApiClient.put('/members/$id', member.toJson());
    return Member.fromJson(data as Map<String, dynamic>);
  }

  static Future<void> delete(int id) => ApiClient.delete('/members/$id');

  static Future<List<Member>> listAll() async {
    final data = await ApiClient.get('/members?page=0&size=1000');
    final paged = PagedMembers.fromJson(data as Map<String, dynamic>);
    return paged.content;
  }
}
