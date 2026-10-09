import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/gap.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/AppText.dart';
import '../../../../core/utils/validators.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../providers/signup_providers.dart';
import '../providers/signup_state.dart';
import '../widgets/gradient_login_button.dart';
import '../widgets/login_input_field.dart';
import '../widgets/qaren_logo.dart';
import '../widgets/signup_avatar_picker.dart';
import 'login_page.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignupPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      ref
          .read(signupNotifierProvider.notifier)
          .register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            passwordConfirmation: _confirmPasswordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SignupState>(signupNotifierProvider, (previous, next) {
      if (next.status == SignupStatus.success &&
          previous?.status != SignupStatus.success) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePage()),
          (_) => false,
        );
      }
      if (next.status == SignupStatus.failure &&
          previous?.status != SignupStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText(next.errorMessage ?? 'auth.signup.failed'.tr()),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
        );
      }
    });

    final signupState = ref.watch(signupNotifierProvider);
    final notifier = ref.read(signupNotifierProvider.notifier);
    final colors = context.appColors;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: AppDimensions.paddingXL),
                    const QarenLogo(),
                    const SizedBox(height: AppDimensions.paddingM),
                    AppText(
                      'auth.signup.title'.tr(),
                      style: TextStyle(
                        fontSize: AppDimensions.fontL,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.025),

                    // ── Avatar picker ─────────────────────────────────────────
                    SignupAvatarPicker(
                      imagePath: signupState.imagePath,
                      onImagePicked: notifier.setImage,
                      onImageRemoved: () => notifier.setImage(null),
                    ),
                    SizedBox(height: context.screenHeight * 0.025),

                    // ── Name ──────────────────────────────────────────────────
                    LoginInputField(
                      controller: _nameController,
                      hint: 'auth.signup.nameHint'.tr(),
                      prefixIcon: Icons.person_outline,
                      keyboardType: TextInputType.name,
                      validator: Validators.validateName,
                    ),
                    const SizedBox(height: AppDimensions.paddingS),

                    // ── Email ─────────────────────────────────────────────────
                    LoginInputField(
                      controller: _emailController,
                      hint: 'auth.login.emailHint'.tr(),
                      prefixIcon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: AppDimensions.paddingS),

                    // ── Phone ─────────────────────────────────────────────────
                    const SizedBox(height: AppDimensions.paddingS),

                    // ── Gender ────────────────────────────────────────────────

                    // ── Password ──────────────────────────────────────────────
                    LoginInputField(
                      controller: _passwordController,
                      hint: 'auth.login.passwordHint'.tr(),
                      prefixIcon: Icons.lock_outline,
                      obscureText: !signupState.isPasswordVisible,
                      validator: Validators.validatePassword,
                      customSuffix: const Padding(
                        padding: EdgeInsetsDirectional.only(start: 16),
                        child: Icon(
                          Icons.lock_outline,
                          color: AppColors.textSecondary,
                          size: AppDimensions.iconS,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: notifier.togglePasswordVisibility,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(end: 4),
                          child: Icon(
                            signupState.isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                            size: AppDimensions.iconS,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingS),

                    // ── Confirm Password ──────────────────────────────────────
                    LoginInputField(
                      controller: _confirmPasswordController,
                      hint: 'auth.signup.confirmPasswordHint'.tr(),
                      prefixIcon: Icons.lock_outline,
                      obscureText: !signupState.isConfirmPasswordVisible,
                      validator: (value) => Validators.confirmPasswordValidator(
                        _passwordController.text,
                        value,
                      ),
                      customSuffix: const Padding(
                        padding: EdgeInsetsDirectional.only(start: 16),
                        child: Icon(
                          Icons.lock_outline,
                          color: AppColors.textSecondary,
                          size: AppDimensions.iconS,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: notifier.toggleConfirmPasswordVisibility,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(end: 4),
                          child: Icon(
                            signupState.isConfirmPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                            size: AppDimensions.iconS,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: context.screenHeight * 0.04),

                    // ── Submit ────────────────────────────────────────────────
                    GradientLoginButton(
                      label: 'auth.signup.button'.tr(),
                      isLoading: signupState.status == SignupStatus.loading,
                      onPressed: _onSignupPressed,
                    ),

                    Gap.gapH20,

                    // ── Already have account ──────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          'auth.signup.hasAccount'.tr(),
                          style: const TextStyle(
                            fontSize: AppDimensions.fontS,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const LoginPage(),
                                ),
                              ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: AppText(
                            'auth.signup.loginLink'.tr(),
                            style: const TextStyle(
                              fontSize: AppDimensions.fontS,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDimensions.paddingL),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Gender Selector ────────────────────────────────────────────────────────────
