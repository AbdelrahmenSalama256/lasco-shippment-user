import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lasco/core/locale/app_loacl.dart';

import '../../../core/component/widgets/app_text_field.dart';
import '../../home/view/component/widgets/company_grid.dart';
import 'cubit/shop_cubit.dart';
import 'cubit/shop_state.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'widgets/header_filter.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  // Sample data for companies
  List<CompanyModel> _getCompanies() {
    return [
      CompanyModel(
        id: '1',
        name: 'WALAA INTERRA',
        description: 'Shipping and logistics company',
        imageUrl: 'assets/images/png/com-2.png',
      ),
      CompanyModel(
        id: '2',
        name: 'LASCO Shipping',
        description: 'International cargo services',
        imageUrl: 'assets/images/png/com-1.png',
      ),
      CompanyModel(
        id: '3',
        name: 'Global Express',
        description: 'Worldwide delivery services',
        imageUrl: 'assets/images/png/company3.png',
      ),
      CompanyModel(
        id: '4',
        name: 'Fast Logistics',
        description: 'Quick and reliable shipping',
        imageUrl: 'assets/images/png/company4.png',
      ),
      CompanyModel(
        id: '5',
        name: 'Cargo Masters',
        description: 'Professional cargo handling',
        imageUrl: 'assets/images/png/company5.png',
      ),
      CompanyModel(
        id: '6',
        name: 'ShipEasy',
        description: 'Simplified shipping solutions',
        imageUrl: 'assets/images/png/company6.png',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: BlocBuilder<ShopCubit, ShopState>(
            builder: (context, state) {
              final cubit = context.read<ShopCubit>();
              return Column(
                children: [
                  SizedBox(height: 25.h),
                  CategoryFilterHeader(
                    categories: cubit.categories,
                    onCategoryChanged: (newCategory) {
                      cubit.updateCategory(newCategory);
                    },
                    onBackPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 10.h),
                  _buildSearchBar(context),
                  SizedBox(height: 10.h),
                  Expanded(
                    child: CompanyGrid(
                      title: "",
                      companies: _getCompanies(),
                      childAspectRatio: 0.60,
                    ),
                  ),
                ],
              );
            },
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
            hintText: "search_companies".tr(context), // Changed hint text
            prefixIcon: Icon(
              CupertinoIcons.search,
              size: 25.sp,
              color: const Color(0xffB3B3B3),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        GestureDetector(
          onTap: () => _showFilterBottomSheet(context),
          child: Container(
            width: 44.w,
            height: 44.h,
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xffF7F7F7),
            ),
            child: SvgPicture.asset(
              "assets/images/svg/filter-vertical.svg",
              width: 24.w,
              height: 24.h,
            ),
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) => ShopCubit(),
        child: BlocBuilder<ShopCubit, ShopState>(
          builder: (context, state) {
            return FilterBottomSheet(
              cubit: context.read<ShopCubit>(),
              currentPriceRange: context.read<ShopCubit>().currentPriceRange,
              brands: context.read<ShopCubit>().getBrands(),
              selectedBrandIds: context.read<ShopCubit>().selectedBrandIds,
              onApplyFilter: (priceRange, brandIds) {
                final cubit = context.read<ShopCubit>();
                cubit.updatePriceRange(priceRange);
                brandIds.forEach(cubit.toggleBrandSelection);
                cubit.applyFilters();
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }
}
