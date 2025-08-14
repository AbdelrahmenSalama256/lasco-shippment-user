class OrderItemModel {
  final String category;
  final String productName;
  final String productImage;
  final String price;
  final int quantity;

  OrderItemModel({
    required this.category,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
  });
}
