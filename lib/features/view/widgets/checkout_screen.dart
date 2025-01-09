import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hygi_health/viewmodel/checkout_view_model.dart';

import '../../../common/Utils/dotted_divider.dart';

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CheckoutViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            'assets/backarrow.png', // Replace with your custom image asset path
            width: 18, // Adjust size as needed
            height: 18, // Adjust size as needed
          ),
        ),
        title: const Text(
          'Selected Products',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              viewModel.clearCart();
            },
            child: const Text(
              'Clear cart',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Show loading indicator when fetching cart items
          if (viewModel.isLoading)
            const Center(child: CircularProgressIndicator()),

          // Show error message if any
          if (viewModel.errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                viewModel.errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),

          // Display cart items when available
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.cartItems.length,
              itemBuilder: (context, index) {
                final product = viewModel.cartItems[index]; // Using CartItem model from the ViewModel
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 3,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/mango.png', // Replace with your image path
                                width: 50.0,
                                height: 50.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(product.productTitle),
                            subtitle: Text('${product.quantity} - ${product.unitPrice}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>viewModel.removeCartItem(index),
                            ),
                          ),
                          DottedDivider(
                            dotSize: 1.0,
                            color: Colors.black,
                            spacing: 6.0,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                'Start Date: ',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                             // Text('${product.startDate ?? 'N/A'}'),
                              const VerticalDivider(
                                thickness: 1,
                                width: 24,
                                color: Colors.red,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.date_range, size: 20, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                'End Date: ',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('${product.createdOn ?? 'N/A'}'),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            icon: Icons.repeat,
                            label: 'Frequency',
                            value: product.productTitle,
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            icon: Icons.access_time,
                            label: 'Delivery Time',
                            value: product.productTitle,
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            icon: Icons.location_on,
                            label: 'Address',
                            value: product.couponTitle,
                          ),
                          const SizedBox(height: 16),
                          DottedDivider(
                            dotSize: 1.0,
                            color: Colors.black,
                            spacing: 6.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () =>
                                    viewModel.removeCartItem(index),
                                icon: const Icon(Icons.delete, color: Colors.red),
                                label: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => viewModel.editProduct(index),
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                label: const Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),
          // Payment Summary Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subscription Amount:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '₹355',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Payment:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '₹355',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Wallet Balance:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '₹50',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Place Order Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                viewModel.placeOrder(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1A73FC),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Place Order',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Helper method to build detail rows for product attributes
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '$label: ',
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: value ?? 'N/A',
                  style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
