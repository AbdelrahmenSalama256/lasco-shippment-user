import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lasco/core/constants/app_colors.dart';
import 'package:lasco/core/locale/app_loacl.dart';
import 'package:lasco/features/offers/views/widgets/custom_app_bar.dart';

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

  final List<OrderModel> processingOrders = [
    OrderModel(
      id: "5544848",
      productName: "Bubblzz Body Lotion",
      productImage: "assets/images/png/test-product.png",
      quantity: 4,
      date: "Mon 4 Aug",
      total: "26901 LE",
      status: OrderStatus.processing,
      description: "Cocoa Butter Body Lotion 400ml",
    ),
    OrderModel(
      id: "5544849",
      quantity: 4,
      productName: "Bubblzz Body Lotion",
      productImage: "assets/images/png/test-product.png",
      date: "Mon 4 Aug",
      total: "26901 LE",
      status: OrderStatus.processing,
      description: "Cocoa Butter Body Lotion 400ml",
    ),
  ];

  final List<OrderModel> deliveredOrders = [
    OrderModel(
      id: "5544850",
      productName: "Bubblzz Body Lotion",
      productImage: "assets/images/png/test-product.png",
      date: "Mon 4 Aug",
      total: "26901 LE",
      quantity: 2,
      status: OrderStatus.delivered,
      description: "Cocoa Butter Body Lotion 400ml",
    ),
    OrderModel(
      id: "5544851",
      quantity: 3,
      productName: "Bubblzz Body Lotion",
      productImage: "assets/images/png/test-product.png",
      date: "Mon 4 Aug",
      total: "26901 LE",
      status: OrderStatus.delivered,
      description: "Cocoa Butter Body Lotion 400ml",
    ),
  ];

  final List<OrderModel> cancelledOrders = [
    OrderModel(
      id: "5544852",
      quantity: 2,
      productName: "Bubblzz Body Lotion",
      productImage: "assets/images/png/test-product.png",
      date: "Mon 4 Aug",
      total: "26901 LE",
      status: OrderStatus.cancelled,
      description: "Cocoa Butter Body Lotion 400ml",
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
                Tab(text: "delivered".tr(context)),
                Tab(text: "cancelled".tr(context)),
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

  Widget _buildOrdersList(List<OrderModel> orders) {
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
          date: orders[index].date,
          description: orders[index].description,
          orderId: orders[index].id,
          productName: orders[index].productName,
          quantity: orders[index].quantity,
          total: orders[index].total,
          image: orders[index].productImage,
          onTap: () {
            // Convert OrderModel to OrderDetailModel and navigate
            _navigateToOrderDetails(context, orders[index]);
          },
        );
      },
    );
  }

  void _navigateToOrderDetails(BuildContext context, OrderModel order) {
    // Convert OrderModel to OrderDetailModel
    final orderDetail = OrderDetailModel(
      orderId: order.id,
      orderDate: order.date,
      deliveryAddress: "123 Main St, Cairo, Egypt", // Replace with actual data
      mobileNumber: "+20 101 234 5678", // Replace with actual data
      paymentMethods: [
        PaymentMethodModel(
          title: "Cash on Delivery",
          isCompleted: order.status == OrderStatus.delivered,
        ),
      ],
      orderItems: [
        OrderItemModel(
          category: "Body Care",
          productName: order.productName,
          productImage: order.productImage,
          price: order.total,
          quantity: order.quantity,
        ),
      ],
      subtotal: order.total,
      shipping: "30 LE", // Replace with actual data
      total: order.total,
      status: _convertStatus(order.status),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(orderDetail: orderDetail),
      ),
    );
  }

  OrderDetailStatus _convertStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return OrderDetailStatus.processing;
      case OrderStatus.delivered:
        return OrderDetailStatus.delivered;
      case OrderStatus.cancelled:
        return OrderDetailStatus.cancelled;
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
