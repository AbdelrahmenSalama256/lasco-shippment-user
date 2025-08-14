import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';

import 'widgets/buy_now_section.dart';
import 'widgets/description_section.dart';
import 'widgets/product_details_section.dart';
import 'widgets/product_image_section.dart';
import 'widgets/reviews_section.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  bool isDescriptionExpanded = false;

  void incrementQuantity() => setState(() => quantity++);
  void decrementQuantity() {
    if (quantity > 1) setState(() => quantity--);
  }

  void toggleDescription() =>
      setState(() => isDescriptionExpanded = !isDescriptionExpanded);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Curved Background Container
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: 375.w,
              height: 310.h,
              decoration: BoxDecoration(
                color: const Color(0xffF7F7F7),
                borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(24.r),
                  bottomEnd: Radius.circular(100.r),
                ),
              ),
            ),
          ),

          // Custom App Bar
          Positioned(
            top: MediaQuery.of(context).padding.top - 40.h,
            left: 0,
            right: 0,
            child: CustomAppBar(
              bgColor: const Color(0xffF7F7F7),
              title: "product_details".tr(context),
              action: const [FavoriteButton()],
            ),
          ),

          // Main Content (Scrollable)
          Positioned(
            top: MediaQuery.of(context).padding.top + 40.h,
            left: 0,
            right: 0,
            bottom: 80.h, // Space for the fixed BuyNowSection
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      const ProductImageSection(),
                      ProductDetailsSection(
                        quantity: quantity,
                        onIncrement: incrementQuantity,
                        onDecrement: decrementQuantity,
                      ),
                    ],
                  ),
                  DescriptionSection(
                    isExpanded: isDescriptionExpanded,
                    onToggle: toggleDescription,
                  ),
                  const ReviewsSection(),
                  SizedBox(height: 80.h), // Spacer for the fixed BuyNowSection
                ],
              ),
            ),
          ),

          // Fixed BuyNowSection at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BuyNowSection(quantity: quantity),
          ),
        ],
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      margin: EdgeInsetsDirectional.only(end: 10.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: SvgPicture.asset(
          "assets/images/svg/heart.svg",
          width: 25.w,
        ),
      ),
    );
  }
}
