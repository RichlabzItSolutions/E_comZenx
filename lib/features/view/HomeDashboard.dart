import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_strings.dart';
import 'package:hygi_health/features/view/widgets/banner_section_Screen.dart';
import 'package:provider/provider.dart';
import '../../common/Utils/app_colors.dart';
import '../../routs/Approuts.dart'; // Update the import for your routes

import '../../viewmodel/category_view_model.dart';
import 'ProductScreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  late Timer _timer;
  late List<DateTime> daysOfWeek;
  DateTime selectedDate = DateTime.now();
  // Bottom Navigation Bar
  int _selectedIndex = 0; // To track the selected tab

  // Handle navigation bar item tap
  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 4) { // My Account tab
        Navigator.pushNamed(context, AppRoutes.MyAccount);
      }

    if(index ==3)
      {
        Navigator.pushNamed(context, AppRoutes.MYORDERS);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SafeArea(
        child: _selectedIndex == 0
            ? HomeContent()

            : Center(
          child: Text(
            _getPageMessage(_selectedIndex), // Get message dynamically
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        selectedItemColor:AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.homeTab,
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                'assets/mycart.png', // Path to your custom icon
                fit: BoxFit.contain,
              ),
            ),
            label: AppStrings.cartTab,
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                'assets/wallet.png', // Path to your custom icon
                fit: BoxFit.contain,
              ),
            ),
            label: AppStrings.walletTab,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: AppStrings.myOrderTab,
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                'assets/profile.png', // Path to your custom icon
                fit: BoxFit.contain,
              ),
            ),
            label: AppStrings.accountTab,
          ),
        ],
      ),
    );
  }

  // Helper function to return a message based on the selected index
  String _getPageMessage(int index) {
    switch (index) {
      case 1:
        return "My Cart Page";
      case 2:
        return "Wallet Page";

      default:
        return "Other Page";
    }
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}
class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    // Accessing CategoryViewModel using Provider
    final categoryViewModel = Provider.of<CategoryViewModel>(context);

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh categories
        print("Refreshing categories...");
        await categoryViewModel.fetchCategories();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section and Banner Section (You can adjust these as per your design)
            HeaderSection(),
            BannerSection(),
            Container(
              color: Colors.white, // Apply white background
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Subtitle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.allCategories,
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          SizedBox(height: 4),
                          Text(
                            AppStrings.byfromAnyCategory,
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Pass the categories to ViewAllScreen when 'View All' is clicked
                          Navigator.pushNamed(
                            context,
                            AppRoutes.VIEWALL,
                            arguments: categoryViewModel.categories, // Pass all categories to the next screen
                          );

                        },
                        child: Row(
                          children: [
                            Text(AppStrings.viewAll, style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold, color:AppColors.primaryColor)),
                            Image.asset('assets/right.png', height: 16, width: 16, fit: BoxFit.contain),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  categoryViewModel.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                  itemCount: categoryViewModel.categories.length < 4
                  ? categoryViewModel.categories.length
                    : 4, // Show only first 4 categories,
                    itemBuilder: (context, index) {
                      final category = categoryViewModel.categories[index];

                      return ProductCard(
                        category: category,
                        isLoading: categoryViewModel.isLoading,
                        onTap: () {
                          print("Navigating to Category: ${category.categoryTitle}");
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.secondaryColor,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container for row with increased height
          Container(
            height: 80, // Increase the height of the row here
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Shop Name with bold styling instead of image
                Text(
                  'Shop Name',  // Replace with your actual shop name
                  style: TextStyle(
                    fontSize: 24,  // Adjust the font size as needed
                    fontWeight: FontWeight.bold, // Make the shop name bold
                    color: Colors.black,  // Set the text color
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.black),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Hyderabad',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Row for search bar and shopping cart icon
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: AppStrings.searchProduct,
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white, width: 1.5), // White outline
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white, width: 2), // White outline when focused
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white, width: 1.5), // White outline when not focused
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 10), // Spacing between the TextField and shopping cart icon
              Stack(
                clipBehavior: Clip.none, // Allow badge to overflow and not get clipped
                children: [
                  Image.asset(
                    'assets/cart.png', // Replace with your asset image path
                    color: Colors.black, // Optional: To apply color filter to the image if needed
                    width: 38,  // Adjust size of the image as needed
                    height: 38, // Adjust size of the image as needed
                  ),
                  Positioned(
                    top: -6, // Position badge slightly above the cart
                    right: -6, // Adjust horizontal position to prevent it from being cut off
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.errorColor, // Badge color
                        borderRadius: BorderRadius.circular(12), // Ensure the badge is rounded
                      ),
                      width: 20, // Fixed width of the badge
                      height: 20, // Fixed height of the badge
                      child: Center(
                        child: Text(
                          '0', // Cart item count
                          style: TextStyle(
                            fontSize: 12, // Adjust font size as needed
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
        ],
      ),
    );


  }
}






