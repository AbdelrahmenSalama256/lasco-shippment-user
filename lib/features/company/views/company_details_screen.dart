import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/custom_loading_indicator.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/home/view/cubit/company_cubit.dart';

import '../../home/data/model/company_model.dart';
import '../../home/view/cubit/company_state.dart';
import '../../offers/views/widgets/custom_app_bar.dart';
import 'widgets/buy_now_section.dart';
import 'widgets/contact_us_item.dart';
import 'widgets/coverage_accourdion.dart';
import 'widgets/description_section.dart';
import 'widgets/reviews_section.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final int id;
  const CompanyDetailsScreen({super.key, required this.id});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  int quantity = 1;
  bool isDescriptionExpanded = false;

  void incrementQuantity() => setState(() => quantity++);
  void decrementQuantity() {
    if (quantity > 1) setState(() => quantity--);
  }

  void toggleDescription() =>
      setState(() => isDescriptionExpanded = !isDescriptionExpanded);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        bgColor: const Color(0xffF7F7F7),
        title: "company_details".tr(context),
      ),
      body: BlocProvider(
        create: (context) => CompanyCubit()..getCompanyDetails(widget.id),
        child: BlocBuilder<CompanyCubit, CompanyState>(
          builder: (context, state) {
            if (state is CompanyLoading) {
              return Expanded(
                  child: const Center(child: CustomLoadingIndicator()));
            }
            if (state is CompanyError) {
              return Expanded(child: Center(child: Text(state.message)));
            }
            if (state is CompanyDetailsLoaded) {
              final CompanyModel company = state.company;

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.all(16.w),
                                width: 94.w,
                                height: 94.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: AppColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xff000000)
                                          .withOpacity(0.1),
                                      blurRadius: 15.r,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: Image.network(
                                      company.logo!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 13,
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                offset: Offset(0, 0),
                                                spreadRadius: 0,
                                              )
                                            ]),
                                        child: Icon(
                                          CupertinoIcons.photo_camera_solid,
                                          color: AppColors.grey,
                                          size: 30.sp,
                                        ),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      company.name ?? "----",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: const Color(0xffFFB543),
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          "${company.averageRating ?? 0.0}",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xff2B2727),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Description
                          DescriptionSection(
                            isExpanded: isDescriptionExpanded,
                            onToggle: toggleDescription,
                            description: company.description ?? "",
                          ),

                          SizedBox(height: 20.h),

                          // Branches Section (لو API بترجع فروع بدل Static)
                          if (company.address != null)
                            CoverageSection(
                              coverage: company.coverage,
                            ),

                          SizedBox(height: 20.h),

                          // Contact Us
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "contact_us".tr(context),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  children: [
                                    if (company.phone != null)
                                      ContactUsItem(
                                        title: "phone".tr(context),
                                        iconPath: "assets/images/png/phone.png",
                                        onTap: () {
                                          // call company.phone
                                        },
                                      ),
                                    if (company.facebookUrl != null)
                                      ContactUsItem(
                                        title: "facebook".tr(context),
                                        iconPath:
                                            "assets/images/png/facebook.png",
                                        onTap: () {
                                          // open facebook
                                        },
                                      ),
                                    if (company.whatsappUrl != null)
                                      ContactUsItem(
                                        title: "whatsapp".tr(context),
                                        iconPath:
                                            "assets/images/png/whatsapp.png",
                                        onTap: () {
                                          // open whatsapp
                                        },
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const ReviewsSection(),
                          SizedBox(height: 80.h),
                        ],
                      ),
                    ),
                  ),
                  BuyNowSection(quantity: quantity),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
