import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google Login Button
        OutlinedButton.icon(
          onPressed: () => _handleSocialLogin(context, 'google'),
          icon: const Icon(Icons.g_mobiledata),
          label: Text('auth.continue_with_google'.tr()),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        const SizedBox(height: 12),

        // Facebook Login Button
        OutlinedButton.icon(
          onPressed: () => _handleSocialLogin(context, 'facebook'),
          icon: const Icon(Icons.facebook),
          label: Text('auth.continue_with_facebook'.tr()),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        const SizedBox(height: 12),

        // Apple Login Button (iOS only)
        if (Theme.of(context).platform == TargetPlatform.iOS)
          OutlinedButton.icon(
            onPressed: () => _handleSocialLogin(context, 'apple'),
            icon: const Icon(Icons.apple, size: 20),
            label: Text('auth.continue_with_apple'.tr()),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
      ],
    );
  }

  void _handleSocialLogin(BuildContext context, String provider) {
    // Mock social login implementation
    context.showSnackBar(
      'auth.social_login_coming_soon'.tr().replaceAll('{provider}', provider),
    );

    // In real implementation, you would:
    // 1. Initialize the social login SDK
    // 2. Handle the authentication flow
    // 3. Get the token from the provider
    // 4. Call the repository method
    //
    // Example for Google:
    // final GoogleSignIn googleSignIn = GoogleSignIn();
    // final GoogleSignInAccount? account = await googleSignIn.signIn();
    // if (account != null) {
    //   final GoogleSignInAuthentication auth = await account.authentication;
    //   context.read<AuthCubit>().socialLogin(
    //     provider: 'google',
    //     token: auth.idToken!,
    //   );
    // }
  }
}