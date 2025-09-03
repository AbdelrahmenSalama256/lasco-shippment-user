import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/cubit/global_cubit.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/home/view/component/widgets/company_grid.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';

import '../../../core/constants/navigation.dart';
import '../../company/views/company_details_screen.dart';
import '../../home/view/component/widgets/company_card.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "favourite".tr(context),
        onTap: () {
          context.read<GlobalCubit>().changeBottomNavIndex(0);
        },
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // For favorite companies (if you want to show both)
            GridView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                mainAxisExtent: 230.h,
              ),
              itemCount: _getFavoriteCompanies().length,
              itemBuilder: (context, index) {
                final company = _getFavoriteCompanies()[index];
                return CompanyCard(
                  companyName: company.name,
                  description: company.description,
                  imageUrl: company.imageUrl,
                  isFav: true,
                  onViewPressed: () {
                    navigateTo(context, CompanyDetailsScreen());
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<CompanyModel> _getFavoriteCompanies() {
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
    ];
  }
}
