import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:hygi_health/routs/Approuts.dart';
import 'package:provider/provider.dart';
import '../../../common/Utils/dotted_divider.dart';
import 'package:hygi_health/viewmodel/shopping_cart_view_model.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch cart items when the screen is initialized
    final viewModel = Provider.of<ShoppingCartViewModel>(context, listen: false);
    viewModel.fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ShoppingCartViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Handles back navigation
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle, // Circular shape
            ),
            child: Image.asset(
              'assets/backarrow.png', // Path to custom icon
              height: 24,
              width: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: const Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: viewModel.isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : viewModel.items.isEmpty
          ? Center(child: Text('No items in the cart'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.items.length,
              itemBuilder: (context, index) {
                final item = viewModel.items[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background to white
                    border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        spreadRadius: 2,
                        offset: const Offset(0, 2), // Shadow direction
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Image.network(item.mainImageUrl,
                            width: 60, height: 60, fit: BoxFit.cover),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productTitle,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    "₹${item.unitPrice}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "₹${item.totalAmount}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            // Plus, Minus, and Quantity Container
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      viewModel.decrementQuantity(index);
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.remove,
                                          color: Colors.white, size: 15),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      viewModel.incrementQuantity(index);
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.add,
                                          color: Colors.white, size: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Remove Button
                            TextButton(
                              onPressed: () =>
                                  _showRemoveConfirmationDialog(context, index, viewModel),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red, // Text color
                              ),
                              child: const Text(
                                'Remove',
                                style: TextStyle(
                                  fontSize: 16,
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
              },
            ),
          ),
          DottedDivider(
            dotSize: 1.0,
            color: Colors.black,
            spacing: 6.0,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSummaryRow(
                    'No. of items:', viewModel.totalItems.toString()),
                _buildSummaryRow('Sub Total:', '₹${viewModel.subTotal}'),
                _buildSummaryRow('Delivery Charges:', '₹${viewModel.deliveryCharges}'),
                _buildSummaryRow('Discount:', '₹${viewModel.discount}', textColor: Colors.red),
                // Display the total GST
                // _buildSummaryRow('GST:', '₹${viewModel.gstRate.toStringAsFixed(2)}'),

                DottedDivider(
                  dotSize: 1.0,
                  color: Colors.black,
                  spacing: 6.0,
                ),
                _buildSummaryRow('Total Payment:', '₹${viewModel.finalAmount}',
                    isBold: true),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.DeliveryAddress);
                // Handle order placement
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1A73FC),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Place Order',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {Color textColor = Colors.black, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveConfirmationDialog(
      BuildContext context, int index, ShoppingCartViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Remove Item',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to remove this item from your cart?',
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            // Confirm Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                viewModel.removeItem(index); // Remove the item
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

