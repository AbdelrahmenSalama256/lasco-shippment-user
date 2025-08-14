import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/constants/navigation.dart';
import 'package:lasco/features/product/views/product_details_screen.dart';

import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final String? title;
  final List<ProductModel> products;
  final int crossAxisCount;
  final double childAspectRatio;

  const ProductGrid({
    super.key,
    this.title,
    required this.products,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.75,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        title != null
            ? Text(
                title!,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              )
            : SizedBox.shrink(),

        SizedBox(height: 12.h),

        // Products Grid
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
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              productName: product.name,
              category: product.category,
              rating: product.rating,
              price: product.price,
              imageUrl: product.imageUrl,
              isOnSale: product.isOnSale,
              isFavorite: product.isFavorite,
              ontap: () {
                navigateTo(context, ProductDetailsScreen());
              },
              onFavoritePressed: () => _onFavoritePressed(product),
              onAddToCartPressed: () => _onAddToCartPressed(product),
            );
          },
        ),
      ],
    );
  }

  void _onFavoritePressed(ProductModel product) {
    // Handle favorite toggle
    if (kDebugMode) {
      print('Favorite pressed for: ${product.name}');
    }
  }

  void _onAddToCartPressed(ProductModel product) {
    // Handle add to cart
    if (kDebugMode) {
      print('Add to cart pressed for: ${product.name}');
    }
  }
}

// Product Model
class ProductModel {
  final String id;
  final String name;
  final String category;
  final double rating;
  final String price;
  final String? imageUrl;
  final bool isOnSale;
  final bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.price,
    this.imageUrl,
    this.isOnSale = false,
    this.isFavorite = false,
  });
}
