import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hygi_health/data/model/product_view.dart';
import 'package:provider/provider.dart';
import 'package:hygi_health/viewmodel/product_view_model.dart';
import 'package:hygi_health/features/view/BaseScreen.dart';
import 'package:hygi_health/routs/Approuts.dart';

class ProductViewmodelScreen extends StatefulWidget {
  @override
  _ProductViewmodelScreenState createState() => _ProductViewmodelScreenState();
}

class _ProductViewmodelScreenState extends State<ProductViewmodelScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;
  int _quantity = 1;
  final double _unitPrice = 85.0;
  final double _originalPrice = 100.0;
  late String productId;
  late String variantId;
  // Increase quantity and update UI immediately
  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }
  // Decrease quantity and update UI immediately
  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }
  double get totalPrice => _quantity * _unitPrice;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });


  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Ensure that you only access context-dependent operations after dependencies have been set up.
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    if (arguments != null) {
      // Ensure arguments are parsed as integers
      final productIdString = arguments['productId'];
      final variantIdString = arguments['variantId'];
      if (productIdString != null && variantIdString != null) {
        final productId = (productIdString);
        final variantId = (variantIdString);
        // Initialize the ProductViewModel and fetch product details
        final viewModel = Provider.of<ProductViewModel>(context, listen: false);
        viewModel.fetchProductDetails(productId , variantId);
            } else {
        // Handle missing arguments if necessary
        print("Missing productId or variantId");
      }
    }
  }
  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final product = viewModel.product;
        if (product == null) {
          return Scaffold(
            body: Center(child: Text("Product not found")),
          );
        }
        return BaseScreen(
          title: product.productTitle,
          cartItemCount: 3,
          showCartIcon: false,
          showShareIcon: true,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: Colors.grey,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Color(0xFFF6F6F6),
                    child: Column(
                      children: [
                        // PageView.builder for images
                        Container(
                          margin: EdgeInsets.only(top: 80, right: 80, left: 80),
                          color: Color(0xFFF6F6F6),
                          height: 180,
                          child: Center(
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: product.images.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 180,
                                  child: Image.network(
                                    product.images[index].url, // Use the image URL here
                                    fit: BoxFit.contain,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              product.images.length,
                                  (index) => Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentPage == index
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 12), // Add space between title and next section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productTitle,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold, // Make the product title bold
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8), // Add space between the title and price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "₹${product.sellingPrice}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "₹${product.mrp}",
                            style: const TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16), // Add space between price and product details
                      const Text(
                        "Product Details",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold, // Make "Product Details" bold
                        ),
                      ),
                      const SizedBox(height: 4), // Space between title and description
                      Text(product.description),
                      const SizedBox(height: 16), // Space after description
                      const Text(
                        "Delivery",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold, // Make "Delivery" bold
                        ),
                      ),
                      const SizedBox(height: 4), // Space between delivery title and content
                      Text(product.description),
                      const SizedBox(height: 16), // Add space after delivery section
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Image.asset('assets/person.png', width: 40, height: 40),
                      //     const SizedBox(width: 8),
                      //     Text(
                      //       "Free Delivery by Hygihealth Order by 7.30 PM",
                      //       style: const TextStyle(fontSize: 14, color: Colors.green),
                      //     ),
                      //     const SizedBox(width: 8),
                      //   ],
                      // ),
                      const SizedBox(height: 16), // Space after delivery information
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  print("Buy Once tapped");
                                  _showProductDetailsBottomSheet(context, product);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: Colors.green),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: Text(
                                  "Buy Once",
                                  style: TextStyle(
                                    color: Color(0xFF1A73FC),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              ,
            ],
          ),
        );
      },


    );
  }


  void _showProductDetailsBottomSheet(BuildContext context, ProductView product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        double unitPrice = product.sellingPrice;
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: product.images.map((imageData) {
                              if (imageData.isMainImage) {
                                return Image.network(
                                  imageData.url,
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
                                );
                              }
                              return const SizedBox();
                            }).toList(),
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
                                    Flexible(
                                      child: Text(
                                        '₹${product.mrp}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.red,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        '₹$totalPrice',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
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
                                      color:Color(0xFF1A73FC),
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
                                      color:Color(0xFF1A73FC),
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
                                      color: Color(0xFF1A73FC),
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

                      // Time Spent Section
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
                          Navigator.pushNamed(
                              context,
                              AppRoutes.ShoppingCart);
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
                        backgroundColor: Color(0xFF1A73FC),
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










  void _showDeliverySlotChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Delivery Slot'),
        content: const Text('Slot change functionality goes here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle slot change
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Address'),
        content: const Text('Address edit functionality goes here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle address edit
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }




}
