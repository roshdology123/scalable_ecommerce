class OnboardingPageModel {
  final String title;
  final String description;
  final String imagePath;
  final String? lottieAsset;

  const OnboardingPageModel({
    required this.title,
    required this.description,
    required this.imagePath,
    this.lottieAsset,
  });
}