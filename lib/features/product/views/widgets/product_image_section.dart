import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductImageSection extends StatelessWidget {
  const ProductImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 302.h,
      width: 100.w,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Image.asset(
        width: double.infinity,
        height: double.infinity,
        "assets/images/png/test-product2.png",
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.local_offer,
              size: 80.w,
              color: Colors.pink[300],
            ),
          );
        },
      ),
    );
  }
}
