import 'package:equatable/equatable.dart';

import '../../../domain/entities/profile.dart';


abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state when profile cubit is first created
class ProfileInitial extends ProfileState {
  const ProfileInitial();

  @override
  String toString() => 'ProfileInitial';
}

/// State when profile is being loaded from server or cache
class ProfileLoading extends ProfileState {
  const ProfileLoading();

  @override
  String toString() => 'ProfileLoading';
}

/// State when profile has been successfully loaded
class ProfileLoaded extends ProfileState {
  final Profile profile;

  const ProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];

  @override
  String toString() => 'ProfileLoaded(profile: ${profile.fullName})';
}

/// State when profile is being updated
class ProfileUpdating extends ProfileState {
  final Profile currentProfile;

  const ProfileUpdating({required this.currentProfile});

  @override
  List<Object?> get props => [currentProfile];

  @override
  String toString() => 'ProfileUpdating(profile: ${currentProfile.fullName})';
}

/// State when profile has been successfully updated
class ProfileUpdated extends ProfileState {
  final Profile profile;
  final String message;

  const ProfileUpdated({
    required this.profile,
    this.message = 'Profile updated successfully',
  });

  @override
  List<Object?> get props => [profile, message];

  @override
  String toString() => 'ProfileUpdated(profile: ${profile.fullName}, message: $message)';
}

/// State when profile image is being uploaded
class ProfileImageUploading extends ProfileState {
  final Profile currentProfile;
  final double uploadProgress;

  const ProfileImageUploading({
    required this.currentProfile,
    this.uploadProgress = 0.0,
  });

  @override
  List<Object?> get props => [currentProfile, uploadProgress];

  @override
  String toString() => 'ProfileImageUploading(progress: ${(uploadProgress * 100).toStringAsFixed(1)}%)';
}

/// State when profile image has been successfully uploaded
class ProfileImageUploaded extends ProfileState {
  final Profile profile;
  final String imageUrl;

  const ProfileImageUploaded({
    required this.profile,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [profile, imageUrl];

  @override
  String toString() => 'ProfileImageUploaded(imageUrl: $imageUrl)';
}

/// State when profile image is being deleted
class ProfileImageDeleting extends ProfileState {
  final Profile currentProfile;

  const ProfileImageDeleting({required this.currentProfile});

  @override
  List<Object?> get props => [currentProfile];

  @override
  String toString() => 'ProfileImageDeleting';
}

/// State when profile image has been successfully deleted
class ProfileImageDeleted extends ProfileState {
  final Profile profile;

  const ProfileImageDeleted({required this.profile});

  @override
  List<Object?> get props => [profile];

  @override
  String toString() => 'ProfileImageDeleted';
}

/// State when password is being changed
class ProfilePasswordChanging extends ProfileState {
  const ProfilePasswordChanging();

  @override
  String toString() => 'ProfilePasswordChanging';
}

/// State when password has been successfully changed
class ProfilePasswordChanged extends ProfileState {
  const ProfilePasswordChanged();

  @override
  String toString() => 'ProfilePasswordChanged';
}

/// State when email verification is being sent
class ProfileEmailVerifying extends ProfileState {
  const ProfileEmailVerifying();

  @override
  String toString() => 'ProfileEmailVerifying';
}

/// State when email verification has been sent
class ProfileEmailVerificationSent extends ProfileState {
  final String email;

  const ProfileEmailVerificationSent({required this.email});

  @override
  List<Object?> get props => [email];

  @override
  String toString() => 'ProfileEmailVerificationSent(email: $email)';
}

/// State when phone verification is being sent
class ProfilePhoneVerifying extends ProfileState {
  const ProfilePhoneVerifying();

  @override
  String toString() => 'ProfilePhoneVerifying';
}

/// State when phone verification has been sent
class ProfilePhoneVerificationSent extends ProfileState {
  final String phoneNumber;

  const ProfilePhoneVerificationSent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];

  @override
  String toString() => 'ProfilePhoneVerificationSent(phoneNumber: $phoneNumber)';
}

/// State when account is being deleted
class ProfileAccountDeleting extends ProfileState {
  const ProfileAccountDeleting();

  @override
  String toString() => 'ProfileAccountDeleting';
}

/// State when account has been successfully deleted
class ProfileAccountDeleted extends ProfileState {
  const ProfileAccountDeleted();

  @override
  String toString() => 'ProfileAccountDeleted';
}

/// State when user data is being exported
class ProfileDataExporting extends ProfileState {
  final double exportProgress;

  const ProfileDataExporting({this.exportProgress = 0.0});

  @override
  List<Object?> get props => [exportProgress];

  @override
  String toString() => 'ProfileDataExporting(progress: ${(exportProgress * 100).toStringAsFixed(1)}%)';
}

/// State when user data export is ready
class ProfileDataExported extends ProfileState {
  final String downloadUrl;
  final String fileName;

  const ProfileDataExported({
    required this.downloadUrl,
    required this.fileName,
  });

  @override
  List<Object?> get props => [downloadUrl, fileName];

  @override
  String toString() => 'ProfileDataExported(fileName: $fileName)';
}

/// State when an error has occurred
class ProfileError extends ProfileState {
  final String message;
  final String code;
  final Profile? currentProfile;

  const ProfileError({
    required this.message,
    required this.code,
    this.currentProfile,
  });

  @override
  List<Object?> get props => [message, code, currentProfile];

  @override
  String toString() => 'ProfileError(code: $code, message: $message)';
}

/// State when a network error has occurred
class ProfileNetworkError extends ProfileState {
  final String message;
  final Profile? cachedProfile;

  const ProfileNetworkError({
    required this.message,
    this.cachedProfile,
  });

  @override
  List<Object?> get props => [message, cachedProfile];

  @override
  String toString() => 'ProfileNetworkError(message: $message, hasCachedProfile: ${cachedProfile != null})';
}