import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qaren/core/localization/easy_localization.dart';

class SaudiRiyalSymbol extends StatelessWidget {
  const SaudiRiyalSymbol({super.key, this.size = 16, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? DefaultTextStyle.of(context).style.color;
    return SvgPicture.asset(
      'assets/icons/saudi_riyal_symbol.svg',
      height: size,
      width: size * 0.9,
      colorFilter: effectiveColor == null
          ? null
          : ColorFilter.mode(effectiveColor, BlendMode.srcIn),
    );
  }
}

class SaudiRiyalAmount extends StatelessWidget {
  const SaudiRiyalAmount({
    super.key,
    required this.amount,
    this.style,
    this.symbolSize,
    this.sign = '',
  });

  final String amount;
  final TextStyle? style;
  final double? symbolSize;
  final String sign;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = DefaultTextStyle.of(context).style.merge(style);
    final effectiveSymbolSize =
        symbolSize ?? (effectiveStyle.fontSize ?? 14) * 0.9;

    return Semantics(
      label: '$sign$amount ${context.tr('common.currencyFull')}',
      child: ExcludeSemantics(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('$sign$amount', style: effectiveStyle),
              const SizedBox(width: 4),
              SaudiRiyalSymbol(
                size: effectiveSymbolSize,
                color: effectiveStyle.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
