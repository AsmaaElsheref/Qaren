import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/taxi_notifier.dart';
import 'route_center_divider.dart';
import 'route_point_column.dart';

class RideRouteCard extends ConsumerWidget {
  const RideRouteCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickup = ref.watch(taxiProvider.select((s) => s.pickup));
    final destination = ref.watch(taxiProvider.select((s) => s.destination));
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE6E6E6),
        ),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'من',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              RouteCenterDivider(),
              Text(
                'إلى',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RoutePointColumn(
                  alignment: CrossAxisAlignment.start,
                  label: 'من',
                  mainText: pickup,
                  subText: '',
                ),
              ),
              Expanded(
                child: RoutePointColumn(
                  alignment: CrossAxisAlignment.end,
                  label: 'إلى',
                  mainText: destination,
                  subText: '',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}