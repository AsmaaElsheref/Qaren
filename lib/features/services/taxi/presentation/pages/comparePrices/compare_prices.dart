import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../widgets/comparePrices/compare_prices_app_bar.dart';
import '../../widgets/comparePrices/content_list.dart';

class ComparePricesPage extends ConsumerWidget {
  const ComparePricesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: PreferredSize(preferredSize: Size.fromHeight(70), child: const ComparePricesAppBar()),
          body: ContentList(),
        ),
      ),
    );
  }
}