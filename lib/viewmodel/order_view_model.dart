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
    'Active': '1',        // Set default status as '1' for Active
    'Delivered': '4',    // Delivered status
    'Cancelled': '5',    // Cancelled status
  };

  // Constructor - Call fetchOrdersForTab() initially
  OrderViewModel() {
    fetchOrdersForTab();  // Fetch orders when the view model is initialized
  }

  void setTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
    fetchOrdersForTab(); // Fetch orders based on the selected tab
  }

  // Filter orders based on the selected tab (e.g., 'Active', 'Delivered', 'Cancelled')
  List<Order> get filteredOrders {
    String status = orderStatusMap[_selectedTab] ?? '1'; // Default to '1' (Active) if null
    final filtered = _orders.where((order) => order.orderStatus == int.tryParse(status)).toList();
    return filtered;
  }

  // Fetch orders from the API using the authService.fetchOrders method
  Future<void> fetchOrdersForTab() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userIdString = prefs.getString('userId'); // Fetch userId as String

      if (userIdString != null) {
        // Convert userId to int
        int userId = int.tryParse(userIdString) ?? 0; // Default to 0 if parsing fails
        String status = orderStatusMap[_selectedTab] ?? '1'; // Get the status for the selected tab

        // Fetch orders based on the selected tab (Active, Delivered, Cancelled)
        final fetchedOrders = await authService.fetchOrders(userId, status); // Pass the status correctly
        _orders = fetchedOrders;
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

