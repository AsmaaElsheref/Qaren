import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/gap.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/validators.dart';
import '../providers/login_providers.dart';
import '../providers/login_state.dart';
import '../widgets/qaren_logo.dart';
import '../widgets/login_input_field.dart';
import '../widgets/gradient_login_button.dart';
import '../widgets/biometrics_button.dart';
import '../../../home/presentation/pages/home_page.dart';
import 'signup_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _biometricAutoPrompted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Ask user if they want to enable biometric login after first success.
  Future<bool> _showEnableBiometricDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        title: const Text(
          'تفعيل الدخول بالبصمة',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: const Text(
          'هل تريد تفعيل الدخول بالبصمة في المرات القادمة؟\n'
          'بياناتك ستُحفظ بشكل مشفّر وآمن.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              'لاحقاً',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'تفعيل',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(loginNotifierProvider.notifier).login(
            login: _emailController.text.trim(),
            password: _passwordController.text,
            askEnableBiometrics: _showEnableBiometricDialog,
          );
    }
  }

  void _onBiometricPressed() {
    ref.read(loginNotifierProvider.notifier).loginWithBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    // ── Listen for login success / failure ──────────────────────
    ref.listen<LoginState>(loginNotifierProvider, (previous, next) {
      if (next.status == LoginStatus.success &&
          previous?.status != LoginStatus.success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
      if (next.status == LoginStatus.failure &&
          previous?.status != LoginStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? AppStrings.loginFailed),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
        );
      }

      // ── Auto-prompt biometrics once when page loads ──────────
      if (next.showBiometricPrompt && !_biometricAutoPrompted) {
        _biometricAutoPrompted = true;
        Future.microtask(() {
          if (mounted) {
            ref.read(loginNotifierProvider.notifier).loginWithBiometrics();
          }
        });
      }
    });

    final loginState = ref.watch(loginNotifierProvider);
    final notifier = ref.read(loginNotifierProvider.notifier);

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
                    const SizedBox(height: AppDimensions.paddingXXL),
                    const QarenLogo(),
                    const SizedBox(height: AppDimensions.paddingXL),
                    SizedBox(height: context.screenHeight * 0.05),
                    LoginInputField(
                      controller: _emailController,
                      hint: AppStrings.emailHint,
                      prefixIcon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: AppDimensions.paddingS),
                    LoginInputField(
                      controller: _passwordController,
                      hint: AppStrings.passwordHint,
                      prefixIcon: Icons.lock_outline,
                      obscureText: !loginState.isPasswordVisible,
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
                            loginState.isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                            size: AppDimensions.iconS,
                          ),
                        ),
                      ),
                    ),
                    Gap.gapH10,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          AppStrings.forgotPassword,
                          style: TextStyle(
                            fontSize: AppDimensions.fontS,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.06),
                    GradientLoginButton(
                      label: AppStrings.loginButton,
                      isLoading: loginState.status == LoginStatus.loading,
                      onPressed: _onLoginPressed,
                    ),

                    const SizedBox(height: AppDimensions.paddingXXL),

                    // ── Biometric button ─────────────────────────────────
                    // Always shown — if biometrics not configured yet,
                    // tapping it shows a friendly "سجّل أولاً" message.
                    BiometricsButton(onPressed: _onBiometricPressed),

                    const SizedBox(height: AppDimensions.paddingL),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        AppStrings.browseAsGuest,
                        style: TextStyle(
                          fontSize: AppDimensions.fontS,
                          color: AppColors.textSecondary,
                          decorationColor: AppColors.textSecondary,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.paddingS),

                    // ── Sign Up link ──────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          AppStrings.dontHaveAccount,
                          style: TextStyle(
                            fontSize: AppDimensions.fontS,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const SignupPage()),
                          ),
                          style: TextButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            AppStrings.signUpNow,
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

