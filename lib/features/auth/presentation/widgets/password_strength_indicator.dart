import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    final strength = _calculatePasswordStrength(password);
    final strengthText = _getStrengthText(strength);
    final strengthColor = _getStrengthColor(context, strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              'auth.password_strength'.tr(),
              style: context.textTheme.bodySmall,
            ),
            const SizedBox(width: 8),
            Text(
              strengthText,
              style: context.textTheme.bodySmall?.copyWith(
                color: strengthColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: strength / 4.0,
          backgroundColor: context.colorScheme.surfaceVariant,
          valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
        ),
        const SizedBox(height: 8),
        ..._getPasswordRequirements(password),
      ],
    );
  }

  int _calculatePasswordStrength(String password) {
    int strength = 0;

    if (password.length >= 8) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;

    return strength.clamp(0, 4);
  }

  String _getStrengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'auth.password_weak'.tr();
      case 2:
        return 'auth.password_fair'.tr();
      case 3:
        return 'auth.password_good'.tr();
      case 4:
        return 'auth.password_strong'.tr();
      default:
        return 'auth.password_weak'.tr();
    }
  }

  Color _getStrengthColor(BuildContext context, int strength) {
    switch (strength) {
      case 0:
      case 1:
        return context.colorScheme.error;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.green;
      default:
        return context.colorScheme.error;
    }
  }

  List<Widget> _getPasswordRequirements(String password) {
    final requirements = [
      _RequirementItem(
        text: 'auth.password_req_length'.tr(),
        isMet: password.length >= 8,
      ),
      _RequirementItem(
        text: 'auth.password_req_lowercase'.tr(),
        isMet: RegExp(r'[a-z]').hasMatch(password),
      ),
      _RequirementItem(
        text: 'auth.password_req_uppercase'.tr(),
        isMet: RegExp(r'[A-Z]').hasMatch(password),
      ),
      _RequirementItem(
        text: 'auth.password_req_number'.tr(),
        isMet: RegExp(r'[0-9]').hasMatch(password),
      ),
      _RequirementItem(
        text: 'auth.password_req_special'.tr(),
        isMet: RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password),
      ),
    ];

    return requirements;
  }
}

class _RequirementItem extends StatelessWidget {
  final String text;
  final bool isMet;

  const _RequirementItem({
    required this.text,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isMet
                ? Colors.green
                : context.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: context.textTheme.bodySmall?.copyWith(
              color: isMet
                  ? Colors.green
                  : context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}