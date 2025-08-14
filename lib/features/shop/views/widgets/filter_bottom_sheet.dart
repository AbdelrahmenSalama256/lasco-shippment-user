import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';

import '../../../../core/component/widgets/app_button.dart';
import '../../../home/view/component/widgets/brand_card.dart';
import '../cubit/shop_cubit.dart';

class FilterBottomSheet extends StatefulWidget {
  final double minPrice;
  final double maxPrice;
  final ShopCubit cubit;
  final RangeValues currentPriceRange;
  final List<BrandFilterModel> brands;
  final List<String> selectedBrandIds;
  final Function(RangeValues, List<String>) onApplyFilter;

  const FilterBottomSheet({
    super.key,
    this.minPrice = 500,
    this.maxPrice = 10000,
    required this.cubit,
    required this.currentPriceRange,
    required this.brands,
    required this.selectedBrandIds,
    required this.onApplyFilter,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late RangeValues _currentRangeValues;
  late List<String> _selectedBrandIds;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = widget.currentPriceRange;
    _selectedBrandIds = List.from(widget.selectedBrandIds);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(50.r),
          topEnd: Radius.circular(50.r),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(widget.cubit, context),

                  SizedBox(height: 30.h),

                  // Price Range Section
                  _buildPriceRangeSection(widget.cubit, context),

                  SizedBox(height: 30.h),

                  // Brands Section
                  _buildBrandsSection(widget.cubit, context),

                  SizedBox(height: 0.h),
                ],
              ),
            ),
          ),

          // Save Button
          Padding(
            padding: EdgeInsets.all(20.w),
            child: AppButton(
              text: "save".tr(context),
              onPressed: () {
                widget.cubit.updatePriceRange(_currentRangeValues);
                _selectedBrandIds.forEach(widget.cubit.toggleBrandSelection);
                widget.cubit.applyFilters();
                Navigator.pop(context);
              },
              backgroundColor: AppColors.orange,
              textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ShopCubit cubit, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: AppButton(
            text: "filter".tr(context),
            backgroundColor: const Color(0xffFEEBE3),
            textStyle: TextStyle(
              color: AppColors.orange,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
            borderRadius: BorderRadius.circular(12.r),
            onPressed: () {},
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        Expanded(
          child: AppButton(
            text: "reset".tr(context),
            backgroundColor: AppColors.orange,
            onPressed: () {
              cubit.resetFilters();
              setState(() {
                _currentRangeValues = const RangeValues(500, 10000);
                _selectedBrandIds.clear();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRangeSection(ShopCubit cubit, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "price_range".tr(context),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),

        SizedBox(height: 20.h),

        // Range Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.secoundry,
            inactiveTrackColor: Colors.grey[300],
            thumbColor: AppColors.secoundry,
            overlayColor: AppColors.secoundry.withOpacity(0.5),
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.r),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 20.r),
            trackHeight: 4.h,
            rangeThumbShape:
                RoundRangeSliderThumbShape(enabledThumbRadius: 10.r),
            rangeTrackShape: RoundedRectRangeSliderTrackShape(),
          ),
          child: RangeSlider(
            values: _currentRangeValues,
            min: widget.minPrice,
            max: widget.maxPrice,
            divisions: 20,
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
            },
          ),
        ),

        SizedBox(height: 10.h),

        // Price Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${_currentRangeValues.start.round()} LE",
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "${_currentRangeValues.end.round()} LE",
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBrandsSection(ShopCubit cubit, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "brands".tr(context),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),

        SizedBox(height: 16.h),

        // Brands List (Scrollable)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.brands.map((brand) {
              bool isSelected = _selectedBrandIds.contains(brand.id);

              return Padding(
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 10.w, vertical: 10.h),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedBrandIds.contains(brand.id)) {
                        _selectedBrandIds.remove(brand.id);
                      } else {
                        _selectedBrandIds.add(brand.id);
                      }
                    });
                    cubit.toggleBrandSelection(brand.id);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      border: isSelected
                          ? Border.all(color: AppColors.orange, width: 2)
                          : null,
                    ),
                    child: BrandCard(
                      imageUrl: brand.imageUrl,
                      onTap: () {
                        setState(() {
                          if (_selectedBrandIds.contains(brand.id)) {
                            _selectedBrandIds.remove(brand.id);
                          } else {
                            _selectedBrandIds.add(brand.id);
                          }
                        });
                        cubit.toggleBrandSelection(brand.id);
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
