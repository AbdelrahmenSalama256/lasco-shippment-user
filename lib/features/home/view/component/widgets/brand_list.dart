import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/navigation.dart';
import 'package:lasco/core/locale/app_loacl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../brand/views/brand_details.dart';
import '../../../../brand/views/brands_screen.dart';
import 'brand_card.dart';

class BrandList extends StatelessWidget {
  final List<BrandModel> brands;

  const BrandList({
    super.key,
    required this.brands,
  });

  @override
  Widget build(BuildContext context) {
    final mazayaBrand = BrandDetailsModel(
      id: '1',
      name: 'Mazaya',
      logoText: 'mazaYa',
      categories: 'Skin Care, Makeup, Perfumes',
      address:
          'Building 36, Street 308, Degla square, maadi, cairo governorate',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "brands".tr(context),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
            GestureDetector(
              onTap: () {
                navigateTo(context, BrandsScreen());
              },
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
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 72.h,
          child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(width: 15.w),
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: brands.length,
            itemBuilder: (context, index) {
              return BrandCard(
                imageUrl: brands[index].imageUrl,
                onTap: () {
                  navigateTo(context, BrandDetailsScreen(brand: mazayaBrand));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// Brand Model
class BrandModel {
  final String imageUrl;
  final String name; // Optional name for logging or future use

  BrandModel({
    required this.imageUrl,
    this.name = 'Unknown Brand', // Default name
  });
}
