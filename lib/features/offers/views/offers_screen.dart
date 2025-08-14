import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/constants/widgets/print_util.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';
import 'package:lasco/features/offers/views/widgets/offers_screen_card.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  // Sample data for OffersScreenCard
  List<Map<String, dynamic>> _getOfferData() {
    return [
      {
        'catName': 'Skin Care',
        'title': 'Buy 2 Get 1 Free',
        'image': 'assets/images/png/test-product.png',
        'ontap': () {
          PrintUtil.debug('Tapped on Skin Care Offer');
        },
      },
      {
        'catName': 'Audio',
        'title': '20% Off Headphones',
        'image': 'assets/images/png/test-product.png',
        'ontap': () {
          PrintUtil.debug('Tapped on Audio Offer');
        },
      },
      {
        'catName': 'Electronics',
        'title': 'Summer Gadget Sale',
        'image': 'assets/images/png/test-product.png',
        'ontap': () {
          PrintUtil.debug('Tapped on Electronics Offer');
        },
      },
      {
        'catName': 'Fashion',
        'title': 'Buy 1 Get 50% Off',
        'image': 'assets/images/png/test-product.png',
        'ontap': () {
          PrintUtil.debug('Tapped on Fashion Offer');
        },
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "offers".tr(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: _getOfferData().length,
              itemBuilder: (context, index) {
                final offer = _getOfferData()[index];
                return OffersScreenCard(
                  catName: offer['catName'],
                  title: offer['title'],
                  image: offer['image'],
                  ontap: offer['ontap'],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
