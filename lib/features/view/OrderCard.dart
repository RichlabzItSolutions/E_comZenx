import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/order_model.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/order_view_model.dart';
import '../../routs/Approuts.dart'; // Import your OrderViewModel

class OrderCard extends StatefulWidget {
  final Order order;
  final String activeTab;

  OrderCard({required this.order, required this.activeTab});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controller when no longer needed
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Static image for now, you can replace with the actual image URL if available
    String imageUrl = 'assets/mango.png'; // Static fallback image

    // Check if the "Cancel" button should be visible
    bool showCancelButton = (widget.order.orderStatus == 1 ||
        widget.order.orderStatus == 2 ||
        widget.order.orderStatus == 3);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and Order Details
            Row(
              children: [
                // Displaying static image with a fixed height and width
                Image.asset(
                  imageUrl,
                  height: 50,
                  width: 50,
                ),
                const SizedBox(width: 16),
                // Using Expanded to ensure text occupies the available space
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.order.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              16, // Adjusted font size for better readability
                        ),
                        overflow: TextOverflow.ellipsis, // Handles long names
                      ),
                      Text(
                        '${widget.order.totalItems} * ₹${widget.order.totalAmount}',
                        overflow: TextOverflow.ellipsis,
                        // Handles long amount text
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // Text for order status with color coding for status
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 100, // Limit the max width of the order status
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    // Add padding inside the border
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.order.orderStatus == 1
                            ? Colors.orange // New Order
                            : widget.order.orderStatus == 2
                                ? Colors.blue // Confirmed
                                : widget.order.orderStatus == 3
                                    ? Colors.purple // In Transit
                                    : widget.order.orderStatus == 4
                                        ? Colors.green // Delivered
                                        : Colors.red, // Cancelled
                      ),
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    child: Text(
                      widget.order.orderStatus == 1
                          ? 'New Order'
                          : widget.order.orderStatus == 2
                              ? 'Confirmed'
                              : widget.order.orderStatus == 3
                                  ? 'In Transit'
                                  : widget.order.orderStatus == 4
                                      ? 'Delivered'
                                      : 'Cancelled', // Map status to names
                      style: TextStyle(
                        color: widget.order.orderStatus == 1
                            ? Colors.orange
                            : widget.order.orderStatus == 2
                                ? Colors.blue
                                : widget.order.orderStatus == 3
                                    ? Colors.purple
                                    : widget.order.orderStatus == 4
                                        ? Colors.green
                                        : Colors
                                            .red, // Text color matches the border color
                        fontWeight: FontWeight.bold,
                      ),
                      overflow:
                          TextOverflow.ellipsis, // Ensures no overflow of text
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Information about Transaction and Order Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Date: ${widget.order.orderDate}',
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Action buttons: Cancel and Track Order, aligned to the right
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              // Align the buttons to the right
              children: [
                // Conditionally show the Cancel Button
                if (showCancelButton)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      onPressed: () {
                        // Show confirmation dialog before canceling the order
                        _showCancelConfirmationDialog(context, widget.order);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Track Order Button
                ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? userIdString = prefs.getString('userId');
                    int userId = int.tryParse(userIdString ?? '') ?? 0;
                    // Assuming `widget.order.id` is the orderId and `userId` is available in the context
                    // Replace with actual userId from your context or model
                    final orderId = widget
                        .order.id; // Use the orderId from the current order

                    Navigator.pushNamed(
                      context,
                      AppRoutes.ORDER_DETAILS,
                      // Route for the Order Details screen
                      arguments: {
                        'userId': userId,
                        'orderId': orderId,
                      },
                    );
                    // Add Track order logic here
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    backgroundColor: AppColors.primaryColor, // Background color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'View Order',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Show confirmation dialog before canceling the order with reason input
  void _showCancelConfirmationDialog(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Are you sure you want to cancel this order?'),
              const SizedBox(height: 8),
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason for canceling',
                  hintText: 'Please provide a reason...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Call cancelOrder method from OrderViewModel and pass the reason
                final orderViewModel =
                    Provider.of<OrderViewModel>(context, listen: false);
                String reason = _reasonController.text;
                orderViewModel.cancelOrder(context, order.id,
                    reason); // Pass the reason to the cancelOrder method
                Navigator.of(context).pop(); // Close the dialog after canceling
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
