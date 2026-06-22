class MusicReview {
  final String id;
  final String userId;
  final String title;
  final String artist;
  final String album;      // <--- adicionado
  final String imageUrl;   // <--- adicionado
  final double rating;
  final String comment;
  final DateTime createdAt;

  MusicReview({
    required this.id,
    required this.userId,
    required this.title,
    required this.artist,
    required this.album,      // <--- adicionado
    required this.imageUrl,   // <--- adicionado
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'artist': artist,
      'album': album,       // <--- adicionado
      'imageUrl': imageUrl, // <--- adicionado
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}