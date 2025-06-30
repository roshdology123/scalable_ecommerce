import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';

class BiometricLoginWidget extends StatelessWidget {
  const BiometricLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.fingerprint,
              size: 64,
              color: context.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'auth.biometric_login'.tr(),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'auth.biometric_login_description'.tr(),
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _handleBiometricLogin(context),
              icon: const Icon(Icons.fingerprint),
              label: Text('auth.use_biometric'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBiometricLogin(BuildContext context) {
    // Mock biometric authentication
    context.showSnackBar('auth.biometric_coming_soon'.tr());

    // In real implementation:
    // final LocalAuthentication localAuth = LocalAuthentication();
    // try {
    //   final bool isAvailable = await localAuth.isDeviceSupported();
    //   if (!isAvailable) {
    //     context.showErrorSnackBar('auth.biometric_not_available'.tr());
    //     return;
    //   }
    //
    //   final bool isAuthenticated = await localAuth.authenticate(
    //     localizedReason: 'auth.biometric_reason'.tr(),
    //     options: const AuthenticationOptions(
    //       biometricOnly: true,
    //       stickyAuth: true,
    //     ),
    //   );
    //
    //   if (isAuthenticated) {
    //     context.read<AuthCubit>().loginWithBiometrics();
    //   }
    // } catch (e) {
    //   context.showErrorSnackBar('auth.biometric_error'.tr());
    // }
  }
}