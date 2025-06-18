import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/extensions.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_login_buttons.dart';

class SignupPage extends HookWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final obscurePassword = useState(true);
    final obscureConfirmPassword = useState(true);
    final agreeToTerms = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: Text('auth.signup'.tr()),
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
                  const SizedBox(height: 16),

                  // Logo/Icon
                  Icon(
                    Icons.person_add,
                    size: 64,
                    color: context.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    'auth.create_account'.tr(),
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'auth.signup_subtitle'.tr(),
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Name fields row
                  Row(
                    children: [
                      Expanded(
                        child: AuthTextField(
                          controller: firstNameController,
                          labelText: 'auth.first_name'.tr(),
                          hintText: 'auth.first_name_hint'.tr(),
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'auth.first_name_required'.tr();
                            }
                            if (value!.length < 2) {
                              return 'auth.first_name_too_short'.tr();
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AuthTextField(
                          controller: lastNameController,
                          labelText: 'auth.last_name'.tr(),
                          hintText: 'auth.last_name_hint'.tr(),
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'auth.last_name_required'.tr();
                            }
                            if (value!.length < 2) {
                              return 'auth.last_name_too_short'.tr();
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Username field
                  AuthTextField(
                    controller: usernameController,
                    labelText: 'auth.username'.tr(),
                    hintText: 'auth.username_hint'.tr(),
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.alternate_email,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'auth.username_required'.tr();
                      }
                      if (value!.length < 3) {
                        return 'auth.username_too_short'.tr();
                      }
                      if (value.length > 20) {
                        return 'auth.username_too_long'.tr();
                      }
                      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                        return 'auth.username_invalid_characters'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email field
                  AuthTextField(
                    controller: emailController,
                    labelText: 'auth.email'.tr(),
                    hintText: 'auth.email_hint'.tr(),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
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
                  const SizedBox(height: 16),

                  // Phone field (optional)
                  AuthTextField(
                    controller: phoneController,
                    labelText: 'auth.phone'.tr(),
                    hintText: 'auth.phone_hint'.tr(),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.phone_outlined,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!value.isValidPhone) {
                          return 'auth.invalid_phone'.tr();
                        }
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
                    textInputAction: TextInputAction.next,
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
                      if (!value!.isStrongPassword) {
                        return 'auth.password_weak'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm password field
                  AuthTextField(
                    controller: confirmPasswordController,
                    labelText: 'auth.confirm_password'.tr(),
                    hintText: 'auth.confirm_password_hint'.tr(),
                    obscureText: obscureConfirmPassword.value,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        obscureConfirmPassword.value = !obscureConfirmPassword.value;
                      },
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'auth.confirm_password_required'.tr();
                      }
                      if (value != passwordController.text) {
                        return 'auth.passwords_dont_match'.tr();
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _handleSignup(
                      context,
                      formKey,
                      firstNameController.text,
                      lastNameController.text,
                      usernameController.text,
                      emailController.text,
                      phoneController.text,
                      passwordController.text,
                      confirmPasswordController.text,
                      agreeToTerms.value,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Terms and conditions checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: agreeToTerms.value,
                        onChanged: (value) {
                          agreeToTerms.value = value ?? false;
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            agreeToTerms.value = !agreeToTerms.value;
                          },
                          child: RichText(
                            text: TextSpan(
                              style: context.textTheme.bodyMedium,
                              children: [
                                TextSpan(text: 'auth.agree_to'.tr()),
                                TextSpan(
                                  text: ' ${('auth.terms_of_service'.tr())}',
                                  style: TextStyle(
                                    color: context.colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(text: ' ${'common.and'.tr()} '),
                                TextSpan(
                                  text: 'auth.privacy_policy'.tr(),
                                  style: TextStyle(
                                    color: context.colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sign up button
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading = state.maybeWhen(
                        loading: () => true,
                        orElse: () => false,
                      );

                      return ElevatedButton(
                        onPressed: isLoading || !agreeToTerms.value
                            ? null
                            : () => _handleSignup(
                          context,
                          formKey,
                          firstNameController.text,
                          lastNameController.text,
                          usernameController.text,
                          emailController.text,
                          phoneController.text,
                          passwordController.text,
                          confirmPasswordController.text,
                          agreeToTerms.value,
                        ),
                        child: isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : Text('auth.signup'.tr()),
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

                  // Social signup buttons
                  const SocialLoginButtons(),
                  const SizedBox(height: 32),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('auth.already_have_account'.tr()),
                      TextButton(
                        onPressed: () => context.go('/auth/login'),
                        child: Text('auth.login'.tr()),
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

  void _handleSignup(
      BuildContext context,
      GlobalKey<FormState> formKey,
      String firstName,
      String lastName,
      String username,
      String email,
      String phone,
      String password,
      String confirmPassword,
      bool agreeToTerms,
      ) {
    if (!agreeToTerms) {
      context.showErrorSnackBar('auth.must_agree_to_terms'.tr());
      return;
    }

    if (formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
        email: email,
        username: username,
        password: password,
        confirmPassword: confirmPassword,
        firstName: firstName,
        lastName: lastName,
        phone: phone.isEmpty ? null : phone,
      );
    }
  }
}