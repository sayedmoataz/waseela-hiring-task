import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../domain/entities/order_entity.dart';

class OrderStatusIcon extends StatelessWidget {
  final OrderStatus? status;

  const OrderStatusIcon({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    const Color iconColor = AppColors.white;
    IconData iconData;

    if (status == OrderStatus.approved) {
      bgColor = AppColors.success;
      iconData = Icons.check_rounded;
    } else {
      bgColor = AppColors.warning;
      iconData = Icons.access_time_filled_rounded;
    }

    return status == null
        ? const SizedBox.shrink()
        : Container(
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
              color: iconColor,
              size: AppConstants.iconSizeXL,
            ),
          );
  }
}
