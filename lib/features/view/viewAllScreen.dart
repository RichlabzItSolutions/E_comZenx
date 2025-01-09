import 'package:flutter/material.dart';
import 'package:hygi_health/data/model/category_model.dart'; // Import the Category model
import '../../routs/Approuts.dart'; // Import your routes
import 'ProductScreen.dart'; // Import your ProductCard widget

class ViewAllScreen extends StatefulWidget {
  final List<Category> categories; // List of categories to display

  // Constructor to accept a list of categories
  const ViewAllScreen({required this.categories});

  @override
  _ViewAllScreenState createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  @override
  Widget build(BuildContext context) {
    // Ensure correct usage of the passed categories
    final categories = widget.categories;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Handle back navigation
          },
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF28A745), // Background color
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
          "All Categories",
          style: TextStyle(
            color: Colors.white, // Text color
          ),
        ),
        backgroundColor: Colors.green,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white, // Cart icon color
                ),
                onPressed: () {
                  print("Cart clicked");
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red, // Badge background color
                  child: Text(
                    '3', // Number of items in the cart
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white, // Text color for the number
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
            ? Center(child: Text("No categories available"))
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index]; // Access individual category
            return ProductCard(
              category: category,
              isLoading: false,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.SUBCATEGORY,
                  arguments: {
                    'categoryId': category.categoryId // Access category ID
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
