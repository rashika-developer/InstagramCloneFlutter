// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/feed_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/story_tray.dart';
import '../widgets/shimmer_feed.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Listen for scroll to trigger pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final feedState = ref.read(feedProvider);
    final posts = feedState.posts;

    if (posts.isEmpty) return;

    // Each post is roughly 500px tall.
    // Trigger fetch when 2 posts from the bottom.
    final triggerOffset =
        _scrollController.position.maxScrollExtent - (500 * 2);

    if (_scrollController.offset >= triggerOffset) {
      ref.read(feedProvider.notifier).fetchMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedProvider);
    final storiesAsync = ref.watch(storiesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            const Divider(height: 1, thickness: 0.5),
            Expanded(
              child: feedState.isLoading
                  ? const ShimmerFeed()
                  : _buildFeed(feedState, storiesAsync),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Instagram wordmark (using text as stand-in for the actual logo font)
          const Text(
            'Instagram',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),

          // Notification bell
          _TopBarIcon(
            icon: Icons.favorite_border,
            onTap: () => _showSnackbar(context, 'Notifications'),
          ),
          const SizedBox(width: 8),

          // Messages
          _TopBarIcon(
            icon: Icons.send_outlined,
            onTap: () => _showSnackbar(context, 'Messages'),
          ),
        ],
      ),
    );
  }

  // ── Main feed ─────────────────────────────────────────────────────────────
  Widget _buildFeed(FeedState feedState, AsyncValue storiesAsync) {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () async {
        // Reload feed on pull-to-refresh
        ref.invalidate(feedProvider);
        ref.invalidate(storiesProvider);
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Stories tray
          SliverToBoxAdapter(
            child: storiesAsync.when(
              data: (stories) => StoryTray(stories: stories),
              loading: () => const SizedBox(height: 104),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),

          const SliverToBoxAdapter(
            child: Divider(height: 1, thickness: 0.5),
          ),

          // ── Posts
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < feedState.posts.length) {
                  return Column(
                    children: [
                      PostCard(post: feedState.posts[index]),
                      const Divider(height: 1, thickness: 0.5),
                    ],
                  );
                }
                return null;
              },
              childCount: feedState.posts.length,
            ),
          ),

          // ── Pagination loader or end-of-feed message
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: feedState.isFetchingMore
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: Colors.grey,
                      ),
                    )
                  : !feedState.hasMore
                      ? const Center(
                          child: Text(
                            'You\'re all caught up 🎉',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        )
                      : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature is not available in this demo'),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.black87,
      ),
    );
  }
}

class _TopBarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopBarIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 26),
    );
  }
}
