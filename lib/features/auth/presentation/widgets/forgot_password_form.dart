import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/gradient_login_button.dart';
import '../widgets/login_input_field.dart';

class ForgotPasswordForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final bool isLoading;
  final VoidCallback onSubmit;

  const ForgotPasswordForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          LoginInputField(
            controller: emailController,
            hint: 'auth.login.emailHint'.tr(),
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          GradientLoginButton(
            label: 'auth.forgotPassword.button'.tr(),
            isLoading: isLoading,
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}
