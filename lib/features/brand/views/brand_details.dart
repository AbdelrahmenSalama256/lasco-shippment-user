import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/cubit/global_cubit.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';

import '../../home/view/component/widgets/offers_card.dart';
import '../../home/view/component/widgets/product_grid.dart';

class BrandDetailsScreen extends StatefulWidget {
  final BrandDetailsModel brand;

  const BrandDetailsScreen({
    super.key,
    required this.brand,
  });

  @override
  State<BrandDetailsScreen> createState() => _BrandDetailsScreenState();
}

class _BrandDetailsScreenState extends State<BrandDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "place_details".tr(context),
      ),
      body: Column(
        children: [
          // Brand Header Section
          _buildBrandHeader(),

          // Tab Bar
          _buildTabBar(),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Products Tab
                _buildProductsTab(),

                // Offers Tab
                _buildOffersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Brand Logo and Info
          Row(
            children: [
              // Brand Logo
              Container(
                width: 94.w,
                height: 94.h,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Image.asset(
                  widget.brand.logoUrl ?? 'assets/images/png/mazaya.png',
                  // width: double.infinity,
                  // height: double.infinity,
                  // fit: BoxFit.contain,
                ),
              ),

              SizedBox(width: 16.w),

              // Brand Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.brand.name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.brand.categories,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Address Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppColors.orange,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  widget.brand.address,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(25.r),
          // color: Colors.grey[100],
          ),
      child: TabBar(
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerHeight: 0,
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
          color: AppColors.orange,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(
            child: Container(
              constraints: BoxConstraints(
                minWidth: 90.w,
              ),
              alignment: Alignment.center,
              child: Text(
                "products".tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: context.read<GlobalCubit>().language == "ar"
                      ? 'Arabic'
                      : "English",
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              constraints: BoxConstraints(
                minWidth: 90.w,
              ),
              alignment: Alignment.center,
              child: Text(
                "offers".tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: context.read<GlobalCubit>().language == "ar"
                      ? 'Arabic'
                      : "English",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      child: ProductGrid(
        title: "",
        products: _getBrandProducts(),
        // childAspectRatio: 0.72,
      ),
    );
  }

  Widget _buildOffersTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        spacing: 10.h,
        children: _getBrandOffers().map((offer) {
          return OfferGridCard(
            title: offer.title,
            category: offer.category,
            imageUrl: offer.imageUrl,
            onPressed: () {
              // Optional onPressed action, e.g., navigate or show details
              // Uncomment and implement if needed
              // Navigator.push(context, MaterialPageRoute(builder: (context) => OfferDetailsScreen()));
            },
          );
        }).toList(),
      ),
    );
  }

  List<ProductModel> _getBrandProducts() {
    return [
      ProductModel(
        id: '1',
        name: 'Bubblzz Body Lotion',
        category: 'Skin Care',
        rating: 4.5,
        price: '500 LE',
        imageUrl: 'assets/images/png/test-product.png',
        isOnSale: true,
        isFavorite: false,
      ),
      ProductModel(
        id: '2',
        name: 'Bubblzz Body Lotion',
        category: 'Skin Care',
        rating: 4.5,
        price: '500 LE',
        imageUrl: 'assets/images/png/test-product.png',
        isOnSale: true,
        isFavorite: false,
      ),
      ProductModel(
        id: '3',
        name: 'Bubblzz Body Lotion',
        category: 'Skin Care',
        rating: 4.5,
        price: '500 LE',
        imageUrl: 'assets/images/png/test-product.png',
        isOnSale: true,
        isFavorite: false,
      ),
      ProductModel(
        id: '4',
        name: 'Bubblzz Body Lotion',
        category: 'Skin Care',
        rating: 4.5,
        price: '500 LE',
        imageUrl: 'assets/images/png/test-product.png',
        isOnSale: true,
        isFavorite: false,
      ),
    ];
  }

  List<BrandOfferModel> _getBrandOffers() {
    return [
      BrandOfferModel(
        id: '1',
        title: 'buy_2_get_1_free'.tr(context),
        category: 'Skin Care',
        imageUrl: 'assets/images/png/test-product.png',
      ),
      BrandOfferModel(
        id: '2',
        title: 'buy_2_get_1_free'.tr(context),
        category: 'Skin Care',
        imageUrl: 'assets/images/png/test-product.png',
      ),
      BrandOfferModel(
        id: '3',
        title: 'buy_2_get_1_free'.tr(context),
        category: 'Skin Care',
        imageUrl: 'assets/images/png/test-product.png',
      ),
    ];
  }
}

// Brand Details Model
class BrandDetailsModel {
  final String id;
  final String name;
  final String logoText;
  final String categories;
  final String address;
  final String? logoUrl;

  BrandDetailsModel({
    required this.id,
    required this.name,
    required this.logoText,
    required this.categories,
    required this.address,
    this.logoUrl,
  });
}

// Brand Offer Model
class BrandOfferModel {
  final String id;
  final String title;
  final String category;
  final String? imageUrl;

  BrandOfferModel({
    required this.id,
    required this.title,
    required this.category,
    this.imageUrl,
  });
}
