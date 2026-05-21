import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/verify_code_provider.dart';
import '../providers/verify_code_state.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/otp_code_field.dart';
import '../widgets/password_reset_header.dart';
import '../widgets/resend_code_button.dart';
import 'reset_password_page.dart';

class VerifyCodePage extends ConsumerStatefulWidget {
  final String login;

  const VerifyCodePage({super.key, required this.login});

  @override
  ConsumerState<VerifyCodePage> createState() => VerifyCodePageState();
}

class VerifyCodePageState extends ConsumerState<VerifyCodePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(verifyCodeNotifierProvider.notifier).verify(
            widget.login,
            _codeController.text,
          );
    }
  }

  void _onResend() {
    ref.read(verifyCodeNotifierProvider.notifier).resend(widget.login);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<VerifyCodeState>(verifyCodeNotifierProvider, (_, next) {
      if (next.status == VerifyCodeStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? AppStrings.verifyCodeFailed),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
        );
      } else if (next.status == VerifyCodeStatus.resendSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppStrings.verifyCodeResendSuccess),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
        );
      } else if (next.status == VerifyCodeStatus.success) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ResetPasswordPage(
              login: widget.login,
              code: _codeController.text.trim(),
            ),
          ),
        );
      }
    });

    final status = ref.watch(
      verifyCodeNotifierProvider.select((s) => s.status),
    );

    final isLoading = status == VerifyCodeStatus.loading;
    final isResending = status == VerifyCodeStatus.resending;
    final colors = context.appColors;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colors.textPrimary,
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: AppDimensions.paddingXL),
                  PasswordResetHeader(
                    icon: Icons.mark_email_read_outlined,
                    title: AppStrings.verifyCodeTitle,
                    subtitle: '${AppStrings.verifyCodeSubtitle} ${widget.login}',
                  ),
                  const SizedBox(height: AppDimensions.paddingXXL),
                  OtpCodeField(
                    controller: _codeController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.verifyCodeRequired;
                      }
                      if (int.tryParse(value.trim()) == null) {
                        return AppStrings.verifyCodeInvalid;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.paddingXL),
                  AuthSubmitButton(
                    label: AppStrings.verifyCodeButton,
                    isLoading: isLoading,
                    onPressed: _onSubmit,
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  ResendCodeButton(
                    isLoading: isResending,
                    onPressed: _onResend,
                  ),
                  const SizedBox(height: AppDimensions.paddingXXL),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

