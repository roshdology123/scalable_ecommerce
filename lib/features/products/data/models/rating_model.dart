import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/rating.dart';

part 'rating_model.freezed.dart';
part 'rating_model.g.dart';

@freezed
@HiveType(typeId: 2)
class RatingModel with _$RatingModel {
  const factory RatingModel({
    @HiveField(0) required double rate,
    @HiveField(1) required int count,
  }) = _RatingModel;

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);

  factory RatingModel.fromRating(Rating rating) {
    return RatingModel(
      rate: rating.rate,
      count: rating.count,
    );
  }
}

extension RatingModelExtension on RatingModel {
  Rating toRating() {
    return Rating(
      rate: rate,
      count: count,
    );
  }
}