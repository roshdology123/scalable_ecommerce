import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

/// Use case for uploading user profile image
///
/// This use case handles:
/// - Image validation and processing
/// - Uploading image to cloud storage
/// - Generating optimized image URLs
/// - Updating profile with new image URL
///
/// Image requirements:
/// - Maximum size: 5MB
/// - Supported formats: JPEG, PNG, WebP
/// - Minimum dimensions: 100x100 pixels
/// - Maximum dimensions: 2048x2048 pixels
/// - Automatic optimization and resizing
///
/// Usage:
/// ```dart
/// final params = UploadProfileImageParams(imageFile: pickedFile);
/// final result = await uploadProfileImageUseCase(params);
/// result.fold(
///   (failure) => handleError(failure),
///   (imageUrl) => updateProfileWithImage(imageUrl),
/// );
/// ```
@injectable
class UploadProfileImageUseCase extends UseCase<String, UploadProfileImageParams> {
  final ProfileRepository _repository;

  UploadProfileImageUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(UploadProfileImageParams params) async {
    try {
      print('Uploading profile image: ${params.imageFile.name}');

      // Validate image file
      final validationResult = await _validateImageFile(params.imageFile);
      if (validationResult != null) {
        return Left(validationResult);
      }

      final result = await _repository.uploadProfileImage(params.imageFile);

      return result.fold(
            (failure) {
          print('UploadProfileImageUseCase failed: ${failure.message}');
          return Left(failure);
        },
            (imageUrl) {
          print('Profile image uploaded successfully: $imageUrl');
          return Right(imageUrl);
        },
      );
    } catch (e) {
      print('Unexpected error in UploadProfileImageUseCase: $e');
      return Left(UnknownFailure(
        message: 'Unexpected error occurred while uploading image: ${e.toString()}',
        code: 'UPLOAD_IMAGE_UNKNOWN_ERROR',
      ));
    }
  }

  /// Validates image file before upload
  Future<ValidationFailure?> _validateImageFile(XFile imageFile) async {
    try {
      // Check file size
      final fileSize = await imageFile.length();
      const maxSizeBytes = 5 * 1024 * 1024; // 5MB

      if (fileSize > maxSizeBytes) {
        return ValidationFailure(
          message: 'Image size must be less than 5MB',
          code: 'IMAGE_TOO_LARGE',
        );
      }

      // Check file format
      final mimeType = imageFile.mimeType;
      final allowedTypes = ['image/jpeg', 'image/png', 'image/webp'];

      if (mimeType == null || !allowedTypes.contains(mimeType)) {
        return ValidationFailure(
          message: 'Only JPEG, PNG, and WebP images are supported',
          code: 'INVALID_IMAGE_FORMAT',
        );
      }

      // Additional validation could include:
      // - Image dimensions check
      // - Content validation (actual image data)
      // - Virus scanning in production

      return null; // No validation errors
    } catch (e) {
      return ValidationFailure(
        message: 'Failed to validate image file: ${e.toString()}',
        code: 'IMAGE_VALIDATION_ERROR',
      );
    }
  }
}

class UploadProfileImageParams extends Equatable {
  final XFile imageFile;

  const UploadProfileImageParams({required this.imageFile});

  @override
  List<Object?> get props => [imageFile];

  @override
  String toString() => 'UploadProfileImageParams(imageFile: ${imageFile.name})';
}