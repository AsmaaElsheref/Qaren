import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/ui/widgets/AppTextField.dart';
import '../../../../core/ui/widgets/icon_container.dart';
import '../providers/home_providers.dart';

class HomeSearchBar extends ConsumerStatefulWidget {
  const HomeSearchBar({super.key});

  @override
  ConsumerState<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends ConsumerState<HomeSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.textHint.withValues(alpha: 0.07),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: AppColors.textHint.withValues(alpha: 0.5),
            blurRadius: 5,
            spreadRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: AppTextField(
          controller: _controller,
          hint: AppStrings.searchHint,
          fillColor: AppColors.background,
          nonBorder: true,
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
              size: AppDimensions.iconM,
            ),
          ),
          // Filter button — RTL: this appears on the left (text end)
          suffixIcon: _FilterButton(),
          onChanged: (v) =>
              ref.read(searchQueryProvider.notifier).state = v,
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: IconContainer(
        onTap: () {},
        icon: const Icon(
          Icons.tune_rounded,
          color: AppColors.textSecondary,
          size: 18,
        ),
      )
    );
  }
}
