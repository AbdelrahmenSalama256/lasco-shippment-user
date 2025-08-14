import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/constants/navigation.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';

import '../data/models/brand_model.dart';
import 'brand_details.dart';
import 'widgets/brand_card.dart';
import 'widgets/brand_category_filter.dart';
import 'widgets/brand_empty_state.dart';
import 'widgets/brand_results_header.dart';
import 'widgets/brand_search_section.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<BrandModel> _filteredBrands = [];
  List<BrandModel> _allBrands = [];
  String _selectedCategory = 'All';
  bool _isSearchFocused = false;

  late AnimationController _searchAnimationController;
  late Animation<double> _searchScaleAnimation;

  final List<String> _categories = [
    'All',
    'Electronics',
    'Beauty',
    'Sports',
    'Audio',
    'Mobile'
  ];

  @override
  void initState() {
    super.initState();
    _allBrands = _getAllBrands();
    _filteredBrands = _allBrands;
    _searchController.addListener(_filterBrands);
    _searchFocusNode.addListener(_onSearchFocusChange);

    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _searchScaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
          parent: _searchAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }

  void _onSearchFocusChange() {
    setState(() {
      _isSearchFocused = _searchFocusNode.hasFocus;
    });

    if (_isSearchFocused) {
      _searchAnimationController.forward();
    } else {
      _searchAnimationController.reverse();
    }
  }

  void _filterBrands() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBrands = _allBrands.where((brand) {
        final matchesSearch = brand.name.toLowerCase().contains(query);
        final matchesCategory = _selectedCategory == 'All' ||
            (brand.categories
                    ?.toLowerCase()
                    .contains(_selectedCategory.toLowerCase()) ??
                false);
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterBrands();
  }

  void _clearFilters() {
    _searchController.clear();
    _selectCategory('All');
  }

  void _navigateToBrandDetails(BrandModel brand) {
    final brandDetails = BrandDetailsModel(
      id: brand.id ?? '1',
      name: brand.name,
      logoText: brand.name,
      categories: brand.categories ?? 'Various Categories',
      address: brand.address ?? 'Address not available',
      logoUrl: brand.imageUrl,
    );

    navigateTo(context, BrandDetailsScreen(brand: brandDetails));
  }

  List<BrandModel> _getAllBrands() {
    return [
      BrandModel(
        id: '1',
        imageUrl: 'assets/images/png/test-product2.png',
        name: 'Nivea',
        categories: 'Beauty, Skin Care',
        address: 'Building 12, Street 45, New Cairo',
      ),
      BrandModel(
        id: '2',
        imageUrl: 'assets/images/png/test-product2.png',
        name: 'JBL',
        categories: 'Audio, Electronics',
        address: 'Building 8, Street 23, Maadi',
      ),
      BrandModel(
        id: '3',
        imageUrl: 'assets/images/png/test-product2.png',
        name: 'Sony',
        categories: 'Electronics, Audio',
        address: 'Building 15, Street 67, Heliopolis',
      ),
      BrandModel(
        id: '4',
        imageUrl: 'assets/images/png/test-product.png',
        name: 'Apple',
        categories: 'Electronics, Mobile',
        address: 'Building 20, Street 89, Zamalek',
      ),
      BrandModel(
        id: '5',
        imageUrl: 'assets/images/png/mazaya.png',
        name: 'Mazaya',
        categories: 'Beauty, Makeup, Perfumes',
        address: 'Building 36, Street 308, Degla square, maadi',
      ),
      BrandModel(
        id: '6',
        imageUrl: 'assets/images/png/test-product2.png',
        name: 'Samsung',
        categories: 'Electronics, Mobile',
        address: 'Building 25, Street 12, New Capital',
      ),
      BrandModel(
        id: '7',
        imageUrl: 'assets/images/png/test-product.png',
        name: 'L\'Oreal',
        categories: 'Beauty, Makeup, Hair Care',
        address: 'Building 30, Street 55, Dokki',
      ),
      BrandModel(
        id: '8',
        imageUrl: 'assets/images/png/test-product2.png',
        name: 'Adidas',
        categories: 'Sports, Fashion',
        address: 'Building 18, Street 77, Mohandessin',
      ),
      BrandModel(
        id: '9',
        imageUrl: 'assets/images/png/test-product.png',
        name: 'Nike',
        categories: 'Sports, Fashion',
        address: 'Building 22, Street 33, Nasr City',
      ),
      BrandModel(
        id: '10',
        imageUrl: 'assets/images/png/test-product2.png',
        name: 'Huawei',
        categories: 'Electronics, Mobile',
        address: 'Building 14, Street 91, 6th October',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: // Header Section
          CustomAppBar(title: "brands".tr(context)),
      body: SafeArea(
        child: Column(
          children: [
            // Search Section
            BrandSearchSection(
              controller: _searchController,
              focusNode: _searchFocusNode,
              isSearchFocused: _isSearchFocused,
              scaleAnimation: _searchScaleAnimation,
              onClearSearch: () {
                _searchController.clear();
                _searchFocusNode.unfocus();
              },
            ),

            // Category Filter
            BrandCategoryFilter(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: _selectCategory,
            ),

            // Main Content
            Expanded(
              child: _filteredBrands.isEmpty
                  ? BrandEmptyState(onClearFilters: _clearFilters)
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BrandResultsHeader(
                                  resultsCount: _filteredBrands.length,
                                  selectedCategory: _selectedCategory,
                                ),
                                SizedBox(height: 15.h),
                              ],
                            ),
                          ),

                          // Replace the ListView.builder with this GridView.builder
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 8.h),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // Number of items per row
                              crossAxisSpacing:
                                  15.w, // Horizontal spacing between items
                              mainAxisSpacing:
                                  20.h, // Vertical spacing between items
                              childAspectRatio:
                                  0.65, // Width/height ratio of each item
                            ),
                            itemCount: _filteredBrands.length,
                            itemBuilder: (context, index) {
                              final brand = _filteredBrands[index];
                              return BrandCard(
                                brand: brand,
                                index: index,
                                onTap: () => _navigateToBrandDetails(brand),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
