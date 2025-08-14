import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../profile/data/models/order_details_model.dart';
import '../order_comfrimation_screen.dart';
import '../widgets/address_bottom_sheet.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  final TextEditingController promoController = TextEditingController();
  String selectedPaymentMethod = 'full';
  double subtotal = 1000.0;
  double shipping = 50.0;
  double discount = 0.0;
  AddressModel? currentAddress;
  String phoneNumber = "+201111111111";
  List<Map<String, dynamic>> orderItems = [
    {
      'name': 'Bubblzz Body Lotion',
      'category': 'Skin Care',
      'price': 500.0,
      'quantity': 2,
      'deliveryDate': 'Deliver between 10 Aug, 12 Aug',
      'imageUrl': 'assets/images/png/test-product.png',
    },
    {
      'name': 'Bubblzz Body Lotion',
      'category': 'Skin Care',
      'price': 500.0,
      'quantity': 2,
      'deliveryDate': 'Deliver between 10 Aug, 12 Aug',
      'imageUrl': 'assets/images/png/test-product.png',
    },
    {
      'name': 'Bubblzz Body Lotion',
      'category': 'Skin Care',
      'price': 500.0,
      'quantity': 2,
      'deliveryDate': 'Deliver between 10 Aug, 12 Aug',
      'imageUrl': 'assets/images/png/test-product.png',
    },
  ];
  String? orderId;
  String? orderDate;

  double get total => subtotal + shipping - discount;

  void updatePaymentMethod(String method) {
    selectedPaymentMethod = method;
    emit(CheckoutUpdated());
  }

  void applyPromoCode(String code) {
    if (code.toLowerCase() == 'save10') {
      discount = 100.0;
    } else {
      discount = 0.0;
    }
    emit(CheckoutUpdated());
  }

  void handleConfirmOrder(BuildContext context) {
    // Generate order ID and date
    orderId = "123456";
    orderDate = "Mon 4 August, 2025";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CheckoutCubit(),
          child: OrderConfirmationScreen(),
        ),
      ),
    );
    emit(CheckoutUpdated());
  }

  void showAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddressBottomSheet(
        onAddressSaved: (address) {
          currentAddress = address;
          emit(CheckoutUpdated());
        },
      ),
    );
  }

  void showPhoneBottomSheet(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Phone Number'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter phone number',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            phoneNumber = value;
            emit(CheckoutUpdated());
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              emit(CheckoutUpdated());
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  OrderDetailModel? orderDetail;

  void setOrderDetails(OrderDetailModel orderDetail) {
    this.orderDetail = orderDetail;
    emit(CheckoutUpdated()); // Notify listeners about the change
  }

  @override
  Future<void> close() {
    promoController.dispose();
    return super.close();
  }
}
