import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/extensions.dart';
import '../cubit/auth_cubit.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google Login Button
        OutlinedButton.icon(
          onPressed: () => context.read<AuthCubit>().signInWithGoogle(),
          icon: const Icon(Icons.g_mobiledata),
          label: Text('auth.continue_with_google'.tr()),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        const SizedBox(height: 12),

        // Facebook Login Button
        OutlinedButton.icon(
          onPressed: () => context.showSnackBar(
            'auth.social_login_coming_soon'.tr().replaceAll('{provider}', 'facebook'),
          ),
          icon: const Icon(Icons.facebook),
          label: Text('auth.continue_with_facebook'.tr()),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        const SizedBox(height: 12),

        // Apple Login Button (iOS only)
        // if (Theme.of(context).platform == TargetPlatform.iOS)
        //   OutlinedButton.icon(
        //     onPressed: () => _handleSocialLogin(context, 'apple'),
        //     icon: const Icon(Icons.apple, size: 20),
        //     label: Text('auth.continue_with_apple'.tr()),
        //     style: OutlinedButton.styleFrom(
        //       minimumSize: const Size(double.infinity, 48),
        //     ),
        //   ),
      ],
    );
  }

  
}