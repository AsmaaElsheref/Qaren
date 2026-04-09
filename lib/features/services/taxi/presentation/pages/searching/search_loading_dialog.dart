import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../providers/comparePricesProvider/compare_prices_provider.dart';
import '../../providers/comparePricesProvider/compare_prices_state.dart';
import '../../providers/searchProvider/search_loading_provider.dart';
import '../../providers/searchProvider/search_loading_state.dart';
import '../../widgets/searching/search_loading.dart';
import '../comparePrices/compare_prices.dart';

class SearchLoadingDialog extends ConsumerStatefulWidget {
  const SearchLoadingDialog({super.key});

  static Future<T?> show<T>(BuildContext context) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black45,
      builder: (_) => const SearchLoadingDialog(),
    );
  }

  @override
  ConsumerState<SearchLoadingDialog> createState() => _SearchLoadingDialogState();
}

class _SearchLoadingDialogState extends ConsumerState<SearchLoadingDialog> with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _spinController;
  late final Animation<double> _spinAnimation;
  ProviderSubscription<SearchLoadingState>? _providerSubscription;
  ProviderSubscription<ComparePricesState>? _apiSubscription;
  bool _dialogClosed = false;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _spinAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_spinController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchLoadingProvider.notifier).startAutoCycle();
    });

    // Listen to page step changes for the loading animation
    _providerSubscription = ref.listenManual<SearchLoadingState>(
      searchLoadingProvider,
          (previous, next) {
        if (!_pageController.hasClients) return;
        if (previous?.currentPage == next.currentPage) return;

        _pageController.animateToPage(
          next.currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
    );

    // Listen for API completion (success, empty, or failure)
    _apiSubscription = ref.listenManual<ComparePricesState>(
      comparePricesProvider,
          (previous, next) {
        final isDone = next.status == ComparePricesStatus.success ||
            next.status == ComparePricesStatus.empty ||
            next.status == ComparePricesStatus.failure;

        if (!isDone) return;
        if (_dialogClosed) return;
        if (!mounted) return;

        _dialogClosed = true;

        // Complete the loading animation
        ref.read(searchLoadingProvider.notifier).complete();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Navigator.of(context, rootNavigator: true).pop(true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ComparePricesPage()),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    _providerSubscription?.close();
    _apiSubscription?.close();
    _pageController.dispose();
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchLoadingProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: const Border(
              top: BorderSide(
                color: AppColors.primary,
                width: 7,
              ),
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
            vertical: AppDimensions.paddingXL,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SearchLoading(animation: _spinAnimation),
              const SizedBox(height: AppDimensions.paddingL),
              SizedBox(
                height: context.screenHeight * 0.1,
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.steps.length,
                  itemBuilder: (_, index) {
                    return Center(
                      child: Text(
                        state.steps[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(state.steps.length, (index) {
                  final isActive = index == state.currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}