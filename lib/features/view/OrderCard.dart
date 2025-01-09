import 'package:flutter/material.dart';
import '../../data/model/order_model.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    // Static image for now, you can replace with the actual image URL if available
    String imageUrl = 'assets/mango.png'; // Static fallback image

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
                        order.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16, // Adjusted font size for better readability
                        ),
                        overflow: TextOverflow.ellipsis, // Handles long names
                      ),
                      Text(
                        '1x ₹${order.totalAmount}',
                        overflow: TextOverflow.ellipsis, // Handles long amount text
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // Text for order status with color coding for status
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 100,  // Limit the max width of the order status
                  ),
                  child: Text(
                    order.orderStatus.toString(),
                    style: TextStyle(
                      color: order.orderStatus.toString() == 'Active'
                          ? Colors.green
                          : order.orderStatus.toString() == 'Completed'
                          ? Colors.blue
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis, // Ensures no overflow of text
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
                    Text('Transaction ID: ${order.createdOn}', style: TextStyle(fontSize: 12)),
                    Text('Order Date: ${order.orderDate}', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Action buttons: Cancel and Track Order, aligned to the right
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align the buttons to the right
              children: [
                // Cancel Button
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton(
                    onPressed: () {
                      // Add Cancel logic here
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  onPressed: () {
                    // Add Track order logic here
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    primary: Color(0xFF1A73FC), // Background color
                    onPrimary: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Track Order',
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
}
