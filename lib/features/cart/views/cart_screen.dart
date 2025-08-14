import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/constants/navigation.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/cart/views/widgets/product_cart_card.dart';
import 'package:lasco/features/checkout/views/checkout_screen.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';

import '../../../core/cubit/global_cubit.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  // Sample data for ProductCartCard
  List<Map<String, dynamic>> _getCartItems() {
    return [
      {
        'image': 'assets/images/png/test-product.png',
        'category': 'Skin Care',
        'productName': 'Bubblzz Body Lotion',
        'price': '500 LE',
        'quantity': 2,
        'onTap': () {
          if (kDebugMode) {
            print('Tapped on Bubblzz Body Lotion');
          }
        },
      },
      {
        'image': 'assets/images/png/test-product.png',
        'category': 'Audio',
        'productName': 'JBL Club Pro',
        'price': '60.15 LE',
        'quantity': 1,
        'onTap': () {
          if (kDebugMode) {
            print('Tapped on JBL Club Pro');
          }
        },
      },
      {
        'image': 'assets/images/png/test-product.png',
        'category': 'Electronics',
        'productName': 'Smart Watch',
        'price': '150.00 LE',
        'quantity': 3,
        'onTap': () {
          if (kDebugMode) {
            print('Tapped on Smart Watch');
          }
        },
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "cart".tr(context),
        onTap: () {
          context.read<GlobalCubit>().changeBottomNavIndex(0);
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              itemCount: _getCartItems().length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final item = _getCartItems()[index];
                return ProductCartCard(
                  image: item['image'],
                  category: item['category'],
                  productName: item['productName'],
                  price: item['price'],
                  quantity: item['quantity'],
                  onTap: item['onTap'],
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            width: double.infinity,
            height: 56.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                topEnd: Radius.circular(12.r),
                topStart: Radius.circular(12.r),
                bottomStart: Radius.circular(12.r),
                bottomEnd: Radius.circular(36.r),
              ),
              color: AppColors.orange,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  constraints: BoxConstraints(
                    minWidth: 112.w,
                  ),
                  alignment: Alignment.center,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                      topEnd: Radius.circular(12.r),
                      topStart: Radius.circular(12.r),
                      bottomStart: Radius.circular(12.r),
                      bottomEnd: Radius.circular(36.r),
                    ),
                    color: AppColors.white,
                  ),
                  child: Text(
                    "1000 LE",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      navigateTo(context, CheckoutScreen());
                    },
                    child: Center(
                      child: Text(
                        "checkout".tr(context),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}
