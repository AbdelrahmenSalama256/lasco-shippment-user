import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/cubit/global_cubit.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/home/view/component/widgets/company_grid.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';

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
            CompanyGrid(
              title: "favorite_companies".tr(context),
              companies: _getFavoriteCompanies(),
              childAspectRatio: 0.60,
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
