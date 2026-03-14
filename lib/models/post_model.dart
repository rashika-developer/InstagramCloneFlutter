// lib/models/post_model.dart

class PostModel {
  final String id;
  final String username;
  final String avatarUrl;
  final String location;
  final List<String> imageUrls; // multiple = carousel
  final String caption;
  final int likeCount;
  final int commentCount;
  final String timeAgo;
  bool isLiked;
  bool isSaved;

  PostModel({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.location,
    required this.imageUrls,
    required this.caption,
    required this.likeCount,
    required this.commentCount,
    required this.timeAgo,
    this.isLiked = false,
    this.isSaved = false,
  });

  PostModel copyWith({bool? isLiked, bool? isSaved}) {
    return PostModel(
      id: id,
      username: username,
      avatarUrl: avatarUrl,
      location: location,
      imageUrls: imageUrls,
      caption: caption,
      likeCount: likeCount,
      commentCount: commentCount,
      timeAgo: timeAgo,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
