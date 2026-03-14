// lib/widgets/shimmer_feed.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerFeed extends StatelessWidget {
  const ShimmerFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildShimmerStoriesTray(),
        const Divider(height: 1),
        ...List.generate(3, (_) => _buildShimmerPost()),
      ],
    );
  }

  Widget _buildShimmerStoriesTray() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        height: 104,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          itemCount: 7,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 48,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerPost() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                const CircleAvatar(radius: 18, backgroundColor: Colors.white),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 80,
                      height: 10,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Image placeholder
          Container(
            width: double.infinity,
            height: 375,
            color: Colors.white,
          ),
          // Action bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(width: 24, height: 24, color: Colors.white),
                const SizedBox(width: 16),
                Container(width: 24, height: 24, color: Colors.white),
                const SizedBox(width: 16),
                Container(width: 24, height: 24, color: Colors.white),
              ],
            ),
          ),
          // Like count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(width: 100, height: 12, color: Colors.white),
          ),
          const SizedBox(height: 8),
          // Caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(width: 250, height: 12, color: Colors.white),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
