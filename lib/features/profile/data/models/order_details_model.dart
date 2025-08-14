import '../../views/order_details_screen.dart';
import 'order_item_model.dart';

class OrderDetailModel {
  final String orderId;
  final String orderDate;
  final String deliveryAddress;
  final String mobileNumber;
  final List<PaymentMethodModel> paymentMethods;
  final List<OrderItemModel> orderItems;
  final String subtotal;
  final String shipping;
  final String total;
  final OrderDetailStatus status;

  OrderDetailModel({
    required this.orderId,
    required this.orderDate,
    required this.deliveryAddress,
    required this.mobileNumber,
    required this.paymentMethods,
    required this.orderItems,
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.status,
  });
}
