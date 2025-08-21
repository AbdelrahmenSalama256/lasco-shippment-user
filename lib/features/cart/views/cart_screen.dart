import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/constants/navigation.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/cart/views/widgets/package_cart_card.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';

import '../../../core/component/widgets/app_button.dart';
import '../../../core/cubit/global_cubit.dart';
import 'wating_for_approve.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  List<Map<String, dynamic>> _getCartItems() {
    return [
      {
        'orderId': '#12345',
        'from': 'Times Square',
        'to': 'Manhattan',
        'days': 5,
        'onTap': () {
          if (kDebugMode) {
            print('Tapped on order #12345');
          }
        },
      },
      {
        'orderId': '#12346',
        'from': 'Brooklyn',
        'to': 'Queens',
        'days': 5,
        'onTap': () {
          if (kDebugMode) {
            print('Tapped on order #12346');
          }
        },
      },
      {
        'orderId': '#12347',
        'from': 'Bronx',
        'to': 'Harlem',
        'days': 5,
        'onTap': () {
          if (kDebugMode) {
            print('Tapped on order #12347');
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
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final item = _getCartItems()[index];
                return PackageCartCard(
                  orderId: item['orderId'],
                  fromLocation: item['from'],
                  toLocation: item['to'],
                  days: item['days'],
                  onTap: item['onTap'],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: AppButton(
              backgroundColor: AppColors.orange,
              text: "checkout".tr(context),
              onPressed: () {
                navigateTo(context, const WatingForApprove());
              },
              height: 50.h,
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
