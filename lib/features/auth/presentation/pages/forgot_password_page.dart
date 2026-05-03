import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/forgot_password_provider.dart';
import '../providers/forgot_password_state.dart';
import '../widgets/forgot_password_form.dart';
import '../widgets/forgot_password_header.dart';
import 'verify_code_page.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      ref
          .read(forgotPasswordNotifierProvider.notifier)
          .sendResetLink(_emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ForgotPasswordState>(forgotPasswordNotifierProvider, (_, next) {
      if (next.status == ForgotPasswordStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? AppStrings.forgotPasswordFailed),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
        );
      } else if (next.status == ForgotPasswordStatus.success &&
          next.login != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VerifyCodePage(login: next.login!),
          ),
        );
      }
    });

    final isLoading = ref.watch(
      forgotPasswordNotifierProvider
          .select((s) => s.status == ForgotPasswordStatus.loading),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
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
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.paddingXL),
                const ForgotPasswordHeader(),
                const SizedBox(height: AppDimensions.paddingXXL),
                ForgotPasswordForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  isLoading: isLoading,
                  onSubmit: _onSubmit,
                ),
                const SizedBox(height: AppDimensions.paddingXXL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

