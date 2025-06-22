import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/profile/profile_cubit.dart';
import '../cubit/profile/profile_state.dart';


/// Delete Account Page for permanent account deletion
///
/// Features:
/// - Account deletion confirmation process
/// - Data retention information
/// - Final confirmation with typing verification
/// - Immediate effect warning
class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _confirmationController = TextEditingController();
  final _reasonController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _isLoading = false;
  bool _understandsConsequences = false;
  String? _selectedReason;

  final List<String> _deletionReasons = [
    'No longer need the service',
    'Privacy concerns',
    'Too many emails/notifications',
    'Found a better alternative',
    'Account security concerns',
    'Technical issues',
    'Other',
  ];

  @override
  void dispose() {
    _confirmationController.dispose();
    _reasonController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: theme.colorScheme.errorContainer,
        foregroundColor: theme.colorScheme.onErrorContainer,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileAccountDeleting) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is ProfileAccountDeleted) {
            setState(() {
              _isLoading = false;
            });
            _showDeletionSuccess();
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
                  // Warning Header
                  _buildWarningHeader(),

                  const SizedBox(height: 24),

                  // Account Information
                  _buildAccountInfo(),

                  const SizedBox(height: 24),

                  // What Will Be Deleted
                  _buildDeletionInfo(),

                  const SizedBox(height: 24),

                  // Data Retention Info
                  _buildDataRetentionInfo(),

                  const SizedBox(height: 24),

                  // Deletion Reason
                  _buildDeletionReason(),

                  const SizedBox(height: 24),

                  // Password Confirmation
                  _buildPasswordConfirmation(),

                  const SizedBox(height: 24),

                  // Final Confirmation
                  _buildFinalConfirmation(),

                  const SizedBox(height: 24),

                  // Understanding Checkbox
                  _buildUnderstandingCheckbox(),

                  const SizedBox(height: 32),

                  // Delete Button
                  _buildDeleteButton(),

                  const SizedBox(height: 16),

                  // Alternative Actions
                  _buildAlternativeActions(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWarningHeader() {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              '⚠️ Permanent Account Deletion',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onErrorContainer,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone. Your account and all associated data will be permanently deleted.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfo() {
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
                  Icons.account_circle_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Account to be Deleted',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildInfoRow('Username', 'roshdology123', Icons.person_outline),
            const SizedBox(height: 8),
            _buildInfoRow('Email', 'roshdology123@example.com', Icons.email_outlined),
            const SizedBox(height: 8),
            _buildInfoRow('Member Since', '1 year ago', Icons.calendar_today_outlined),
            const SizedBox(height: 8),
            _buildInfoRow('Total Orders', '24', Icons.shopping_bag_outlined),
            const SizedBox(height: 8),
            _buildInfoRow('Account Type', 'Gold Member', Icons.star_outline),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeletionInfo() {
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
                  Icons.delete_forever_outlined,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Text(
                  'What Will Be Deleted',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            ..._buildDeletionList(theme),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDeletionList(ThemeData theme) {
    final items = [
      'Profile information and personal data',
      'Order history and transaction records',
      'Reviews and ratings you\'ve given',
      'Wishlist and favorite items',
      'Account preferences and settings',
      'Loyalty points and membership benefits',
      'Communication history and support tickets',
    ];

    return items.map((item) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.close,
            size: 16,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    )).toList();
  }

  Widget _buildDataRetentionInfo() {
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
                  Icons.info_outline,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Data Retention Policy',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Legal Requirements:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Financial records may be retained for 7 years as required by law\n'
                        '• Some anonymized analytics data may be retained for business purposes\n'
                        '• Legal documents and communications may be retained as required',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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

  Widget _buildDeletionReason() {
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
                  Icons.feedback_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Reason for Deletion (Optional)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedReason,
              decoration: const InputDecoration(
                labelText: 'Primary reason',
                hintText: 'Select a reason',
              ),
              items: _deletionReasons.map((reason) {
                return DropdownMenuItem(
                  value: reason,
                  child: Text(reason),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedReason = value;
                });
              },
            ),

            if (_selectedReason == 'Other') ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Please specify',
                  hintText: 'Tell us more about your reason',
                ),
                maxLines: 3,
                maxLength: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordConfirmation() {
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
                  Icons.lock_outline,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Password Confirmation',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                labelText: 'Enter your password',
                hintText: 'Confirm your identity',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required to delete your account';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalConfirmation() {
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
                  'Final Confirmation',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              'Type "DELETE MY ACCOUNT" to confirm permanent deletion:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: _confirmationController,
              decoration: const InputDecoration(
                labelText: 'Confirmation Text',
                hintText: 'Type: DELETE MY ACCOUNT',
              ),
              validator: (value) {
                if (value != 'DELETE MY ACCOUNT') {
                  return 'Please type "DELETE MY ACCOUNT" exactly as shown';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {}); // Trigger rebuild to update button state
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnderstandingCheckbox() {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _understandsConsequences,
          onChanged: (value) {
            setState(() {
              _understandsConsequences = value ?? false;
            });
          },
          title: Text(
            'I understand that this action is permanent and irreversible',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            'Once deleted, your account and all data cannot be recovered.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: theme.colorScheme.error,
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    final theme = Theme.of(context);
    final canDelete = _confirmationController.text == 'DELETE MY ACCOUNT' &&
        _understandsConsequences &&
        _passwordController.text.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (!canDelete || _isLoading) ? null : _deleteAccount,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.error,
          foregroundColor: theme.colorScheme.onError,
        ),
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
                  theme.colorScheme.onError,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Deleting Account...'),
          ],
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_forever),
            SizedBox(width: 8),
            Text('DELETE MY ACCOUNT'),
          ],
        ),
      ),
    );
  }

  Widget _buildAlternativeActions() {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Consider These Alternatives:',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.settings_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Update Privacy Settings'),
              subtitle: const Text('Control your data sharing preferences'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/profile/settings/privacy'),
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.notifications_off_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Disable Notifications'),
              subtitle: const Text('Turn off all notifications instead'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/profile/settings/notifications'),
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.support_agent_outlined,
                color: theme.colorScheme.primary,
              ),
              title: const Text('Contact Support'),
              subtitle: const Text('Let us help resolve any issues'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/support'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteAccount() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<ProfileCubit>().deleteAccount(
      confirmationText: _confirmationController.text,
      currentPassword: _passwordController.text,
      reason: _selectedReason == 'Other' ? _reasonController.text : _selectedReason,
    );
  }

  void _showDeletionSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Account Deleted'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green,
            ),
            SizedBox(height: 16),
            Text(
              'Your account has been permanently deleted. Thank you for using our service.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/auth/login');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}