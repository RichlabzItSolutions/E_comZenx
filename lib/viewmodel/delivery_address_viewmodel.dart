import 'package:flutter/cupertino.dart';
import 'package:hygi_health/common/globally.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/DeliveryAddress.dart';
import '../data/model/PaymentMethod.dart';

class DeliveryViewModel extends ChangeNotifier {
  // List of delivery addresses
  List<DeliveryAddress> _deliveryAddresses = [];
  // Selected delivery address index
  int _selectedAddressIndex = 0;

  // Payment methods
  List<PaymentMethod> _paymentMethods = [
    PaymentMethod(type: "Cash", isSelected: true),
    // PaymentMethod(type: "Online Payment",  isSelected: false),
  ];

  // Getters
  List<DeliveryAddress> get deliveryAddresses => _deliveryAddresses;
  int get selectedAddressIndex => _selectedAddressIndex;
  List<PaymentMethod> get paymentMethods => _paymentMethods;

  // Load delivery addresses dynamically from API
  Future<void> loadDeliveryAddresses() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userIdString = prefs.getString('userId');
      int userId = int.tryParse(userIdString ?? '') ?? 0;

      if (userId != 0) {
        _deliveryAddresses = await authService.fetchAddressesByUserId(userId); // Fetch data from API by userId
        notifyListeners(); // Notify listeners when the data is fetched
      } else {
        print("User ID is not available.");
      }
    } catch (e) {
      print("Error loading delivery addresses: $e");
    }
  }

  // Select a payment method
  void selectPaymentMethod(int index) {
    for (int i = 0; i < _paymentMethods.length; i++) {
      _paymentMethods[i] = _paymentMethods[i].copyWith(isSelected: i == index);
    }
    notifyListeners();
  }

  // Select a delivery address
  void selectDeliveryAddress(int index) {
    _selectedAddressIndex = index;
    notifyListeners();
  }
}

extension PaymentMethodCopyWith on PaymentMethod {
  PaymentMethod copyWith({bool? isSelected}) {
    return PaymentMethod(
      type: this.type,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
