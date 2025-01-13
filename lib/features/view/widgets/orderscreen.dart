import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/order_view_model.dart';
import '../order_listView.dart'; // Assuming you have OrderListView

class OrderTabsView extends StatefulWidget {
  @override
  _OrderTabsViewState createState() => _OrderTabsViewState();
}

class _OrderTabsViewState extends State<OrderTabsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);  // Listen for tab changes
  }

  // Function to handle tab changes
  void _onTabChanged() {
    final orderViewModel = Provider.of<OrderViewModel>(context, listen: false);
    String selectedTab = _tabController.index == 0
        ? 'Active'
        : _tabController.index == 1
        ? 'Delivered'  // Ensure the correct tab name is passed for Completed
        : 'Cancelled';
    orderViewModel.setTab(selectedTab);  // This triggers the tab change and API call
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged); // Clean up the listener when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderViewModel = Provider.of<OrderViewModel>(context);
    return Scaffold(
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
              controller: _tabController,
              onTap: (index) {
                // Manually call _onTabChanged when a tab is tapped
                _onTabChanged();
              },
              labelColor: AppColors.primaryColor, // Selected tab text color
              unselectedLabelColor: Colors.grey, // Unselected tab text color
              indicatorColor: Color(0xFF1A73FC), // Indicator color for the selected tab
              indicatorWeight: 3, // Thickness of the indicator
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'Completed'), // Tab name
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OrderListView(orderViewModel: orderViewModel, orderStatus: 'Active'), // Show active orders
          OrderListView(orderViewModel: orderViewModel, orderStatus: 'Delivered'), // Show completed (Delivered) orders
          OrderListView(orderViewModel: orderViewModel, orderStatus: 'Cancelled'), // Show cancelled orders
        ],
      ),
    );
  }
}
