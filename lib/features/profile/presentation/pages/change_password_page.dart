import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/profile/profile_cubit.dart';
import '../cubit/profile/profile_state.dart';


/// Change Password Page for updating user password
///
/// Features:
/// - Current password verification
/// - New password strength validation
/// - Real-time password strength indicator
/// - Security best practices guidance
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  PasswordStrength _passwordStrength = PasswordStrength.weak;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_updatePasswordStrength);
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength() {
    setState(() {
      _passwordStrength = _calculatePasswordStrength(_newPasswordController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showPasswordHelp(context),
          ),
        ],
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfilePasswordChanging) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is ProfilePasswordChanged) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('🔒 Password changed successfully!'),
                backgroundColor: theme.colorScheme.tertiary,
                action: SnackBarAction(
                  label: 'Sign Out',
                  onPressed: () => context.go('/auth/login'),
                ),
              ),
            );
            // Clear form
            _currentPasswordController.clear();
            _newPasswordController.clear();
            _confirmPasswordController.clear();
            _updatePasswordStrength();
          } else if (state is ProfileError) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  _buildHeaderSection(),

                  const SizedBox(height: 32),

                  // Current Password Section
                  _buildCurrentPasswordSection(),

                  const SizedBox(height: 24),

                  // New Password Section
                  _buildNewPasswordSection(),

                  const SizedBox(height: 24),

                  // Password Strength Indicator
                  _buildPasswordStrengthIndicator(),

                  const SizedBox(height: 24),

                  // Confirm Password Section
                  _buildConfirmPasswordSection(),

                  const SizedBox(height: 32),

                  // Security Tips
                  _buildSecurityTips(),

                  const SizedBox(height: 32),

                  // Change Password Button
                  _buildChangePasswordButton(),

                  const SizedBox(height: 16),

                  // Last Changed Info
                  _buildLastChangedInfo(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection() {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.lock_outline,
                color: theme.colorScheme.primary,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Update Your Password',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Keep your account secure with a strong password',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Account: roshdology123',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPasswordSection() {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.key_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Current Password',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _currentPasswordController,
              obscureText: !_showCurrentPassword,
              decoration: InputDecoration(
                labelText: 'Current Password',
                hintText: 'Enter your current password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showCurrentPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _showCurrentPassword = !_showCurrentPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Current password is required';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewPasswordSection() {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lock_reset_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'New Password',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _newPasswordController,
              obscureText: !_showNewPassword,
              decoration: InputDecoration(
                labelText: 'New Password',
                hintText: 'Create a strong new password',
                prefixIcon: const Icon(Icons.lock_reset_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showNewPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _showNewPassword = !_showNewPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'New password is required';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                if (!_hasUppercase(value)) {
                  return 'Password must contain at least one uppercase letter';
                }
                if (!_hasLowercase(value)) {
                  return 'Password must contain at least one lowercase letter';
                }
                if (!_hasNumber(value)) {
                  return 'Password must contain at least one number';
                }
                if (!_hasSpecialChar(value)) {
                  return 'Password must contain at least one special character';
                }
                if (value == _currentPasswordController.text) {
                  return 'New password must be different from current password';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final theme = Theme.of(context);
    final strengthColor = _getStrengthColor(theme, _passwordStrength);
    final strengthText = _getStrengthText(_passwordStrength);
    final progress = _getStrengthProgress(_passwordStrength);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.security_outlined,
                  color: strengthColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Password Strength',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: strengthColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: strengthColor),
                  ),
                  child: Text(
                    strengthText,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: strengthColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            LinearProgressIndicator(
              value: progress,
              backgroundColor: theme.colorScheme.outline.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
            ),

            const SizedBox(height: 16),

            _buildPasswordRequirements(),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    final theme = Theme.of(context);
    final password = _newPasswordController.text;

    final requirements = [
      {'text': 'At least 8 characters', 'met': password.length >= 8},
      {'text': 'One uppercase letter', 'met': _hasUppercase(password)},
      {'text': 'One lowercase letter', 'met': _hasLowercase(password)},
      {'text': 'One number', 'met': _hasNumber(password)},
      {'text': 'One special character', 'met': _hasSpecialChar(password)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: requirements.map((req) {
        final isMet = req['met'] as bool;
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Icon(
                isMet ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 16,
                color: isMet ? theme.colorScheme.tertiary : theme.colorScheme.outline,
              ),
              const SizedBox(width: 8),
              Text(
                req['text'] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isMet
                      ? theme.colorScheme.tertiary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isMet ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConfirmPasswordSection() {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Confirm New Password',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _confirmPasswordController,
              obscureText: !_showConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                hintText: 'Re-enter your new password',
                prefixIcon: const Icon(Icons.verified_user_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _showConfirmPassword = !_showConfirmPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your new password';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityTips() {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Security Tips',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            ..._buildSecurityTipsList(theme),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSecurityTipsList(ThemeData theme) {
    final tips = [
      'Use a unique password that you don\'t use elsewhere',
      'Consider using a password manager',
      'Avoid personal information in passwords',
      'Change your password regularly',
      'Enable two-factor authentication for extra security',
    ];

    return tips.map((tip) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    )).toList();
  }

  Widget _buildChangePasswordButton() {
    final theme = Theme.of(context);
    final canSubmit = _passwordStrength != PasswordStrength.weak &&
        _currentPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (!canSubmit || _isLoading) ? null : _changePassword,
        child: _isLoading
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Changing Password...'),
          ],
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_reset),
            SizedBox(width: 8),
            Text('Change Password'),
          ],
        ),
      ),
    );
  }

  Widget _buildLastChangedInfo() {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        children: [
          Text(
            'Password last changed: Never',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Last updated: 2025-06-22 09:18:54',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _changePassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<ProfileCubit>().changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );
  }

  void _showPasswordHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Password Security Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Creating a Strong Password:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Use at least 8 characters\n• Mix uppercase and lowercase letters\n• Include numbers and special characters\n• Avoid dictionary words and personal info'),
              SizedBox(height: 16),
              Text(
                'Password Security:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Don\'t reuse passwords across sites\n• Consider using a password manager\n• Enable two-factor authentication\n• Change passwords if you suspect a breach'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  // Password validation helpers
  bool _hasUppercase(String password) => password.contains(RegExp(r'[A-Z]'));
  bool _hasLowercase(String password) => password.contains(RegExp(r'[a-z]'));
  bool _hasNumber(String password) => password.contains(RegExp(r'[0-9]'));
  bool _hasSpecialChar(String password) => password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  PasswordStrength _calculatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;

    // Length check
    if (password.length >= 8) score += 2;
    if (password.length >= 12) score += 1;

    // Character variety
    if (_hasUppercase(password)) score += 1;
    if (_hasLowercase(password)) score += 1;
    if (_hasNumber(password)) score += 1;
    if (_hasSpecialChar(password)) score += 1;

    // Complexity bonus
    if (password.length >= 8 && _hasUppercase(password) && _hasLowercase(password) &&
        _hasNumber(password) && _hasSpecialChar(password)) {
      score += 2;
    }

    if (score < 4) return PasswordStrength.weak;
    if (score < 7) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  Color _getStrengthColor(ThemeData theme, PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return theme.colorScheme.error;
      case PasswordStrength.medium:
        return theme.colorScheme.secondary;
      case PasswordStrength.strong:
        return theme.colorScheme.tertiary;
    }
  }

  String _getStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Good';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }

  double _getStrengthProgress(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 0.3;
      case PasswordStrength.medium:
        return 0.6;
      case PasswordStrength.strong:
        return 1.0;
    }
  }
}

enum PasswordStrength { weak, medium, strong }