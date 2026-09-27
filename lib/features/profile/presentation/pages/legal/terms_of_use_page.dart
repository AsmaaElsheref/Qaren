import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/localization/easy_localization.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';
import 'package:qaren/core/ui/widgets/custom_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../data/models/terms_of_use_content.dart';
import '../../providers/legal_provider.dart';
import 'privacy_policy_webview_page.dart';

class TermsOfUsePage extends ConsumerWidget {
  const TermsOfUsePage({super.key});

  static const _fallbackSections = <({String title, String body})>[
    (
      title: 'legal.terms.sections.acceptance.title',
      body: 'legal.terms.sections.acceptance.body',
    ),
    (
      title: 'legal.terms.sections.account.title',
      body: 'legal.terms.sections.account.body',
    ),
    (
      title: 'legal.terms.sections.service.title',
      body: 'legal.terms.sections.service.body',
    ),
    (
      title: 'legal.terms.sections.providers.title',
      body: 'legal.terms.sections.providers.body',
    ),
    (
      title: 'legal.terms.sections.prices.title',
      body: 'legal.terms.sections.prices.body',
    ),
    (
      title: 'legal.terms.sections.location.title',
      body: 'legal.terms.sections.location.body',
    ),
    (
      title: 'legal.terms.sections.prohibited.title',
      body: 'legal.terms.sections.prohibited.body',
    ),
    (
      title: 'legal.terms.sections.availability.title',
      body: 'legal.terms.sections.availability.body',
    ),
    (
      title: 'legal.terms.sections.termination.title',
      body: 'legal.terms.sections.termination.body',
    ),
    (
      title: 'legal.terms.sections.changes.title',
      body: 'legal.terms.sections.changes.body',
    ),
    (
      title: 'legal.terms.sections.contact.title',
      body: 'legal.terms.sections.contact.body',
    ),
  ];

  void _openPrivacyPolicy(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PrivacyPolicyWebViewPage()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale.languageCode == 'ar' ? 'ar' : 'en';
    final terms = ref.watch(termsOfUseProvider(locale));
    final title = terms.asData?.value.name.trim();
    final effectiveTitle = title?.isNotEmpty == true
        ? title!
        : 'legal.terms.title'.tr();
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          CustomAppBar(title: effectiveTitle, isBack: true),
          Expanded(
            child: terms.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              data: (content) =>
                  _TermsHtmlView(content: content, locale: locale),
              error: (_, __) => _FallbackTermsContent(
                sections: _fallbackSections,
                onRetry: () => ref.invalidate(termsOfUseProvider(locale)),
                onOpenPrivacy: () => _openPrivacyPolicy(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsHtmlView extends StatefulWidget {
  const _TermsHtmlView({required this.content, required this.locale});

  final TermsOfUseContent content;
  final String locale;

  @override
  State<_TermsHtmlView> createState() => _TermsHtmlViewState();
}

class _TermsHtmlViewState extends State<_TermsHtmlView> {
  late final WebViewController _controller;
  int _progress = 0;
  String? _lastDocument;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) setState(() => _progress = progress);
          },
          onNavigationRequest: (request) {
            final isLocalDocument =
                request.url == 'about:blank' ||
                request.url.startsWith('data:text/html');
            return isLocalDocument
                ? NavigationDecision.navigate
                : NavigationDecision.prevent;
          },
        ),
      );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadDocument();
  }

  @override
  void didUpdateWidget(covariant _TermsHtmlView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content.htmlContent != widget.content.htmlContent ||
        oldWidget.locale != widget.locale) {
      _loadDocument();
    }
  }

  void _loadDocument() {
    final document = _buildDocument(context, widget.content, widget.locale);
    if (_lastDocument == document) return;
    _lastDocument = document;
    _progress = 0;
    _controller.loadHtmlString(document);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_progress < 100)
          Align(
            alignment: Alignment.topCenter,
            child: LinearProgressIndicator(
              value: _progress > 0 ? _progress / 100 : null,
              minHeight: 3,
              color: AppColors.primaryDark,
              backgroundColor: context.appColors.disabledBackground,
            ),
          ),
      ],
    );
  }

  static String _buildDocument(
    BuildContext context,
    TermsOfUseContent content,
    String locale,
  ) {
    final colors = context.appColors;
    final direction = locale == 'ar' ? 'rtl' : 'ltr';
    return '''
<!doctype html>
<html lang="$locale" dir="$direction">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    * { box-sizing: border-box; }
    body {
      margin: 0;
      padding: 20px;
      background: ${_cssColor(colors.background)};
      color: ${_cssColor(colors.textPrimary)};
      font-family: Arial, Tahoma, sans-serif;
      font-size: 16px;
      line-height: 1.9;
      text-align: start;
      overflow-wrap: break-word;
    }
    h2, h3 {
      color: ${_cssColor(colors.textPrimary)};
      line-height: 1.5;
      margin: 20px 0 8px;
    }
    h2 { font-size: 23px; margin-top: 0; }
    h3 { font-size: 18px; }
    p { margin: 0 0 12px; color: ${_cssColor(colors.textSecondary)}; }
    br + br { display: none; }
  </style>
</head>
<body>
  ${content.htmlContent}
</body>
</html>
''';
  }

  static String _cssColor(Color color) {
    final value = color.toARGB32().toRadixString(16).padLeft(8, '0');
    return '#${value.substring(2)}';
  }
}

class _FallbackTermsContent extends StatelessWidget {
  const _FallbackTermsContent({
    required this.sections,
    required this.onRetry,
    required this.onOpenPrivacy,
  });

  final List<({String title, String body})> sections;
  final VoidCallback onRetry;
  final VoidCallback onOpenPrivacy;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.primaryDark),
              const SizedBox(width: AppDimensions.paddingS),
              Expanded(
                child: AppText(
                  'legal.terms.offlineNotice'.tr(),
                  style: AppTextStyles.body.copyWith(color: colors.textPrimary),
                ),
              ),
              IconButton(
                onPressed: onRetry,
                tooltip: 'common.retry'.tr(),
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.paddingM),
        _TermsSection(
          title: 'legal.terms.title'.tr(),
          body: 'legal.terms.introduction'.tr(),
        ),
        const SizedBox(height: AppDimensions.paddingM),
        for (final section in sections) ...[
          _TermsSection(title: section.title.tr(), body: section.body.tr()),
          const SizedBox(height: AppDimensions.paddingM),
        ],
        OutlinedButton.icon(
          onPressed: onOpenPrivacy,
          icon: const Icon(Icons.privacy_tip_outlined),
          label: AppText('legal.privacyPolicy'.tr()),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryDark,
            side: const BorderSide(color: AppColors.primaryDark),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _TermsSection extends StatelessWidget {
  const _TermsSection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            style: AppTextStyles.title.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          AppText(
            body,
            style: AppTextStyles.body.copyWith(
              color: colors.textSecondary,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
