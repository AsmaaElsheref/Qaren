import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/reset_password_provider.dart';
import '../providers/reset_password_state.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/password_reset_header.dart';
import '../widgets/password_text_field.dart';
import '../widgets/reset_password_success_view.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  final String login;
  final String code;

  const ResetPasswordPage({
    super.key,
    required this.login,
    required this.code,
  });

  @override
  ConsumerState<ResetPasswordPage> createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(resetPasswordNotifierProvider.notifier).resetPassword(
            login: widget.login,
            code: widget.code,
            password: _passwordController.text,
            passwordConfirmation: _confirmController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ResetPasswordState>(resetPasswordNotifierProvider, (_, next) {
      if (next.status == ResetPasswordStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? AppStrings.resetPasswordFailed),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
        );
      }
    });

    final isSuccess = ref.watch(
      resetPasswordNotifierProvider.select((s) => s.status == ResetPasswordStatus.success),
    );
    final isLoading = ref.watch(
      resetPasswordNotifierProvider.select((s) => s.status == ResetPasswordStatus.loading),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: isSuccess
            ? const SizedBox.shrink()
            : IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary,
                  size: AppDimensions.iconM,
                ),
              ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingL,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: isSuccess
                  ? ResetPasswordSuccessView(
                      key: const ValueKey('success'),
                      onBackToLogin: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                    )
                  : _ResetPasswordForm(
                      key: const ValueKey('form'),
                      formKey: _formKey,
                      passwordController: _passwordController,
                      confirmController: _confirmController,
                      isLoading: isLoading,
                      onSubmit: _onSubmit,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResetPasswordForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _ResetPasswordForm({
    super.key,
    required this.formKey,
    required this.passwordController,
    required this.confirmController,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(height: AppDimensions.paddingXL),
          const PasswordResetHeader(
            icon: Icons.lock_reset_rounded,
            title: AppStrings.resetPasswordTitle,
            subtitle: AppStrings.resetPasswordSubtitle,
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          PasswordTextField(
            controller: passwordController,
            hint: AppStrings.resetPasswordHint,
            validator: (value) {
              if (value == null || value.isEmpty) return AppStrings.passwordRequired;
              if (value.length < 6) return AppStrings.passwordTooShort;
              return null;
            },
          ),
          const SizedBox(height: AppDimensions.paddingM),
          PasswordTextField(
            controller: confirmController,
            hint: AppStrings.resetPasswordConfirmHint,
            validator: (value) {
              if (value == null || value.isEmpty) return AppStrings.passwordRequired;
              if (value != passwordController.text) return AppStrings.passwordMismatch;
              return null;
            },
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          AuthSubmitButton(
            label: AppStrings.resetPasswordButton,
            isLoading: isLoading,
            onPressed: onSubmit,
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
        ],
      ),
    );
  }
}

