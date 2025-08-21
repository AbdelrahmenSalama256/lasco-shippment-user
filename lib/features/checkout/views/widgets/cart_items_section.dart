import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/features/cart/views/widgets/package_cart_card.dart';

class CartItemsSection extends StatelessWidget {
  const CartItemsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: Column(
        children: [
          PackageCartCard(
            orderId: "#12345",
            fromLocation: "Times Square",
            toLocation: "Manhattan",
            days: 3,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
