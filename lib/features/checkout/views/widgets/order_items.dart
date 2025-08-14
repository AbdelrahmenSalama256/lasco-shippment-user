import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';

import '../cubit/checkout_cubit.dart';
import 'product_cart_card.dart';

class OrderItems extends StatelessWidget {
  final CheckoutCubit cubit;

  const OrderItems({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final items = cubit.orderItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "order_items".tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 170.h,
          child: items.isEmpty
              ? Center(
                  child: Text(
                    "no_items_found".tr(context),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: EdgeInsets.only(
                          right: index < items.length - 1 ? 12.w : 0),
                      child: SizedBox(
                        width: 300.w, // Fixed width for each card
                        child: ProductCartCard(
                          image: item['imageUrl'],
                          category: item['category'],
                          productName: item['name'],
                          price: "${item['price']} LE",
                          quantity: item['quantity'],
                          isOrder: true,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
