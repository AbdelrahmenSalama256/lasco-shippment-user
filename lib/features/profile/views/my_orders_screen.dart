import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';

import '../../home/data/model/recent_orders_model.dart';
import '../data/models/order_details_model.dart';
import '../data/models/order_item_model.dart';
import 'order_details_screen.dart';
import 'widgets/my_orders_card.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<RecentOrdersModel> processingOrders = [
    RecentOrdersModel(
      id: "F124G375",
      currentStep: 2,
      totalSteps: 5,
      fromLocation: "Manhattan",
      toLocation: "Times Square",
      fromDate: "18 Jul, 2024",
      toDate: "18 Jul, 2024",
      status: "Processing",
    ),
    RecentOrdersModel(
      id: "B978X421",
      currentStep: 3,
      totalSteps: 5,
      fromLocation: "Brooklyn",
      toLocation: "Queens",
      fromDate: "19 Jul, 2024",
      toDate: "19 Jul, 2024",
      status: "Processing",
    ),
  ];

  final List<RecentOrdersModel> deliveredOrders = [
    RecentOrdersModel(
      id: "C543H210",
      currentStep: 5,
      totalSteps: 5,
      fromLocation: "Harlem",
      toLocation: "Bronx",
      fromDate: "20 Jul, 2024",
      toDate: "20 Jul, 2024",
      status: "Delivered",
    ),
  ];

  final List<RecentOrdersModel> cancelledOrders = [
    RecentOrdersModel(
      id: "D987K654",
      currentStep: 1,
      totalSteps: 5,
      fromLocation: "Staten Island",
      toLocation: "Manhattan",
      fromDate: "21 Jul, 2024",
      toDate: "21 Jul, 2024",
      status: "Cancelled",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "my_orders".tr(context),
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.circular(25.r),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              tabs: [
                Tab(text: "processing".tr(context)),
                Tab(text: "cancelled".tr(context)),
                Tab(text: "compeleted".tr(context)),
              ],
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOrdersList(processingOrders),
                _buildOrdersList(deliveredOrders),
                _buildOrdersList(cancelledOrders),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<RecentOrdersModel> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80.w,
              color: Colors.grey[300],
            ),
            SizedBox(height: 16.h),
            Text(
              "no_orders_found".tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderCard(
          orderId: orders[index].id,
          currentStep: orders[index].currentStep,
          totalSteps: orders[index].totalSteps,
          fromDate: orders[index].fromDate,
          fromLocation: orders[index].fromLocation,
          toDate: orders[index].toDate,
          toLocation: orders[index].toLocation,
          status: orders[index].status ?? "Processing",
          onViewDetailsPressed: () {
            _navigateToOrderDetails(context, orders[index]);
          },
        );
      },
    );
  }

  void _navigateToOrderDetails(BuildContext context, RecentOrdersModel order) {
    // Convert RecentOrdersModel to OrderDetailModel
    final orderDetail = OrderDetailModel(
      orderId: order.id,
      orderDate: order.fromDate,
      deliveryAddress: "${order.toLocation}, USA", // Replace with actual data
      mobileNumber: "+1 123 456 7890", // Replace with actual data
      paymentMethods: [
        PaymentMethodModel(
          title: "Cash on Delivery",
          isCompleted: order.status == "Delivered",
        ),
      ],
      orderItems: [
        OrderItemModel(
          category: "Body Care",
          productName: "Bubblzz Body Lotion", // Replace with actual data
          productImage:
              "assets/images/png/test-product.png", // Replace with actual data
          price: "26901 LE",
          quantity: 1,
        ),
      ],
      subtotal: "26901 LE", // Replace with actual data
      shipping: "30 LE", // Replace with actual data
      total: "26901 LE", // Replace with actual data
      status: _convertStatus(order.status ?? "Processing"),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(orderDetail: orderDetail),
      ),
    );
  }

  OrderDetailStatus _convertStatus(String status) {
    switch (status) {
      case "Processing":
        return OrderDetailStatus.processing;
      case "Delivered":
        return OrderDetailStatus.delivered;
      case "Cancelled":
        return OrderDetailStatus.cancelled;
      default:
        return OrderDetailStatus.processing;
    }
  }
}

enum OrderStatus {
  processing,
  delivered,
  cancelled,
}

class OrderModel {
  final String id;
  final String productName;
  final String productImage;
  final String date;
  final String total;
  final int quantity;
  final OrderStatus status;
  final String description;

  OrderModel({
    required this.id,
    required this.quantity,
    required this.productName,
    required this.productImage,
    required this.date,
    required this.total,
    required this.status,
    required this.description,
  });
}
