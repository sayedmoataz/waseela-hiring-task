import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../domain/entities/order_entity.dart';

class OrderStatusIcon extends StatelessWidget {
  final OrderStatus? status;

  const OrderStatusIcon({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    if (status == null) return const SizedBox.shrink();

    final isApproved = status == OrderStatus.approved;
    final bgColor = isApproved ? AppColors.success : AppColors.warning;
    final iconData = isApproved
        ? Icons.check_rounded
        : Icons.access_time_filled_rounded;
    final semanticLabel = isApproved
        ? 'Order approved successfully'
        : 'Order is pending approval';

    return Semantics(
      label: semanticLabel,
      image: false,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          iconData,
          color: AppColors.white,
          size: AppConstants.iconSizeXL,
          semanticLabel: semanticLabel,
        ),
      ),
    );
  }
}
