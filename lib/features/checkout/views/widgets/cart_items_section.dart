import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/features/cart/views/widgets/product_cart_card.dart';

class CartItemsSection extends StatelessWidget {
  const CartItemsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: Column(
        children: [
          ProductCartCard(
            image: "assets/images/png/test-product.png",
            category: "Skin Care",
            productName: "Bubblzz Body Lotion",
            price: "500 LE",
            quantity: 2,
            onTap: () {},
          ),
          // Add more ProductCartCard items here if needed
        ],
      ),
    );
  }
}
