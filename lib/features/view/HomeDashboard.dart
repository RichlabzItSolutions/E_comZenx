import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_strings.dart';
import 'package:hygi_health/features/view/widgets/banner_section_Screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/Utils/app_colors.dart';
import '../../data/model/location_model.dart';
import '../../routs/Approuts.dart'; // Update the import for your routes

import '../../viewmodel/category_view_model.dart';
import '../../viewmodel/location_view_model.dart';
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



class HeaderSection extends StatefulWidget {
  @override
  _HeaderSectionState createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  Location? _selectedLocation;

  @override
  void initState() {
    super.initState();

    // Initialize fetch of locations and the selected location
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final locationViewModel = Provider.of<LocationViewModel>(context, listen: false);

      // Fetch the locations first
      await locationViewModel.fetchLocations();

      // Fetch the selected location from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final locationId = prefs.getInt('location') ?? 0;

      if (locationId != 0) {
        // If locationId is found in SharedPreferences, find the location
        final location = locationViewModel.locations.firstWhere(
                (loc) => loc.id == locationId,
            orElse: () => Location(id: 0, location: "Select Location", clientLocationId: "", status: 0, createdOn: "")
        );
        setState(() {
          _selectedLocation = location;
        });
      } else {
        // Show the location selection popup if no location is set
        showLocationPopup(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationViewModel = Provider.of<LocationViewModel>(context);

    // Handle the case where the location list is empty or still loading
    if (locationViewModel.isLoading) {
      return CircularProgressIndicator();
    }

    if (locationViewModel.errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          'Error: ${locationViewModel.errorMessage}',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return Container(
      color: Colors.grey[200], // Replace with your desired color
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shop Name', // Replace with your actual shop name
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                locationViewModel.locations.isNotEmpty
                    ? DropdownButton<Location>(
                  hint: Text('Select Location'),
                  value: _selectedLocation,
                  onChanged: (Location? newValue) {
                    setState(() {
                      _selectedLocation = newValue;
                    });
                    // Save selected location to SharedPreferences
                    if (newValue != null) {
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setInt('location', newValue.id);
                      });
                    }
                  },
                  items: locationViewModel.locations
                      .map<DropdownMenuItem<Location>>((Location location) {
                    return DropdownMenuItem<Location>(
                      value: location,
                      child: Text(location.location),
                    );
                  }).toList(),
                )
                    : Text('No locations available'),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Product',
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white, width: 1.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    'assets/cart.png', // Replace with your asset image path
                    color: Colors.black,
                    width: 38,
                    height: 38,
                  ),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red, // Replace with your desired color
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: 20,
                      height: 20,
                      child: Center(
                        child: Text(
                          '0', // Replace with dynamic cart item count
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
        ],
      ),
    );
  }

  void showLocationPopup(BuildContext context) {
    final locationViewModel = Provider.of<LocationViewModel>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<LocationViewModel>(
              builder: (context, locationViewModel, child) {
                if (locationViewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (locationViewModel.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(
                      'Error: ${locationViewModel.errorMessage}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select your Location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    locationViewModel.locations.isNotEmpty
                        ? DropdownButtonFormField<Location>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      hint: const Text("Select Location"),
                      value: _selectedLocation,
                      items: locationViewModel.locations.map((Location location) {
                        return DropdownMenuItem<Location>(
                          value: location,
                          child: Text(location.location),
                        );
                      }).toList(),
                      onChanged: (Location? newValue) {
                        setState(() {
                          _selectedLocation = newValue;
                        });
                      },
                    )
                        : const Text('No locations available'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (_selectedLocation != null) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setInt('location', _selectedLocation!.id);

                          // Perform any action with the selected location
                          print('Selected Location: ${_selectedLocation!.location}');
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}







