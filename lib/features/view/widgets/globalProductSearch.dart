import 'dart:async'; // Required for Timer
import 'package:flutter/material.dart';
import 'package:hygi_health/common/globally.dart';
import 'package:hygi_health/data/model/product_model.dart';

import '../../../routs/Approuts.dart';
import '../BaseScreen.dart';

class GlobalProductList extends StatefulWidget {
  @override
  _GlobalProductListPageState createState() => _GlobalProductListPageState();
}

class _GlobalProductListPageState extends State<GlobalProductList> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  TextEditingController _searchController = TextEditingController();
  bool isLoading = true;
  Timer? _debounce; // To debounce API calls
  static const int _minSearchLength = 3; // Minimum search characters

  @override
  void initState() {
    super.initState();
    fetchData(""); // Fetch all products initially
    _searchController.addListener(() {
      onSearchChanged();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.length >= _minSearchLength ||
          _searchController.text.isEmpty) {
        filterProducts(_searchController.text);
      }
    });
  }

  void fetchData(String query) async {
    setState(() {
      isLoading = true; // Show loading indicator while fetching
    });

    try {
      ProductFilterRequest payload = ProductFilterRequest(
        categoryId: '',
        subCategoryId: '',
        productTitle: query,
        brand: [],
        priceFrom: '',
        priceTo: '',
        colour: [],
        priceSort: '',
      );

      final fetchedProducts = await authService.fetchProducts(payload);
      setState(() {
        products = fetchedProducts;
        filteredProducts = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      fetchData(""); // Fetch all products if query is empty
    } else {
      fetchData(query); // Fetch products based on query
    }
  }


  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Products',
      // Example cart item count
      showCartIcon: true,
      showShareIcon: false,
      child: Column(
        children: [
          // Search Bar (Always Visible)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                // Trigger search only when user types at least 3 characters
                if (value.length >= 3) {
                  filterProducts(value);
                }
              },
              decoration: InputDecoration(
                hintText: 'Search products (min 3 characters)...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Product List
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredProducts.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/no_products.png', // Optional: Use a "No Products" image
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No products found.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Try searching with a different keyword.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ProductItem(
                  product: filteredProducts[index],
                  isLoading: false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}

class ProductItem extends StatelessWidget {
  final Product product;
  final bool isLoading;
  ProductItem({required this.product, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
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
                        // Quantity Text
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
                  // Add to Cart Button
                  ElevatedButton(
                    onPressed: () {
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
