import '../models/music_review.dart';

class ReviewStore {
  static final List<MusicReview> reviews = [];

  static void addReview(MusicReview review) {
    reviews.add(review);
  }

  static List<MusicReview> getAllReviews() {
    return reviews;
  }

  static void clearReviews() {
    reviews.clear();
  }
}