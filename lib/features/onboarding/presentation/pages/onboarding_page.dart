import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_logger.dart';
import '../../data/onboarding_data.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/onboarding_page_widget.dart';
import '../widgets/page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final AppLogger _logger = AppLogger();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();

    // Start onboarding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingCubit>().startOnboarding(OnboardingData.pages.length);
    });

    _logger.logBusinessLogic(
      'onboarding_page_initialized',
      'ui_action',
      {
        'total_pages': OnboardingData.pages.length,
        'user': 'roshdology123',
        'timestamp': '2025-06-19 06:14:38',
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: BlocListener<OnboardingCubit, OnboardingState>(
          listener: (context, state) {
            state.maybeWhen(
              showing: (currentIndex, totalPages) {
                _pageController.animateToPage(
                  currentIndex,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              completed: () {
                _logger.logUserAction('onboarding_navigation_to_home', {
                  'user': 'roshdology123',
                  'timestamp': '2025-06-19 06:14:38',
                });
                context.go('/home');
              },
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $message'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              },
              orElse: () {},
            );
          },
          child: BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              return state.when(
                initial: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                showing: (currentIndex, totalPages) => FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildOnboardingContent(
                    context,
                    currentIndex,
                    totalPages,
                  ),
                ),
                completing: () => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Setting up your experience...',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                completed: () => const SizedBox.shrink(),
                error: (message) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Something went wrong',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => context.go('/home'),
                        child: const Text('Continue Anyway'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingContent(
      BuildContext context,
      int currentIndex,
      int totalPages,
      ) {
    final isLastPage = currentIndex == totalPages - 1;

    return Column(
      children: [
        // Skip Button
        if (!isLastPage)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
                  context.read<OnboardingCubit>().skipOnboarding();
                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
        else
          const SizedBox(height: 56), // Maintain space when skip is hidden

        // Page Content
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              // Note: We don't update the cubit here to avoid conflicts
              // The cubit controls the page view, not the other way around
            },
            itemCount: OnboardingData.pages.length,
            itemBuilder: (context, index) {
              return OnboardingPageWidget(
                pageModel: OnboardingData.pages[index],
                isLastPage: index == totalPages - 1,
              );
            },
          ),
        ),

        // Bottom Section
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Page Indicator
              PageIndicator(
                currentIndex: currentIndex,
                pageCount: totalPages,
              ),

              const SizedBox(height: 32),

              // Navigation Buttons
              Row(
                children: [
                  // Previous Button
                  if (currentIndex > 0)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.read<OnboardingCubit>().previousPage();
                        },
                        icon: const Icon(Icons.chevron_left),
                        label: const Text('Previous'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    )
                  else
                    const Expanded(child: SizedBox.shrink()),

                  if (currentIndex > 0) const SizedBox(width: 16),

                  // Next/Get Started Button
                  Expanded(
                    flex: isLastPage ? 2 : 1,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<OnboardingCubit>().nextPage();
                      },
                      icon: Icon(
                        isLastPage ? Icons.rocket_launch : Icons.chevron_right,
                      ),
                      label: Text(isLastPage ? 'Get Started' : 'Next'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: isLastPage
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}