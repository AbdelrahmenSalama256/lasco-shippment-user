import 'package:flutter/material.dart';

class ShopState {}

class ShopInitial extends ShopState {}

class ShopUpdated extends ShopState {
  final String selectedCategory;
  final RangeValues currentPriceRange;
  final List<String> selectedBrandIds;

  ShopUpdated({
    this.selectedCategory = "Skin Care", // Default value
    this.currentPriceRange = const RangeValues(500, 10000), // Default value
    this.selectedBrandIds = const [], // Default value
  });
}
