// lib/widgets/post_card.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';
import '../providers/feed_provider.dart';
import 'carousel_widget.dart';

class PostCard extends ConsumerStatefulWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartScale;
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heartScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    // Double tap to like — Instagram classic
    ref.read(feedProvider.notifier).toggleLike(widget.post.id);
    setState(() => _showHeart = true);
    _heartController.forward(from: 0).then((_) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _showHeart = false);
      });
    });
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

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, post),
        _buildImageArea(context, post),
        _buildActionBar(context, post),
        _buildLikes(post),
        _buildCaption(post),
        _buildCommentHint(context, post),
        _buildTimestamp(post),
        const SizedBox(height: 4),
      ],
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, PostModel post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Avatar with gradient ring
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFF58529), Color(0xFFDD2A7B), Color(0xFF8134AF)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(1.5),
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(post.avatarUrl),
                backgroundColor: Colors.grey[200],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Username + location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                ),
                if (post.location.isNotEmpty)
                  Text(
                    post.location,
                    style: const TextStyle(fontSize: 11.5, color: Colors.black87),
                  ),
              ],
            ),
          ),

          // 3-dot menu
          GestureDetector(
            onTap: () => _showSnackbar(context, 'Post options'),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.more_horiz, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  // ── Image area with double-tap to like ────────────────────────────────────
  Widget _buildImageArea(BuildContext context, PostModel post) {
    return GestureDetector(
      onDoubleTap: _onDoubleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CarouselWidget(imageUrls: post.imageUrls),

          // Floating heart on double-tap
          if (_showHeart)
            ScaleTransition(
              scale: _heartScale,
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 90,
                shadows: [Shadow(blurRadius: 20, color: Colors.black38)],
              ),
            ),
        ],
      ),
    );
  }

  // ── Action bar ─────────────────────────────────────────────────────────────
  Widget _buildActionBar(BuildContext context, PostModel post) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Row(
        children: [
          // Like button
          _ActionButton(
            icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
            color: post.isLiked ? Colors.red : Colors.black,
            onTap: () => ref.read(feedProvider.notifier).toggleLike(post.id),
          ),
          const SizedBox(width: 16),

          // Comment button
          _ActionButton(
            icon: Icons.chat_bubble_outline,
            onTap: () => _showSnackbar(context, 'Comments'),
          ),
          const SizedBox(width: 16),

          // Share button
          _ActionButton(
            icon: Icons.send_outlined,
            onTap: () => _showSnackbar(context, 'Share'),
          ),

          const Spacer(),

          // Save button
          _ActionButton(
            icon: post.isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: post.isSaved ? Colors.black : Colors.black,
            onTap: () => ref.read(feedProvider.notifier).toggleSave(post.id),
          ),
        ],
      ),
    );
  }

  // ── Like count ─────────────────────────────────────────────────────────────
  Widget _buildLikes(PostModel post) {
    final count = post.isLiked ? post.likeCount + 1 : post.likeCount;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        '${_formatCount(count)} likes',
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
      ),
    );
  }

  // ── Caption ────────────────────────────────────────────────────────────────
  Widget _buildCaption(PostModel post) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 13.5),
          children: [
            TextSpan(
              text: post.username,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(text: '  '),
            TextSpan(text: post.caption),
          ],
        ),
      ),
    );
  }

  // ── Comment hint ───────────────────────────────────────────────────────────
  Widget _buildCommentHint(BuildContext context, PostModel post) {
    if (post.commentCount == 0) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () => _showSnackbar(context, 'Comments'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
        child: Text(
          'View all ${_formatCount(post.commentCount)} comments',
          style: const TextStyle(color: Colors.black54, fontSize: 13.5),
        ),
      ),
    );
  }

  // ── Timestamp ─────────────────────────────────────────────────────────────
  Widget _buildTimestamp(PostModel post) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
      child: Text(
        _formatTimeAgo(post.timeAgo),
        style: const TextStyle(color: Colors.black45, fontSize: 11),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }

  String _formatTimeAgo(String raw) {
    switch (raw) {
      case '2m': return '2 minutes ago';
      case '15m': return '15 minutes ago';
      case '1h': return '1 hour ago';
      case '3h': return '3 hours ago';
      case '8h': return '8 hours ago';
      case '1d': return '1 day ago';
      case '2d': return '2 days ago';
      default: return raw;
    }
  }
}

// ── Reusable icon button ──────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 26, color: color),
    );
  }
}
