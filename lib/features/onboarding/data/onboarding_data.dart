import '../models/onboarding_page_model.dart';

class OnboardingData {
  static const List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      title: 'Welcome to E-Commerce',
      description: 'Discover thousands of products from your favorite brands. Shop with confidence and enjoy the best deals.',
      imagePath: 'assets/images/onboarding_1.png',
    ),
    OnboardingPageModel(
      title: 'Easy & Secure Shopping',
      description: 'Safe and secure payment methods. Your personal information is protected with industry-standard encryption.',
      imagePath: 'assets/images/onboarding_2.png',
    ),
    OnboardingPageModel(
      title: 'Fast Delivery',
      description: 'Get your orders delivered quickly to your doorstep. Track your packages in real-time.',
      imagePath: 'assets/images/onboarding_3.png',
    ),
    OnboardingPageModel(
      title: 'Start Shopping Now',
      description: 'Join millions of satisfied customers. Create your account and start exploring amazing products today!',
      imagePath: 'assets/images/onboarding_4.png',
    ),
  ];
}