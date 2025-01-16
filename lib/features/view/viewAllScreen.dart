import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:hygi_health/common/Utils/app_strings.dart';
import 'package:hygi_health/data/model/category_model.dart'; // Import the Category model
import 'package:provider/provider.dart';
import '../../routs/Approuts.dart'; // Import your routes
import '../../viewmodel/CartProvider.dart';
import 'ProductScreen.dart';

class ViewAllScreen extends StatefulWidget {
  final List<Category> categories; // List of categories to display

  const ViewAllScreen({required this.categories, Key? key}) : super(key: key);

  @override
  _ViewAllScreenState createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  @override
  Widget build(BuildContext context) {
    final categories = widget.categories;
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Handle back navigation
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor, // Background color
              shape: BoxShape.circle, // Makes it circular
            ),
            child: Image.asset(
              'assets/backarrow.png', // Path to your custom icon
              height: 24, // Adjust size as needed
              width: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          AppStrings.allCategories,
          style: const TextStyle(
            color: Colors.black, // Text color
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                      context, AppRoutes.ShoppingCart);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Image.asset(
                    'assets/cart.png', // Replace with your asset image path
                    color: Colors.black,
                    // Optional: Apply color filter to the image
                    width: 38,
                    // Adjust size as needed
                    height: 38,
                  ),
                ),
              ),
              if (cartProvider.cartItemCount > -1)
                Positioned(
                  top: 6,  // Adjust top position to create space between icon and badge
                  right: 6,  // Adjust right position to create space between icon and badge
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: 20,
                    height: 20,
                    child: Center(
                      child: Text(
                        '${cartProvider.cartItemCount}', // Cart item count
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],

          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: categories.isEmpty
            ? const Center(
                child: Text(
                  "No categories available",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category =
                      categories[index]; // Access individual category
                  return ProductCard(
                    category: category,
                    isLoading: false,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.SUBCATEGORY,
                        arguments: {
                          'categoryId': category.categoryId, // Pass category ID
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
