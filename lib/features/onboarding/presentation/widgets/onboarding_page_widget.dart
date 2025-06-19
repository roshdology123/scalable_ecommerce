import 'package:flutter/material.dart';
import '../../../onboarding/models/onboarding_page_model.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPageModel pageModel;
  final bool isLastPage;

  const OnboardingPageWidget({
    super.key,
    required this.pageModel,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Image Section
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: _buildImage(context),
            ),
          ),

          // Content Section
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Title
                Text(
                  pageModel.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  pageModel.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Special content for last page
                if (isLastPage) ...[
                  _buildLastPageActions(context),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _buildImageWidget(),
      ),
    );
  }

  Widget _buildImageWidget() {
    // Try to load image, fallback to icon if not found
    return Image.asset(
      pageModel.imagePath,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackIcon();
      },
    );
  }

  Widget _buildFallbackIcon() {
    IconData iconData;
    Color iconColor;

    switch (pageModel.title) {
      case 'Welcome to E-Commerce':
        iconData = Icons.store;
        iconColor = Colors.blue;
        break;
      case 'Easy & Secure Shopping':
        iconData = Icons.security;
        iconColor = Colors.green;
        break;
      case 'Fast Delivery':
        iconData = Icons.local_shipping;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.shopping_cart;
        iconColor = Colors.purple;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            iconColor.withOpacity(0.1),
            iconColor.withOpacity(0.2),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          iconData,
          size: 120,
          color: iconColor,
        ),
      ),
    );
  }

  Widget _buildLastPageActions(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
                Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.celebration,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'You\'re all set! Ready to start shopping?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}