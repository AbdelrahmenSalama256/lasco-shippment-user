import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lasco/core/constants/navigation.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/shop/views/shop_screen.dart';

import '../../../../../core/constants/app_colors.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  final List<CategoryModel> categories = const [
    CategoryModel(
      icon: "assets/images/svg/cosmetics.svg",
      name: "skin_care",
    ),
    CategoryModel(
      icon: "assets/images/svg/lotion.svg",
      name: "hair_care",
    ),
    CategoryModel(
      icon: "assets/images/svg/hair-care.svg",
      name: "makeup",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "categories".tr(context),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 90.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            separatorBuilder: (context, index) => SizedBox(
              width: 10.w,
            ),
            itemBuilder: (context, index) {
              return _buildCategoryItem(context, categories[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryModel category) {
    return GestureDetector(
      onTap: () {
        navigateTo(context, ShopScreen());
      },
      child: Column(
        children: [
          Container(
            width: 66.w,
            height: 66.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: const Color(0xFFf7f7f7),
            ),
            child: SvgPicture.asset(
              category.icon,
              width: 34.w,
              height: 34.h,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            category.name.tr(context),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryModel {
  final String icon;
  final String name;

  const CategoryModel({
    required this.icon,
    required this.name,
  });
}
