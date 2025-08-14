import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';

class OffersScreenCard extends StatelessWidget {
  final String? image;
  final String? title;
  final String? catName;
  final VoidCallback? ontap;

  const OffersScreenCard(
      {super.key, this.title, this.catName, this.ontap, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Color(0xffF7F7F7),
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(12.r),
          topStart: Radius.circular(12.r),
          bottomStart: Radius.circular(12.r),
          bottomEnd: Radius.circular(36.r),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            image!,
            width: 73.w,
            height: 97.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildPlaceholderImage(),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      catName!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: ontap,
                      child: Container(
                        width: 35.83268356323242.w,
                        height: 34.999366760253906.h,
                        alignment: Alignment.center,
                        // padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 7.w),
                        decoration: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadiusDirectional.only(
                            topEnd: Radius.circular(10.r),
                            topStart: Radius.circular(10.r),
                            bottomStart: Radius.circular(10.r),
                            bottomEnd: Radius.circular(25.r),
                          ),
                        ),
                        child: Icon(
                          CupertinoIcons.arrow_right,
                          color: AppColors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 80.h,
      width: 60.w,
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        Icons.shopping_bag_outlined,
        color: Colors.orange[400],
        size: 30.w,
      ),
    );
  }
}
