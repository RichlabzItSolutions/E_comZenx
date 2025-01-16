import 'package:flutter/material.dart';
import 'package:hygi_health/data/model/product_model.dart';
import '../../routs/Approuts.dart';

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

    return Card(
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
                      print("Add to Cart");

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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF6F6F6), // Gray background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    ),
                    child: Text(
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
    );
  }
}
