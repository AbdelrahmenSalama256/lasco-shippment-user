import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/notification/views/notifications_screen.dart';

import '../../../core/component/widgets/app_text_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/navigation.dart';
import '../../offers/views/offers_screen.dart';
import 'component/widgets/brand_list.dart';
import 'component/widgets/category_list.dart';
import 'component/widgets/offers_grid.dart';
import 'component/widgets/offers_section.dart';
import 'component/widgets/product_grid.dart';
import 'component/widgets/welcome_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Sample data for products
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
        isFavorite: false,
      ),
      ProductModel(
        id: '2',
        name: 'NIVEA Body Lotion',
        category: 'Skin Care',
        rating: 4.5,
        price: '450 LE',
        imageUrl: 'assets/images/png/test-product.png',
        isOnSale: true,
        isFavorite: false,
      ),
    ];
  }

  List<ProductModel> _getRecommendedProducts() {
    return [
      ProductModel(
        id: '3',
        name: 'JBL Club Pro',
        category: 'Audio',
        rating: 4.5,
        price: '60.15 LE',
        imageUrl: 'assets/images/png/test-product.png',
        isOnSale: false,
        isFavorite: false,
      ),
      ProductModel(
        id: '4',
        name: 'Sony Headphones',
        category: 'Audio',
        rating: 4.0,
        price: '80.00 LE',
        imageUrl: 'assets/images/png/test-product.png',
        isOnSale: false,
        isFavorite: false,
      ),
    ];
  }

  // Sample data for offers
  List<OfferModel> _getOffers() {
    return [
      OfferModel(
        id: '1',
        title: 'Summer Skin Care Kit',
        category: 'Skin Care',
        imageUrl: 'assets/images/png/test-product.png',
        description: 'Get 20% off on skin care essentials.',
        validUntil: DateTime(2025, 8, 15),
      ),
      OfferModel(
        id: '2',
        title: 'Audio Upgrade Deal',
        category: 'Audio',
        imageUrl: 'assets/images/png/test-product.png',
        description: 'Buy one, get 10% off the second item.',
        validUntil: DateTime(2025, 8, 20),
      ),
    ];
  }

  // Sample data for brands
  List<BrandModel> _getBrands() {
    return [
      BrandModel(
        imageUrl: 'assets/images/png/test-product2.png',
        name: 'Nivea',
      ),
      BrandModel(
        imageUrl: 'assets/images/png/test-product2.png',
        name: 'JBL',
      ),
      BrandModel(
        imageUrl: 'assets/images/png/test-product2.png',
        name: 'Sony',
      ),
      BrandModel(
        imageUrl: 'assets/images/png/test-product.png',
        name: 'Apple',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              SizedBox(height: 25.h),
              const WelcomeHeader(),
              SizedBox(height: 10.h),
              _buildSearchBar(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     SizedBox(height: 20.h),
                      _buildBanner(),
                      SizedBox(height: 20.h),
                      const CategoryList(),
                      SizedBox(height: 20.h),
                      ProductGrid(
                        title: "big_deals".tr(context),
                        products: _getBigDealsProducts(),
                        // childAspectRatio: 0.62,
                      ),
                      SizedBox(height: 20.h),
                      SpecialOffersGrid(
                        offers: _getOffers(),
                        onViewAllPressed: () {
                          navigateTo(context, OffersScreen());
                        },
                      ),
                      SizedBox(height: 20.h),
                      BrandList(
                        brands: _getBrands(),
                      ),
                      SizedBox(height: 20.h),
                      ProductGrid(
                        title: "products_you_may_like".tr(context),
                        products: _getRecommendedProducts(),
                        childAspectRatio: 0.60,
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: TextEditingController(),
            hintText: "search_products".tr(context),
            prefixIcon: Icon(
              CupertinoIcons.search,
              size: 25.sp,
              color: const Color(0xffB3B3B3),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        GestureDetector(
          onTap: () {
            navigateTo(context, NotificationScreen());
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF7F7F7),
                ),
                child: Icon(
                  CupertinoIcons.bell,
                  size: 20.sp,
                  color: AppColors.black,
                ),
              ),
              PositionedDirectional(
                end: 0,
                top: 0,
                child: Container(
                  width: 10.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBanner() {
    return Image.asset(
      "assets/images/png/banner.png",
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
