import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/member.dart';
import '../services/member_service.dart';

class MemberListState {
  final List<Member> members;
  final int currentPage;
  final int totalPages;
  final int totalElements;
  final String search;
  final bool loading;
  final String? error;

  MemberListState({
    this.members = const [],
    this.currentPage = 0,
    this.totalPages = 1,
    this.totalElements = 0,
    this.search = '',
    this.loading = false,
    this.error,
  });

  MemberListState copyWith({
    List<Member>? members,
    int? currentPage,
    int? totalPages,
    int? totalElements,
    String? search,
    bool? loading,
    String? error,
  }) =>
      MemberListState(
        members: members ?? this.members,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        totalElements: totalElements ?? this.totalElements,
        search: search ?? this.search,
        loading: loading ?? this.loading,
        error: error,
      );
}

class MemberNotifier extends StateNotifier<MemberListState> {
  MemberNotifier() : super(MemberListState());

  Future<void> load({int page = 0, String? search}) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final result = await MemberService.list(
        page: page,
        search: search ?? state.search,
      );
      state = state.copyWith(
        members: result.content,
        currentPage: result.number,
        totalPages: result.totalPages,
        totalElements: result.totalElements,
        loading: false,
        search: search ?? state.search,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> nextPage() async {
    if (state.currentPage < state.totalPages - 1) {
      await load(page: state.currentPage + 1);
    }
  }

  Future<void> prevPage() async {
    if (state.currentPage > 0) {
      await load(page: state.currentPage - 1);
    }
  }

  Future<void> search(String query) async {
    await load(page: 0, search: query);
  }

  Future<bool> create(Member member) async {
    try {
      await MemberService.create(member);
      await load(page: 0);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> update(int id, Member member) async {
    try {
      await MemberService.update(id, member);
      await load(page: state.currentPage);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> delete(int id) async {
    try {
      await MemberService.delete(id);
      await load(page: state.currentPage);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

final memberProvider = StateNotifierProvider<MemberNotifier, MemberListState>(
  (ref) => MemberNotifier(),
);

final allMembersProvider = FutureProvider<List<Member>>((ref) async {
  return MemberService.listAll();
});
