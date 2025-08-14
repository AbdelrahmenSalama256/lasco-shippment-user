import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/constants/navigation.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/offers/views/offers_screen.dart';

import 'offers_card.dart';
import 'offers_section.dart';

class SpecialOffersGrid extends StatelessWidget {
  final List<OfferModel> offers;
  final VoidCallback? onViewAllPressed;

  const SpecialOffersGrid({
    super.key,
    required this.offers,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        _buildSectionHeader(context),
        SizedBox(height: 16.h),

        SizedBox(
          height: 106.h,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            separatorBuilder: (context, index) => SizedBox(
              width: 10.w,
            ),
            itemCount:
                offers.length > 4 ? 4 : offers.length, // Show max 4 items
            itemBuilder: (context, index) {
              return SizedBox(
                width: 200.w, // Constrain card width for horizontal layout
                child: OfferGridCard(
                  title: offers[index].title,
                  category: offers[index].category,
                  imageUrl: offers[index].imageUrl,
                  onPressed: () {
                    navigateTo(context, OffersScreen());
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'special_offers'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
        GestureDetector(
          onTap: onViewAllPressed,
          child: Text(
            'view_all'.tr(context),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.secoundry,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.secoundry,
            ),
          ),
        ),
      ],
    );
  }
}
