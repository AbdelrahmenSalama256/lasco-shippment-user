import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lasco/features/shop/views/cubit/shop_state.dart';

class ShopCubit extends Cubit<ShopState> {
  ShopCubit() : super(ShopInitial());

  String selectedCategory = "Skin Care";
  RangeValues currentPriceRange = const RangeValues(500, 10000);
  List<String> selectedBrandIds = [];

  final List<String> categories = [
    "Skin Care",
    "Hair Care",
    "Face Care",
  ];

  List<BrandFilterModel> getBrands() {
    return [
      BrandFilterModel(
        id: '1',
        name: 'Mazaya',
        imageUrl: 'assets/images/png/mazaya-brand.png',
      ),
      BrandFilterModel(
        id: '2',
        name: 'Sephora',
        imageUrl: 'assets/images/png/sephora-brand.png',
      ),
      BrandFilterModel(
        id: '3',
        name: "L'Occitane",
        imageUrl: 'assets/images/png/loccitane-brand.png',
      ),
      BrandFilterModel(
        id: '4',
        name: 'Mazaya',
        imageUrl: 'assets/images/png/mazaya-brand-2.png',
      ),
    ];
  }

  void updateCategory(String newCategory) {
    selectedCategory = newCategory;
    emit(ShopUpdated(
      selectedCategory: selectedCategory,
      currentPriceRange: currentPriceRange,
      selectedBrandIds: selectedBrandIds,
    ));
  }

  void updatePriceRange(RangeValues priceRange) {
    currentPriceRange = priceRange;
    emit(ShopUpdated(
      selectedCategory: selectedCategory,
      currentPriceRange: currentPriceRange,
      selectedBrandIds: selectedBrandIds,
    ));
  }

  void toggleBrandSelection(String brandId) {
    if (selectedBrandIds.contains(brandId)) {
      selectedBrandIds.remove(brandId);
    } else {
      selectedBrandIds.add(brandId);
    }
    emit(ShopUpdated(
      selectedCategory: selectedCategory,
      currentPriceRange: currentPriceRange,
      selectedBrandIds: selectedBrandIds,
    ));
  }

  void resetFilters() {
    currentPriceRange = const RangeValues(500, 10000);
    selectedBrandIds.clear();
    emit(ShopUpdated(
      selectedCategory: selectedCategory,
      currentPriceRange: currentPriceRange,
      selectedBrandIds: selectedBrandIds,
    ));
  }

  void applyFilters() {
    emit(ShopUpdated(
      selectedCategory: selectedCategory,
      currentPriceRange: currentPriceRange,
      selectedBrandIds: selectedBrandIds,
    ));
  }
}

class BrandFilterModel {
  final String id;
  final String name;
  final String imageUrl;

  BrandFilterModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}
