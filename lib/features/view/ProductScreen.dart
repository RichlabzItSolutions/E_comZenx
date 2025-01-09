import 'package:flutter/material.dart';
import '../../routs/Approuts.dart';
import 'package:hygi_health/data/model/category_model.dart'; // Import the Category model

class ProductCard extends StatelessWidget {
  final Category category; // Pass the entire category object
  final bool isLoading; // A flag to indicate loading state
  final VoidCallback onTap;
  const ProductCard({
    required this.category, // Accept a Category object as a parameter
    required this.isLoading, // Indicate if the product is loading
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      color: const Color(0xFFF6F6F6), // Set the background color to #F6F6F6
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? const CircularProgressIndicator() // Show loading indicator if true
                  : category.appIcon != null && category.appIcon.isNotEmpty
                  ? Image.network(
                category.appIcon, // Dynamically display the category icon
                width: 67,
                height: 67,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.category, // Default icon if loading fails
                    size: 67,
                    color: Color(0xFF1A73FC),
                  );
                },
              )
                  : const Icon(
                Icons.category, // Default icon if no icon is provided
                size: 67,
                color: Color(0xFF1A73FC),
              ),
              const SizedBox(height: 16), // Space between the icon and the title
              isLoading
                  ? const SizedBox.shrink() // No title when loading
                  : Text(
                category.categoryTitle, // Display the category title dynamically
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500, // Optional styling
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
