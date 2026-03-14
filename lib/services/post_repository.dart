// lib/services/post_repository.dart

import 'dart:math';
import '../models/post_model.dart';
import '../models/story_model.dart';

class PostRepository {
  // High-quality public image URLs (Unsplash)
  static const List<String> _imagePool = [
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
    'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800',
    'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=800',
    'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800',
    'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=800',
    'https://images.unsplash.com/photo-1433086966358-54859d0ed716?w=800',
    'https://images.unsplash.com/photo-1462275646964-a0e3386b89fa?w=800',
    'https://images.unsplash.com/photo-1455156218388-5e61b526818b?w=800',
    'https://images.unsplash.com/photo-1504701954957-2010ec3bcec1?w=800',
    'https://images.unsplash.com/photo-1518020382113-a7e8fc38eac9?w=800',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=800',
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=800',
    'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=800',
    'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=800',
  ];

  static const List<String> _avatarPool = [
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=150',
    'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=150',
    'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=150',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
  ];

  static const List<String> _usernames = [
    'alex.wanderlust',
    'mountain_maya',
    'urban.lens',
    'sophie.creates',
    'the.real.jake',
    'natalie.photos',
    'travel.with.tom',
    'lens.by.lara',
    'marco.visuals',
    'nina_outdoors',
  ];

  static const List<String> _locations = [
    'Santorini, Greece',
    'Kyoto, Japan',
    'New York City',
    'Amalfi Coast, Italy',
    'Banff, Canada',
    'Bali, Indonesia',
    'Paris, France',
    'Iceland',
    'Dubai, UAE',
    'Patagonia, Chile',
  ];

  static const List<String> _captions = [
    'Golden hour never disappoints ✨ #travel #photography',
    'Lost in the mountains 🏔️ Sometimes you need to disappear to find yourself.',
    'City lights & late nights 🌃 #citylife #urban',
    'The best views come after the hardest climbs 🌄',
    'Chasing sunsets around the world 🌅 #wanderlust',
    'Nature is the greatest artist 🎨 #landscape #nature',
    'Every journey begins with a single step 👣 #adventure',
    'Finding magic in ordinary places ✨',
    'The world is a book, and those who don\'t travel read only one page 📖',
    'Life is short, travel often ✈️ #travelgram',
  ];

  final Random _random = Random();

  /// Fetches first page with 1.5s simulated latency
  Future<List<PostModel>> fetchPosts({int page = 1}) async {
    // Simulate network latency — required by the assignment
    await Future.delayed(const Duration(milliseconds: 1500));

    return _generatePosts(page: page, count: 10);
  }

  /// Fetches stories with 1.5s simulated latency
  Future<List<StoryModel>> fetchStories() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return _generateStories();
  }

  List<PostModel> _generatePosts({required int page, required int count}) {
    final List<PostModel> posts = [];
    final int startIndex = (page - 1) * count;

    for (int i = 0; i < count; i++) {
      final int idx = (startIndex + i) % _usernames.length;
      final bool isCarousel = _random.nextBool();

      final List<String> images = isCarousel
          ? [
              _imagePool[_random.nextInt(_imagePool.length)],
              _imagePool[_random.nextInt(_imagePool.length)],
              _imagePool[_random.nextInt(_imagePool.length)],
            ]
          : [_imagePool[_random.nextInt(_imagePool.length)]];

      posts.add(PostModel(
        id: 'post_${page}_$i',
        username: _usernames[idx % _usernames.length],
        avatarUrl: _avatarPool[idx % _avatarPool.length],
        location: _locations[_random.nextInt(_locations.length)],
        imageUrls: images,
        caption: _captions[_random.nextInt(_captions.length)],
        likeCount: 1000 + _random.nextInt(49000),
        commentCount: 10 + _random.nextInt(990),
        timeAgo: _randomTimeAgo(),
      ));
    }

    return posts;
  }

  List<StoryModel> _generateStories() {
    final List<StoryModel> stories = [];

    // "Your story" tile first
    stories.add(const StoryModel(
      id: 'yours',
      username: 'Your Story',
      avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      isYours: true,
    ));

    for (int i = 0; i < 8; i++) {
      stories.add(StoryModel(
        id: 'story_$i',
        username: _usernames[i % _usernames.length],
        avatarUrl: _avatarPool[i % _avatarPool.length],
        isSeen: i > 4,
      ));
    }

    return stories;
  }

  String _randomTimeAgo() {
    final options = ['2m', '15m', '1h', '3h', '8h', '1d', '2d'];
    return options[_random.nextInt(options.length)];
  }
}
