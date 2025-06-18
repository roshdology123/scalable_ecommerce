import 'package:equatable/equatable.dart';

class Rating extends Equatable {
  final double rate;
  final int count;

  const Rating({
    required this.rate,
    required this.count,
  });

  /// Get rating as percentage (0-100)
  double get percentage => (rate / 5.0) * 100;

  /// Check if rating is good (>= 4.0)
  bool get isGoodRating => rate >= 4.0;

  /// Check if rating is excellent (>= 4.5)
  bool get isExcellentRating => rate >= 4.5;

  /// Get rating description
  String get description {
    if (rate >= 4.5) return 'Excellent';
    if (rate >= 4.0) return 'Very Good';
    if (rate >= 3.5) return 'Good';
    if (rate >= 3.0) return 'Average';
    if (rate >= 2.0) return 'Below Average';
    return 'Poor';
  }

  /// Get star count (rounded to nearest 0.5)
  double get starCount => (rate * 2).round() / 2.0;

  /// Check if has enough reviews for credibility
  bool get hasEnoughReviews => count >= 10;

  /// Get formatted rating text
  String get formattedRating => '${rate.toStringAsFixed(1)} ($count reviews)';

  @override
  List<Object?> get props => [rate, count];

  @override
  String toString() => 'Rating(rate: $rate, count: $count)';

}