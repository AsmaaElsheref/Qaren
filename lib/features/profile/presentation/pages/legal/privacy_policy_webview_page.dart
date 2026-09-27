import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/constants/legal_links.dart';
import 'package:qaren/core/localization/easy_localization.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyWebViewPage extends StatefulWidget {
  const PrivacyPolicyWebViewPage({super.key});

  @override
  State<PrivacyPolicyWebViewPage> createState() =>
      _PrivacyPolicyWebViewPageState();
}

class _PrivacyPolicyWebViewPageState extends State<PrivacyPolicyWebViewPage> {
  late final WebViewController _controller;
  int _progress = 0;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (!mounted) return;
            setState(() => _progress = progress);
          },
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _progress = 0;
              _hasError = false;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _progress = 100);
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame != true || !mounted) return;
            setState(() => _hasError = true);
          },
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);
            final isAllowed =
                uri != null &&
                uri.scheme == 'https' &&
                uri.host == Uri.parse(LegalLinks.privacyPolicy).host;
            return isAllowed
                ? NavigationDecision.navigate
                : NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(LegalLinks.privacyPolicy));
  }

  Future<void> _retry() async {
    setState(() {
      _progress = 0;
      _hasError = false;
    });
    await _controller.loadRequest(Uri.parse(LegalLinks.privacyPolicy));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colors.textPrimary,
          ),
        ),
        title: AppText(
          'legal.privacyPolicy'.tr(),
          style: AppTextStyles.title.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        bottom: _progress < 100 && !_hasError
            ? PreferredSize(
                preferredSize: const Size.fromHeight(3),
                child: LinearProgressIndicator(
                  value: _progress > 0 ? _progress / 100 : null,
                  minHeight: 3,
                  color: AppColors.primaryDark,
                  backgroundColor: colors.disabledBackground,
                ),
              )
            : null,
      ),
      body: _hasError
          ? _PrivacyLoadError(onRetry: _retry)
          : ColoredBox(
              color: colors.surface,
              child: WebViewWidget(controller: _controller),
            ),
    );
  }
}

class _PrivacyLoadError extends StatelessWidget {
  const _PrivacyLoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 56,
              color: colors.textSecondary,
            ),
            const SizedBox(height: AppDimensions.paddingM),
            AppText(
              'legal.privacy.loadErrorTitle'.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingS),
            AppText(
              'legal.privacy.loadErrorBody'.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: AppText('common.retry'.tr()),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
