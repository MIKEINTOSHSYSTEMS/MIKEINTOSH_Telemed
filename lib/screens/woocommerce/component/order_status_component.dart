import 'package:flutter/material.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class OrderStatusComponent extends StatelessWidget {
  final String status;
  const OrderStatusComponent({required this.status});
  Color getStatusColor() {
    switch (status) {
      case 'pending':
        return pendingStatusColor;
      case 'processing':
        return processingStatusColor;
      case 'on-hold':
        return onHoldStatusColor;
      case 'completed':
        return completedStatusColor;
      case 'cancelled':
        return cancelledStatusColor;
      case 'refunded':
        return refundedStatusColor;
      case 'failed':
        return failedStatusColor;
      case 'trash':
        return trashStatusColor;
      default:
        return primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: getStatusColor(), borderRadius: radius(defaultRadius)),
      child: Text(status.capitalizeFirstLetter(), style: secondaryTextStyle(color: Colors.white)),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}
