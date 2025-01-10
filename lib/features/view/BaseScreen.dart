import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';

class BaseScreen extends StatelessWidget {
  final String title; // Title for the AppBar
  final Widget child; // Body content
  final int cartItemCount; // Cart item count for the badge
  final bool showShareIcon; // Whether to show the share icon
  final bool showCartIcon; // Whether to show the cart icon

  const BaseScreen({
    Key? key,
    required this.title,
    required this.child,
    this.cartItemCount = 0,
    this.showCartIcon = true,
    this.showShareIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:AppColors.toolbarbackgound,
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Handles back navigation
          },
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Circular shape
            ),
            child: Image.asset(
              'assets/backarrow.png', // Path to custom icon
              height: 24, // Adjust size as needed
              width: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black, // Title text color
          ),
        ),
        actions: [
          // Share icon with border color #1A73FC
          if (showShareIcon)
            IconButton(
              icon: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the icon
                  shape: BoxShape.circle, // Circular shape
                  border: Border.all(
                    color: Colors.white, // Border color set to #1A73FC
                    width: 2, // Border width
                  ),
                ),
                child: Icon(
                  Icons.share,
                  color: AppColors.primaryColor, // Icon color to match the border
                ),
              ),
              onPressed: () {
                print("Share clicked");
              },
            ),
          // Cart icon with badge
          if (showCartIcon)
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.black, // Cart icon color
                  ),
                  onPressed: () {
                    print("Cart clicked");
                  },
                ),
                if (cartItemCount > 0)
                  Positioned(
                    right: 8, // Position the badge at the top-right of the icon
                    top: 8,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red, // Badge background color
                      child: Text(
                        '$cartItemCount', // Number of items in the cart
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
      body: child,
    );
  }
}
