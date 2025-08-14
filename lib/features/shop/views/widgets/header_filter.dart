import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lasco/core/constants/app_colors.dart';

import '../cubit/shop_cubit.dart';
import '../cubit/shop_state.dart';

class CategoryFilterHeader extends StatefulWidget {
  final List<String> categories;
  final Function(String) onCategoryChanged;
  final VoidCallback? onBackPressed;

  const CategoryFilterHeader({
    super.key,
    required this.categories,
    required this.onCategoryChanged,
    this.onBackPressed,
  });

  @override
  State<CategoryFilterHeader> createState() => _CategoryFilterHeaderState();
}

class _CategoryFilterHeaderState extends State<CategoryFilterHeader> {
  // Map of category names to their corresponding SVG icons
  final Map<String, String> categoryIcons = {
    'Skin Care': 'assets/images/svg/cosmetics.svg',
    'Hair Care': 'assets/images/svg/hair-care.svg',
    'Face Care': 'assets/images/svg/lotion.svg',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: widget.onBackPressed ?? () => Navigator.pop(context),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Icon(
                CupertinoIcons.back,
                color: AppColors.orange,
                size: 25.sp,
              ),
            ),
          ),

          // Category Dropdown
          BlocBuilder<ShopCubit, ShopState>(
            builder: (context, state) {
              final selectedCategory =
                  state is ShopUpdated ? state.selectedCategory : "Skin Care";
              return _buildCategoryDropdown(selectedCategory);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown(String selectedCategory) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.orange,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
            size: 20.w,
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          elevation: 1,
          isDense: true,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          selectedItemBuilder: (context) =>
              widget.categories.map((String category) {
            return Container(
              alignment: Alignment.center,
              margin: EdgeInsetsDirectional.only(end: 5.w),
              child: Text(
                category,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          }).toList(),
          items: widget.categories.map((String category) {
            return DropdownMenuItem<String>(
              alignment: Alignment.center,
              value: category,
              child: Row(
                children: [
                  // SVG Icon
                  SvgPicture.asset(
                    categoryIcons[category] ?? 'assets/images/svg/bag.svg',
                    width: 20.w,
                    height: 20.h,
                    // color: Colors.black87,
                  ),
                  SizedBox(width: 8.w),
                  // Category Text
                  Text(
                    category,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              widget.onCategoryChanged(newValue);
            }
          },
        ),
      ),
    );
  }
}
