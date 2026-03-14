// lib/models/story_model.dart

class StoryModel {
  final String id;
  final String username;
  final String avatarUrl;
  final bool isSeen;
  final bool isYours;

  const StoryModel({
    required this.id,
    required this.username,
    required this.avatarUrl,
    this.isSeen = false,
    this.isYours = false,
  });
}
