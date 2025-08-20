import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';

import '../../offers/views/widgets/custom_app_bar.dart';
import '../data/models/branch_model.dart';
import 'widgets/branch_accourdion.dart';
import 'widgets/buy_now_section.dart';
import 'widgets/contact_us_item.dart';
import 'widgets/description_section.dart';
import 'widgets/reviews_section.dart';

class CompanyDetailsScreen extends StatefulWidget {
  const CompanyDetailsScreen({super.key});

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
      body: Column(
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
                                color: Color(0xff000000).withOpacity(0.1),
                                blurRadius: 15.r,
                                offset: Offset(0, 0),
                              ),
                            ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.asset(
                            "assets/images/png/com-1.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // SizedBox(width: 10.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "LASCO Shipping",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black,
                              ),
                            ),
                            // rate
                            SizedBox(height: 5.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Color(0xffFFB543),
                                  size: 16.sp,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  "4.5",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff2B2727),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  DescriptionSection(
                    isExpanded: isDescriptionExpanded,
                    onToggle: toggleDescription,
                  ),
                  // drop down item for branches section smoothly
                  SizedBox(height: 20.h),
                  BranchesSection(
                    branches: [
                      BranchModel(
                        name: "Cairo",
                        location: "Downtown, Talaat Harb St.",
                        phone: "+20 100 123 4567",
                      ),
                      BranchModel(
                        name: "Alexandria",
                        location: "Stanley Bridge",
                        phone: "+20 101 765 4321",
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // contact links section
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              ContactUsItem(
                                title: "phone".tr(context),
                                iconPath: "assets/images/png/phone.png",
                                onTap: () {
                                  // call action
                                },
                              ),
                              SizedBox(width: 10.w),
                              ContactUsItem(
                                title: "facebook".tr(context),
                                iconPath: "assets/images/png/facebook.png",
                                onTap: () {
                                  // send email action
                                },
                              ),
                              SizedBox(width: 10.w),
                              ContactUsItem(
                                title: "whatsapp".tr(context),
                                iconPath: "assets/images/png/whatsapp.png",
                                onTap: () {
                                  // send email action
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const ReviewsSection(),
                  SizedBox(height: 80.h), // Spacer for the fixed BuyNowSection
                ],
              ),
            ),
          ),

          // Fixed BuyNowSection at the bottom
          BuyNowSection(quantity: quantity),
        ],
      ),
    );
  }
}
