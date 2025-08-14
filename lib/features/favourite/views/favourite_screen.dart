import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/cubit/global_cubit.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/home/view/component/widgets/product_grid.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "favourite".tr(context),
        onTap: () {
          context.read<GlobalCubit>().changeBottomNavIndex(0);
        },
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 25.h),
            ProductGrid(
              products: _getBigDealsProducts(),
              childAspectRatio: 0.60,
            ),
          ],
        ),
      ),
    );
  }

  List<ProductModel> _getBigDealsProducts() {
    return [
      ProductModel(
        id: '1',
        name: 'NIVEA Sun Care',
        category: 'Skin Care',
        rating: 4.5,
        price: '500 LE',
        imageUrl: 'assets/images/png/test-product.png',
        isOnSale: true,
        isFavorite: true,
      ),
      ProductModel(
        id: '2',
        name: 'NIVEA Body Lotion',
        category: 'Skin Care',
        rating: 4.5,
        price: '450 LE',
        imageUrl: 'assets/images/png/test-product.png',
        isOnSale: true,
        isFavorite: true,
      ),
    ];
  }
}
