// lib/providers/feed_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';
import '../models/story_model.dart';
import '../services/post_repository.dart';

// ── Repository provider ──────────────────────────────────────────────────────
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

// ── Stories provider ─────────────────────────────────────────────────────────
final storiesProvider = FutureProvider<List<StoryModel>>((ref) async {
  final repo = ref.read(postRepositoryProvider);
  return repo.fetchStories();
});

// ── Feed state ───────────────────────────────────────────────────────────────
class FeedState {
  final List<PostModel> posts;
  final bool isLoading;       // initial load
  final bool isFetchingMore;  // pagination load
  final int currentPage;
  final bool hasMore;

  const FeedState({
    this.posts = const [],
    this.isLoading = true,
    this.isFetchingMore = false,
    this.currentPage = 1,
    this.hasMore = true,
  });

  FeedState copyWith({
    List<PostModel>? posts,
    bool? isLoading,
    bool? isFetchingMore,
    int? currentPage,
    bool? hasMore,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// ── Feed notifier ─────────────────────────────────────────────────────────────
class FeedNotifier extends StateNotifier<FeedState> {
  final PostRepository _repository;

  FeedNotifier(this._repository) : super(const FeedState()) {
    _fetchInitial();
  }

  Future<void> _fetchInitial() async {
    state = state.copyWith(isLoading: true);
    final posts = await _repository.fetchPosts(page: 1);
    state = state.copyWith(
      posts: posts,
      isLoading: false,
      currentPage: 1,
    );
  }

  Future<void> fetchMore() async {
    if (state.isFetchingMore || !state.hasMore) return;

    state = state.copyWith(isFetchingMore: true);
    final nextPage = state.currentPage + 1;

    // Stop after page 10 (100 posts) to simulate end of feed
    if (nextPage > 10) {
      state = state.copyWith(isFetchingMore: false, hasMore: false);
      return;
    }

    final newPosts = await _repository.fetchPosts(page: nextPage);
    state = state.copyWith(
      posts: [...state.posts, ...newPosts],
      isFetchingMore: false,
      currentPage: nextPage,
    );
  }

  void toggleLike(String postId) {
    state = state.copyWith(
      posts: state.posts.map((p) {
        if (p.id == postId) return p.copyWith(isLiked: !p.isLiked);
        return p;
      }).toList(),
    );
  }

  void toggleSave(String postId) {
    state = state.copyWith(
      posts: state.posts.map((p) {
        if (p.id == postId) return p.copyWith(isSaved: !p.isSaved);
        return p;
      }).toList(),
    );
  }
}

final feedProvider = StateNotifierProvider<FeedNotifier, FeedState>((ref) {
  final repo = ref.read(postRepositoryProvider);
  return FeedNotifier(repo);
});
