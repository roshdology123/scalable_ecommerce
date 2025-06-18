import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/extensions.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_login_buttons.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final rememberMe = useState(false);
    final obscurePassword = useState(true);

    return Scaffold(
      appBar: AppBar(
        title: Text('auth.login'.tr()),
        centerTitle: true,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            authenticated: (_) {
              context.go('/home');
            },
            error: (message, code) {
              context.showErrorSnackBar(message);
            },
            forgotPasswordSent: () {
              context.showSuccessSnackBar('auth.forgot_password_sent'.tr());
            },
          );
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),

                  // Logo/Icon
                  Icon(
                    Icons.shopping_bag,
                    size: 80,
                    color: context.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),

                  // Welcome text
                  Text(
                    'auth.welcome_back'.tr(),
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'auth.login_subtitle'.tr(),
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Email/Username field
                  AuthTextField(
                    controller: emailController,
                    labelText: 'auth.email_or_username'.tr(),
                    hintText: 'auth.email_or_username_hint'.tr(),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'auth.email_or_username_required'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  AuthTextField(
                    controller: passwordController,
                    labelText: 'auth.password'.tr(),
                    hintText: 'auth.password_hint'.tr(),
                    obscureText: obscurePassword.value,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        obscurePassword.value = !obscurePassword.value;
                      },
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'auth.password_required'.tr();
                      }
                      if (value!.length < 6) {
                        return 'auth.password_too_short'.tr();
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _handleLogin(
                      context,
                      formKey,
                      emailController.text,
                      passwordController.text,
                      rememberMe.value,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Remember me and forgot password row
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe.value,
                        onChanged: (value) {
                          rememberMe.value = value ?? false;
                        },
                      ),
                      Text('auth.remember_me'.tr()),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _showForgotPasswordDialog(context),
                        child: Text('auth.forgot_password'.tr()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Login button
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading = state.maybeWhen(
                        loading: () => true,
                        orElse: () => false,
                      );

                      return ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => _handleLogin(
                          context,
                          formKey,
                          emailController.text,
                          passwordController.text,
                          rememberMe.value,
                        ),
                        child: isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : Text('auth.login'.tr()),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'common.or'.tr(),
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Social login buttons
                  const SocialLoginButtons(),
                  const SizedBox(height: 32),

                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('auth.dont_have_account'.tr()),
                      TextButton(
                        onPressed: () => context.go('/auth/signup'),
                        child: Text('auth.signup'.tr()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin(
      BuildContext context,
      GlobalKey<FormState> formKey,
      String emailOrUsername,
      String password,
      bool rememberMe,
      ) {
    if (formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
        emailOrUsername: emailOrUsername,
        password: password,
        rememberMe: rememberMe,
      );
    }
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('auth.forgot_password'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('auth.forgot_password_description'.tr()),
            const SizedBox(height: 16),
            AuthTextField(
              controller: emailController,
              labelText: 'auth.email'.tr(),
              hintText: 'auth.email_hint'.tr(),
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'auth.email_required'.tr();
                }
                if (!value!.isValidEmail) {
                  return 'auth.invalid_email'.tr();
                }
                return null;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('common.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              if (emailController.text.isValidEmail) {
                context.read<AuthCubit>().forgotPassword(emailController.text);
                Navigator.of(context).pop();
              }
            },
            child: Text('common.send'.tr()),
          ),
        ],
      ),
    );
  }
}