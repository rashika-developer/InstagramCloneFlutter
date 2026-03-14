// lib/widgets/story_tray.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/story_model.dart';

class StoryTray extends StatelessWidget {
  final List<StoryModel> stories;

  const StoryTray({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return _StoryTile(story: stories[index]);
        },
      ),
    );
  }
}

class _StoryTile extends StatelessWidget {
  final StoryModel story;

  const _StoryTile({required this.story});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // could open story viewer
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAvatar(),
            const SizedBox(height: 4),
            Text(
              story.isYours ? 'Your story' : story.username.split('.').first,
              style: const TextStyle(fontSize: 11.5, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (story.isYours) {
      return Stack(
        children: [
          _avatar(hasBorder: false),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFF0095F6),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 14),
            ),
          ),
        ],
      );
    }

    return Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: story.isSeen
            ? null
            : const LinearGradient(
                colors: [Color(0xFFF58529), Color(0xFFDD2A7B), Color(0xFF8134AF)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
        color: story.isSeen ? Colors.grey[300] : null,
      ),
      padding: const EdgeInsets.all(2.5),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(2),
        child: _avatar(hasBorder: false),
      ),
    );
  }

  Widget _avatar({required bool hasBorder}) {
    return CircleAvatar(
      radius: 28,
      backgroundImage: CachedNetworkImageProvider(story.avatarUrl),
      backgroundColor: Colors.grey[200],
    );
  }
}
