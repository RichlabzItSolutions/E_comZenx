import 'package:flutter/material.dart';
import 'package:hygi_health/data/model/product_model.dart';
import 'package:provider/provider.dart';
import '../../common/Utils/app_colors.dart';
import '../../routs/Approuts.dart';
import '../../viewmodel/product_view_model.dart';

// class ProductListPage extends StatelessWidget {
//   final List<Product> products; // List of products
//
//   ProductListPage({required this.products});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Products'),
//       ),
//       body: products.isEmpty
//           ? Center(
//               child: Text(
//                 'No products found.',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             )
//           : ListView.builder(
//               itemCount: products.length,
//               itemBuilder: (context, index) {
//                 return ProductItem(
//                   product: products[index],
//                   isLoading: false, // Assuming the products are already loaded
//                 );
//               },
//             ),
//     );
//   }
// }

class ProductItem extends StatelessWidget {
  final Product product;
  final bool isLoading;
  ProductItem({required this.product, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    // Checking if there are any variants and setting the variant and image
    final variant = product.variants.isNotEmpty ? product.variants[0] : null;
    final imageUrl = variant != null && variant.images.isNotEmpty
        ? variant.images[0].url
        : null;

    return GestureDetector(
        onTap: () {
      // Handle the card tap event here
      Navigator.pushNamed(
        context,
        AppRoutes.productviewmodel,
        arguments: {
          'productId': product.productId.toString(),
          'variantId': variant != null
              ? variant.variantId.toString()
              : '',
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
                  // Centered Product Image
                  Container(
                    height: 80,
                    width: 80,
                    child: Align(
                      alignment: Alignment.center,
                      child: isLoading
                          ? CircularProgressIndicator()
                          : imageUrl != null
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                )
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
                        // Product Title
                        isLoading
                            ? CircularProgressIndicator()
                            : Text(
                                product.productTitle,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        const SizedBox(height: 4),
                        // Quantity Text (Assuming 1 Piece is static for now)
                        isLoading
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
                        // Price and MRP
                        isLoading
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
                  // Buy Once Button
                  ElevatedButton(
                    onPressed: () {
                      // Debug log
                      print("Add to Cart Button Clicked");
                      //

                      // Fetching the ProductViewModel instance
                      final viewModel = Provider.of<ProductViewModel>(context, listen: false);

                      // Ensuring variant and imageUrl are not null before proceeding
                      if (variant != null) {
                        // Fetch product details using ViewModel
                        viewModel.fetchProductDetails(
                          product.productId.toString(),
                          variant.variantId.toString(),
                        );
                        // Show the product details bottom sheet
                        _showProductDetailsBottomSheet(context, variant, imageUrl!,product);
                      } else {
                        print("Variant or Image URL is null. Cannot proceed.");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF6F6F6), // Gray background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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

                  // Share Button
                  // Container(
                  //   padding: EdgeInsets.all(6),
                  //   decoration: BoxDecoration(
                  //     color: Color(0xFFEEF7FF),
                  //     shape: BoxShape.circle,
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black.withOpacity(0.2),
                  //         spreadRadius: 2,
                  //         blurRadius: 5,
                  //         offset: Offset(0, 2),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Icon(
                  //     Icons.share,
                  //     size: 16,
                  //     color: Color(0xFF1A73FC),
                  //   ),
                  // ),


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
      BuildContext context, Variant variant, String imageUrl, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        double unitPrice = variant.sellingPrice;
        int quantity = 1;

        return StatefulBuilder(
          builder: (context, setState) {
            double totalPrice = quantity * unitPrice;

            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Row(
                        children: [
                          // Image Section with error handling
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8), // Rounded corners
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
                            flex: 2,
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
                                      style: TextStyle(
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
                          const Spacer(),
                          // Quantity controls
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.remove, color: Colors.white, size: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    '$quantity',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Divider Section
                      const Divider(height: 20),

                      // Total and Add to Cart Button
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
                                  final success = await viewModel.addToCart(context, quantity);
                                  if (success) {
                                    Navigator.pushNamed(context, AppRoutes.ShoppingCart);
                                    // Dismiss the bottom sheet only on success
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
                      const SizedBox(height: 16),
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
