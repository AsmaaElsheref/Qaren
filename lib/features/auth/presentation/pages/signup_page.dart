import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/gap.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../providers/signup_providers.dart';
import '../providers/signup_state.dart';
import '../widgets/gradient_login_button.dart';
import '../widgets/login_input_field.dart';
import '../widgets/qaren_logo.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignupPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(signupNotifierProvider.notifier).register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            passwordConfirmation: _confirmPasswordController.text,
            phone: _phoneController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SignupState>(signupNotifierProvider, (previous, next) {
      if (next.status == SignupStatus.success &&
          previous?.status != SignupStatus.success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
      if (next.status == SignupStatus.failure &&
          previous?.status != SignupStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? AppStrings.signUpFailed),
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

    return Scaffold(
      backgroundColor: AppColors.background,
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
                    const Text(
                      AppStrings.signUpTitle,
                      style: TextStyle(
                        fontSize: AppDimensions.fontL,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.03),

                    // ── Name ──────────────────────────────────────────────────
                    LoginInputField(
                      controller: _nameController,
                      hint: AppStrings.nameHint,
                      prefixIcon: Icons.person_outline,
                      keyboardType: TextInputType.name,
                      validator: Validators.validateName,
                    ),
                    const SizedBox(height: AppDimensions.paddingS),

                    // ── Email ─────────────────────────────────────────────────
                    LoginInputField(
                      controller: _emailController,
                      hint: AppStrings.emailHint,
                      prefixIcon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: AppDimensions.paddingS),

                    // ── Phone ─────────────────────────────────────────────────
                    LoginInputField(
                      controller: _phoneController,
                      hint: AppStrings.phoneHint,
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: Validators.validatePhone,
                    ),
                    const SizedBox(height: AppDimensions.paddingS),

                    // ── Gender ────────────────────────────────────────────────
                    _GenderSelector(
                      selected: signupState.selectedGender,
                      onChanged: notifier.selectGender,
                    ),
                    const SizedBox(height: AppDimensions.paddingS),

                    // ── Password ──────────────────────────────────────────────
                    LoginInputField(
                      controller: _passwordController,
                      hint: AppStrings.passwordHint,
                      prefixIcon: Icons.lock_outline,
                      obscureText: !signupState.isPasswordVisible,
                      validator: Validators.validatePassword,
                      customSuffix: const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.lock_outline,
                          color: AppColors.textSecondary,
                          size: AppDimensions.iconS,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: notifier.togglePasswordVisibility,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
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
                      hint: AppStrings.confirmPasswordHint,
                      prefixIcon: Icons.lock_outline,
                      obscureText: !signupState.isConfirmPasswordVisible,
                      validator: (value) => Validators.confirmPasswordValidator(
                        _passwordController.text,
                        value
                      ),
                      customSuffix: const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.lock_outline,
                          color: AppColors.textSecondary,
                          size: AppDimensions.iconS,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: notifier.toggleConfirmPasswordVisibility,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
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
                      label: AppStrings.signUpButton,
                      isLoading: signupState.status == SignupStatus.loading,
                      onPressed: _onSignupPressed,
                    ),

                    Gap.gapH20,

                    // ── Already have account ──────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          AppStrings.alreadyHaveAccount,
                          style: TextStyle(
                            fontSize: AppDimensions.fontS,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            AppStrings.loginNow,
                            style: TextStyle(
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

// ── Gender Selector Widget ─────────────────────────────────────────────────────
class _GenderSelector extends StatelessWidget {
  final String selected;
  final void Function(String) onChanged;

  const _GenderSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GenderOption(
            label: AppStrings.genderMale,
            value: 'male',
            icon: Icons.male_rounded,
            isSelected: selected == 'male',
            onTap: () => onChanged('male'),
          ),
        ),
        const SizedBox(width: AppDimensions.paddingS),
        Expanded(
          child: _GenderOption(
            label: AppStrings.genderFemale,
            value: 'female',
            icon: Icons.female_rounded,
            isSelected: selected == 'female',
            onTap: () => onChanged('female'),
          ),
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.value,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: AppDimensions.inputHeight,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: AppDimensions.iconM,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: AppDimensions.fontM,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

