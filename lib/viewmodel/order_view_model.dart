import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/order_model.dart';  // Replace with your actual Order model
import 'package:hygi_health/common/globally.dart';  // Assuming this is where authService is

class OrderViewModel extends ChangeNotifier {
  List<Order> _orders = [];
  List<Order> get orders => _orders;

  String _selectedTab = 'Active'; // Default Tab
  String get selectedTab => _selectedTab;

  // Map for status
  Map<String, String> orderStatusMap = {
    'Active': '',        // Empty string for Active status
    'Delivered': '4',    // Delivered status
    'Cancelled': '5',    // Cancelled status
  };

  void setTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
    fetchOrdersForTab(); // Fetch orders based on the selected tab
  }
  // Filter orders based on the selected tab (e.g., 'Active', 'Delivered', 'Cancelled')
  List<Order> get filteredOrders {
    String status = orderStatusMap[_selectedTab] ?? '1'; // Default to '' (Active) if null
    final filtered = _orders.where((order) => 1 == 1).toList();

    return filtered;
  }
  // Filter orders based on the selected tab (e.g., 'Active', 'Delivered', 'Cancelled')

  // Fetch orders from the API using the authService.fetchOrders method
  Future<void> fetchOrdersForTab() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userIdString = prefs.getString('userId'); // Fetch userId as String

      if (userIdString != null) {
        // Convert userId to int
        int userId = int.tryParse(userIdString) ?? 0; // Default to 0 if parsing fails
        String status = orderStatusMap[_selectedTab] ?? ''; // Get the status for the selected tab

        // Fetch orders based on the selected tab (Active, Delivered, Cancelled)
        final fetchedOrders = await authService.fetchOrders(userId, status); // Pass the status correctly
        if (fetchedOrders != null) {
          _orders = fetchedOrders;
        } else {
          _orders = [];
        }
      } else {
        _orders = [];
      }
      notifyListeners();  // Ensure UI updates after fetching
    } catch (error) {
      print('Error fetching orders: $error');
      _orders = [];
      notifyListeners();  // Ensure UI updates after error
    }
  }
}
