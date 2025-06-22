import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../cubit/profile/profile_cubit.dart';
import '../cubit/profile/profile_state.dart';
import '../cubit/profile_preferences/profile_preferences_cubit.dart';
import '../cubit/profile_stats/profile_stats_cubit.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_section.dart';
import '../widgets/profile_stats_card.dart';


/// Main Profile Page for roshdology123
///
/// Features:
/// - User profile header with avatar and basic info
/// - Quick stats overview
/// - Menu sections for account management
/// - Settings and preferences access
/// - Account actions (logout, delete account)
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();

    // Listen to scroll to show/hide app bar title
    _scrollController.addListener(_onScroll);

    // Load initial data
    _loadProfileData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final showTitle = _scrollController.offset > 180;
    if (showTitle != _showAppBarTitle) {
      setState(() {
        _showAppBarTitle = showTitle;
      });
    }
  }

  void _loadProfileData() {
    context.read<ProfileCubit>().loadProfile();
    context.read<ProfilePreferencesCubit>().loadPreferences();
    context.read<ProfileStatsCubit>().loadStats();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: theme.colorScheme.onSurface,
              title: AnimatedOpacity(
                opacity: _showAppBarTitle ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  'Profile',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.1),
                        theme.colorScheme.surface,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 60),
                          Row(
                            children: [
                              Text(
                                'Profile',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () => context.push('/profile/settings'),
                                icon: Icon(
                                  Icons.settings_outlined,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: _handleMenuAction,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'refresh',
                      child: Row(
                        children: [
                          Icon(Icons.refresh, size: 20),
                          SizedBox(width: 12),
                          Text('Refresh'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 20),
                          SizedBox(width: 12),
                          Text('Edit Profile'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'export',
                      child: Row(
                        children: [
                          Icon(Icons.download_outlined, size: 20),
                          SizedBox(width: 12),
                          Text('Export Data'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: () async {
            _loadProfileData();
            await Future.delayed(const Duration(milliseconds: 1000));
          },
          child: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: theme.colorScheme.error,
                    action: SnackBarAction(
                      label: 'Retry',
                      textColor: theme.colorScheme.onError,
                      onPressed: () => context.read<ProfileCubit>().loadProfile(),
                    ),
                  ),
                );
              } else if (state is ProfileUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: theme.colorScheme.tertiary,
                  ),
                );
              }
            },
            builder: (context, state) {
              return _buildBody(state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ProfileState state) {
    if (state is ProfileLoading) {
      return const Center(
        child: LoadingWidget(message: 'Loading profile...'),
      );
    }

    if (state is ProfileError && state.currentProfile == null) {
      return Center(
        child: CustomErrorWidget(
          message: state.message,
          onRetry: () => context.read<ProfileCubit>().loadProfile(),
        ),
      );
    }

    final profile = (state is ProfileLoaded)
        ? state.profile
        : (state is ProfileError)
        ? state.currentProfile
        : null;

    if (profile == null) {
      return const Center(
        child: CustomErrorWidget(
          message: 'Unable to load profile. Please try again.',
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          ProfileHeader(profile: profile),

          const SizedBox(height: 24),

          // Profile Stats
          const ProfileStatsCard(),

          const SizedBox(height: 24),

          // Tab Section
          _buildTabSection(),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorColor: theme.colorScheme.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(
                icon: Icon(Icons.account_circle_outlined, size: 20),
                text: 'Account',
              ),
              Tab(
                icon: Icon(Icons.settings_outlined, size: 20),
                text: 'Settings',
              ),
              Tab(
                icon: Icon(Icons.info_outline, size: 20),
                text: 'About',
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAccountTab(),
              _buildSettingsTab(),
              _buildAboutTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountTab() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileMenuSection(
            title: 'Personal Information',
            items: [
              ProfileMenuItem(
                icon: Icons.edit_outlined,
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: () => context.push('/profile/edit'),
              ),
              ProfileMenuItem(
                icon: Icons.email_outlined,
                title: 'Email Verification',
                subtitle: 'Verify your email address',
                trailing: _buildVerificationBadge(true),
                onTap: () => _verifyEmail(),
              ),
              ProfileMenuItem(
                icon: Icons.phone_outlined,
                title: 'Phone Verification',
                subtitle: 'Verify your phone number',
                trailing: _buildVerificationBadge(false),
                onTap: () => _verifyPhone(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ProfileMenuSection(
            title: 'Security',
            items: [
              ProfileMenuItem(
                icon: Icons.lock_outline,
                title: 'Change Password',
                subtitle: 'Update your account password',
                onTap: () => _changePassword(),
              ),
              ProfileMenuItem(
                icon: Icons.security_outlined,
                title: 'Two-Factor Authentication',
                subtitle: 'Add an extra layer of security',
                onTap: () => context.push('/profile/security'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileMenuSection(
            title: 'App Settings',
            items: [
              ProfileMenuItem(
                icon: Icons.palette_outlined,
                title: 'Theme',
                subtitle: 'Change app appearance',
                onTap: () => context.push('/profile/settings/theme'),
              ),
              ProfileMenuItem(
                icon: Icons.language_outlined,
                title: 'Language',
                subtitle: 'Change app language',
                onTap: () => context.push('/profile/settings/language'),
              ),
              ProfileMenuItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage notification preferences',
                onTap: () => context.push('/profile/settings/notifications'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ProfileMenuSection(
            title: 'Privacy',
            items: [
              ProfileMenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Settings',
                subtitle: 'Control your data sharing',
                onTap: () => context.push('/profile/settings/privacy'),
              ),
              ProfileMenuItem(
                icon: Icons.download_outlined,
                title: 'Export Data',
                subtitle: 'Download your account data',
                onTap: () => _exportData(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileMenuSection(
            title: 'Support',
            items: [
              ProfileMenuItem(
                icon: Icons.help_outline,
                title: 'Help Center',
                subtitle: 'Get help and support',
                onTap: () => context.push('/support'),
              ),
              ProfileMenuItem(
                icon: Icons.feedback_outlined,
                title: 'Send Feedback',
                subtitle: 'Help us improve the app',
                onTap: () => context.push('/feedback'),
              ),
              ProfileMenuItem(
                icon: Icons.star_outline,
                title: 'Rate App',
                subtitle: 'Rate us on the App Store',
                onTap: () => _rateApp(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ProfileMenuSection(
            title: 'Legal',
            items: [
              ProfileMenuItem(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                subtitle: 'Read our terms and conditions',
                onTap: () => context.push('/legal/terms'),
              ),
              ProfileMenuItem(
                icon: Icons.shield_outlined,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: () => context.push('/legal/privacy'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ProfileMenuSection(
            title: 'Account Actions',
            items: [
              ProfileMenuItem(
                icon: Icons.logout,
                title: 'Sign Out',
                subtitle: 'Sign out of your account',
                textColor: theme.colorScheme.error,
                onTap: () => _signOut(),
              ),
              ProfileMenuItem(
                icon: Icons.delete_forever_outlined,
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                textColor: theme.colorScheme.error,
                onTap: () => _deleteAccount(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationBadge(bool isVerified) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isVerified ? theme.colorScheme.tertiary : theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isVerified ? 'Verified' : 'Pending',
        style: theme.textTheme.labelSmall?.copyWith(
          color: isVerified ? theme.colorScheme.onTertiary : theme.colorScheme.onSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'refresh':
        _loadProfileData();
        break;
      case 'edit':
        context.push('/profile/edit');
        break;
      case 'export':
        _exportData();
        break;
    }
  }

  void _verifyEmail() {
    context.read<ProfileCubit>().verifyEmail();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Verification email sent to roshdology123@example.com'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }

  void _verifyPhone() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verify Phone Number'),
        content: const Text('Send verification code to +20-12-3456-7890?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileCubit>().verifyPhone('+20-12-3456-7890');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Verification code sent to your phone'),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                ),
              );
            },
            child: const Text('Send Code'),
          ),
        ],
      ),
    );
  }

  void _changePassword() {
    context.push('/profile/change-password');
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Account Data'),
        content: const Text(
          'This will create a downloadable file containing all your account data. '
              'The download link will be sent to your email.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileCubit>().exportUserData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Data export started. Check your email for download link.'),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Thank you for your feedback!'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }

  void _signOut() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement sign out logic
              context.go('/auth/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '⚠️ Delete Account',
          style: TextStyle(color: theme.colorScheme.error),
        ),
        content: const Text(
          'This action is irreversible. All your data will be permanently deleted. '
              'Are you absolutely sure you want to delete your account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/profile/delete-account');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}

/// Profile Menu Item Model
class ProfileMenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final Color? textColor;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.textColor,
    this.onTap,
  });
}