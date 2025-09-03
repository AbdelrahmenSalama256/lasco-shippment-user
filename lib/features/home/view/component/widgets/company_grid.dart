import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/navigation.dart';
import 'package:lasco/features/company/views/company_details_screen.dart';
import 'package:lasco/features/company/views/shopping_companies_screen.dart';

import 'company_card.dart';
import 'section_header.dart';

class CompanyGrid extends StatelessWidget {
  final String? title;
  final List<CompanyModel> companies;
  final int crossAxisCount;
  final double childAspectRatio;

  const CompanyGrid({
    super.key,
    this.title,
    required this.companies,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.75,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title ?? "Featured Companies",
          showViewAll: true,
          onViewAll: () {
            navigateTo(context, ShoppingCompaniesScreen());
          },
        ),

        SizedBox(height: 12.h),

        // Companies Grid
        GridView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            mainAxisExtent: 230.h,
          ),
          itemCount: companies.length,
          itemBuilder: (context, index) {
            final company = companies[index];
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
    );
  }
}

// Company Model
class CompanyModel {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;

  CompanyModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
  });
}
