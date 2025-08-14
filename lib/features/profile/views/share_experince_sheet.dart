import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/component/custom_toast.dart';
import 'package:lasco/core/component/widgets/app_button.dart';
import 'package:lasco/core/component/widgets/app_text_field.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/constants/widgets/print_util.dart';
import 'package:lasco/core/locale/app_loacl.dart';

class ShareExperienceBottomSheet extends StatefulWidget {
  const ShareExperienceBottomSheet({super.key});

  @override
  State<ShareExperienceBottomSheet> createState() =>
      _ShareExperienceBottomSheetState();
}

class _ShareExperienceBottomSheetState
    extends State<ShareExperienceBottomSheet> {
  double _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w).copyWith(
        bottom: MediaQuery.of(context).viewInsets.bottom +
            16.w, // Adjust for keyboard
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "rate_your_experience".tr(context),
              style: TextStyle(
                fontSize: 22.sp,
                color: AppColors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "feedback_prompt".tr(context),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.grey,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              unratedColor: const Color(0xffB2B2B2),
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 30.sp,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
              itemBuilder: (context, _) => const Icon(
                CupertinoIcons.star_fill,
                color: Color(0xffFFB543),
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _reviewController,
              maxLines: 4,
              radius: BorderRadiusDirectional.circular(12.r),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
              hintText: "share_you_experience".tr(context),
            ),
            SizedBox(height: 16.h),
            AppButton(
              onPressed: () {
                if (_rating > 0 && _reviewController.text.isNotEmpty) {
                  PrintUtil.info(
                      "Rating: $_rating, Review: ${_reviewController.text}");
                  Navigator.pop(context); // Close the bottom sheet
                } else {
                  showToast(context,
                      message: "please_provide_rating_and_review".tr(context),
                      state: ToastStates.error);
                }
              },
              text: "submit_review".tr(context),
              backgroundColor: AppColors.orange,
            ),
            SizedBox(
              height: 10.h,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                "maybe_later".tr(context),
                style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.orange,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline),
              ),
            )
          ],
        ),
      ),
    );
  }
}
