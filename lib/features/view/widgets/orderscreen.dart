import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/order_view_model.dart';
import '../order_listView.dart'; // Assuming you have OrderListView

class OrderTabsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderViewModel = Provider.of<OrderViewModel>(context);

    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFF6F6F6), // AppBar background
          elevation: 1,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context); // Handle back navigation
            },
          ),
          title: const Text(
            'My Orders',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              color: Colors.white, // TabBar background color
              child: TabBar(
                onTap: (index) {
                  // Update the selected tab in the ViewModel and fetch the orders for the selected tab
                  String selectedTab = index == 0
                      ? 'Active'
                      : index == 1
                      ? 'Completed'
                      : 'Cancelled';
                  orderViewModel.setTab(selectedTab); // This triggers the tab change
                },
                labelColor: Color(0xFF1A73FC), // Selected tab text color
                unselectedLabelColor: Colors.grey, // Unselected tab text color
                indicatorColor: Color(0xFF1A73FC), // Indicator color for the selected tab
                indicatorWeight: 3, // Thickness of the indicator
                tabs: const [
                  Tab(text: 'Active'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Cancelled'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            OrderListView(orderViewModel: orderViewModel, orderStatus: 'Active'), // Show active orders
            OrderListView(orderViewModel: orderViewModel, orderStatus: 'Completed'), // Show completed orders
            OrderListView(orderViewModel: orderViewModel, orderStatus: 'Cancelled'), // Show cancelled orders
          ],
        ),
      ),
    );
  }
}
