import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/Utils/app_colors.dart';
import '../../data/model/product_model.dart';
import '../../routs/Approuts.dart';
import '../../viewmodel/product_view_model.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  final bool isLoading;

  ProductItem({required this.product, this.isLoading = false});
  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  late TextEditingController quantityController;
  int quantity = 1;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    quantityController = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final variant = widget.product.variants.isNotEmpty ? widget.product.variants[0] : null;
    final imageUrl = variant != null && variant.images.isNotEmpty
        ? variant.images[0].url
        : null;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.productviewmodel,
          arguments: {
            'productId': widget.product.productId.toString(),
            'variantId': variant != null ? variant.variantId.toString() : '',
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      child: Align(
                        alignment: Alignment.center,
                        child: widget.isLoading
                            ? CircularProgressIndicator()
                            : imageUrl != null
                            ? Image.network(imageUrl, fit: BoxFit.cover)
                            : Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.isLoading
                              ? CircularProgressIndicator()
                              : Text(
                            widget.product.productTitle,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          widget.isLoading
                              ? CircularProgressIndicator()
                              : Text(
                            "1 Piece",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          widget.isLoading
                              ? CircularProgressIndicator()
                              : Row(
                            children: [
                              Text(
                                variant != null
                                    ? "₹ ${variant.sellingPrice}"
                                    : "₹ 0",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                variant != null
                                    ? "₹ ${variant.mrp}"
                                    : "₹ 0",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final viewModel = Provider.of<ProductViewModel>(
                          context,
                          listen: false,
                        );

                        if (variant != null) {
                          viewModel.fetchProductDetails(
                            widget.product.productId.toString(),
                            variant.variantId.toString(),
                          );
                          _showProductDetailsBottomSheet(
                            context,
                            variant,
                            imageUrl!,
                            widget.product,
                          );
                        } else {
                          print("Variant or Image URL is null. Cannot proceed.");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF6F6F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                      ),
                      child: const Text(
                        "Add to Cart",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showProductDetailsBottomSheet(
      BuildContext context,
      Variant variant,
      String imageUrl,
      Product product,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            double unitPrice = variant.sellingPrice;
            double totalPrice = quantity * unitPrice;

            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Product Image, Title, Price, and Quantity Section in a Row
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/placeholder.png',
                                  width: 80,
                                  height: 80,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productTitle,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '1 Piece(s)',
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '₹${variant.mrp}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '₹${variant.sellingPrice}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Quantity controls in the same row as image and title
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                        quantityController.text = quantity.toString();
                                        errorMessage = null; // Clear error
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.remove, color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  child: TextField(
                                    controller: quantityController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      errorText: errorMessage,
                                    ),
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          errorMessage = 'Quantity cannot be empty';
                                        });
                                        return;
                                      }

                                      final int? newQuantity = int.tryParse(value);
                                      if (newQuantity == null || newQuantity <= 0) {
                                        setState(() {
                                          errorMessage = 'Enter a valid quantity';
                                        });
                                      } else {
                                        setState(() {
                                          errorMessage = null;
                                          quantity = newQuantity;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      quantity++;
                                      quantityController.text = quantity.toString();
                                      errorMessage = null;
                                    });
                                  },
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.add, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20), // Divider after Quantity controls

                      // Total and Add to Cart Button Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              Text(
                                '₹$totalPrice',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Consumer<ProductViewModel>(
                            builder: (context, viewModel, child) {
                              return ElevatedButton.icon(
                                onPressed: viewModel.isLoading
                                    ? null
                                    : () async {
                                  final success =
                                  await viewModel.addToCart(context, quantity);
                                  if (success) {
                                    Navigator.pop(context); // Dismiss the bottom sheet
                                  }
                                },
                                icon: viewModel.isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Icon(Icons.shopping_cart, size: 18, color: Colors.white),
                                label: viewModel.isLoading
                                    ? const Text('')
                                    : const Text('Add to cart', style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                  backgroundColor: AppColors.primaryColor,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


}
