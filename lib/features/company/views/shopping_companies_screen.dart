import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/navigation.dart';
import '../../home/view/component/widgets/company_card.dart';
import '../../home/view/cubit/company_cubit.dart';
import '../../home/view/cubit/company_state.dart';
import 'company_details_screen.dart';

class ShoppingCompaniesScreen extends StatelessWidget {
  const ShoppingCompaniesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompanyCubit()..getCompanies(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: "shipping_companies".tr(context),
        ),
        body: BlocBuilder<CompanyCubit, CompanyState>(
          builder: (context, state) {
            return state is CompanyLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.orange,
                    ),
                  )
                : state is CompanyError
                    ? Center(
                        child: Text(
                          state.message,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.sp,
                          ),
                        ),
                      )
                    : state is CompanyLoaded
                        ? Padding(
                            padding: EdgeInsets.all(16.w),
                            child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 12.h,
                                mainAxisExtent: 230.h,
                              ),
                              itemCount: state.companies.length,
                              itemBuilder: (context, index) {
                                final company = state.companies[index];
                                return CompanyCard(
                                  companyName: company.name ?? "",
                                  description: company.description ?? "",
                                  imageUrl: company.logo,
                                  onViewPressed: () {
                                    navigateTo(
                                      context,
                                      CompanyDetailsScreen(
                                        id: company.id ?? 0,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        : const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
