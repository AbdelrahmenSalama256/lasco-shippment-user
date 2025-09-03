import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';

import '../../../core/constants/navigation.dart';
import '../../home/view/component/widgets/company_card.dart';
import '../../home/view/component/widgets/company_grid.dart';
import 'company_details_screen.dart';

class ShoppingCompaniesScreen extends StatelessWidget {
  const ShoppingCompaniesScreen({super.key});
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
        imageUrl: 'assets/images/png/com-2.png',
      ),
      CompanyModel(
        id: '4',
        name: 'Fast Logistics',
        description: 'Quick and reliable shipping',
        imageUrl: 'assets/images/png/com-1.png',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "shipping_companies".tr(context),
        ),
        body: Column(
          children: [
            SizedBox(height: 12.h),

            // Companies Grid
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
              itemCount: _getCompanies().length,
              itemBuilder: (context, index) {
                final company = _getCompanies()[index];
                return CompanyCard(
                  companyName: company.name,
                  description: company.description,
                  imageUrl: company.imageUrl,
                  onViewPressed: () {
                    navigateTo(context, CompanyDetailsScreen());
                  },
                );
              },
            ),
          ],
        ));
  }
}
