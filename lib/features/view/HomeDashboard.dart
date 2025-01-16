import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_strings.dart';
import 'package:hygi_health/features/view/widgets/banner_section_Screen.dart';
import 'package:hygi_health/features/view/widgets/myaccount_screen.dart';
import 'package:hygi_health/features/view/widgets/orderscreen.dart';
import 'package:hygi_health/features/view/widgets/shopping_cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/Utils/app_colors.dart';
import '../../data/model/location_model.dart';
import '../../routs/Approuts.dart'; // Update the import for your routes

import '../../viewmodel/CartProvider.dart';
import '../../viewmodel/category_view_model.dart';
import '../../viewmodel/location_view_model.dart';
import 'ProductScreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0; // Track selected bottom navigation tab
  bool isFetching = false;  // Flag to track if request is in progress

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _handlePageRefresh() async {
    if (isFetching) return; // Prevent multiple requests
    setState(() {
      isFetching = true; // Indicate fetching is in progress
    });

    try {
      final categoryViewModel = Provider.of<CategoryViewModel>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      await Future.wait([
        categoryViewModel.fetchCategories(),
        cartProvider.fetchCartData(),
      ]);
    } catch (e) {
      // Handle error here (e.g., show a snack bar or a message)
      print('Error during fetch: $e');
    } finally {
      setState(() {
        isFetching = false; // Indicate fetching is completed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SafeArea(
        child: _buildBodyContent(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.homeTab,
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset('assets/mycart.png', fit: BoxFit.contain),
            ),
            label: AppStrings.cartTab,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: AppStrings.myOrderTab,
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset('assets/profile.png', fit: BoxFit.contain),
            ),
            label: AppStrings.accountTab,
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent(int index) {
    switch (index) {
      case 0:
        return HomeContent(onRefresh: _handlePageRefresh);
      case 1:
        return ShoppingCartScreen();
      case 2:
        return OrderTabsView();
      case 3:
        return MyAccountScreen();
      default:
        return Center(
          child: Text(
            "Other Page",
            style: TextStyle(
              fontSize: MediaQuery.of(context).textScaleFactor * 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }
}


class HomeContent extends StatefulWidget {
  final Future<void> Function() onRefresh;  // Pass refresh function

  HomeContent({required this.onRefresh});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool isFetching = false;

  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return RefreshIndicator(
      onRefresh: widget.onRefresh,  // Use parent function for refresh
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(),
            BannerSection(),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.allCategories,
                            style: TextStyle(
                              fontSize: 22 * MediaQuery.of(context).textScaleFactor, // Adjust text size
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            AppStrings.byfromAnyCategory,
                            style: TextStyle(
                              fontSize: 14 * MediaQuery.of(context).textScaleFactor,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.VIEWALL,
                            arguments: categoryViewModel.categories,
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              AppStrings.viewAll,
                              style: TextStyle(
                                fontSize: 14 * MediaQuery.of(context).textScaleFactor,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            Image.asset(
                              'assets/right.png',
                              height: 16,
                              width: 16,
                              fit: BoxFit.contain,
                            ),
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
                        : 4,
                    itemBuilder: (context, index) {
                      final category = categoryViewModel.categories[index];
                      return ProductCard(
                        category: category,
                        isLoading: categoryViewModel.isLoading,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.SUBCATEGORY,
                            arguments: {
                              'categoryId': category.categoryId
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
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final locationViewModel = Provider.of<LocationViewModel>(context, listen: false);

    // Check if locations have been fetched already
    if (locationViewModel.locations.isEmpty) {
      await locationViewModel.fetchLocations();
    }

    final prefs = await SharedPreferences.getInstance();
    final locationId = prefs.getInt('location') ?? 0;

    if (locationId != 0) {
      final location = locationViewModel.locations.firstWhere(
              (loc) => loc.id == locationId,
          orElse: () => Location(
              id: 0,
              location: "Select Location",
              clientLocationId: "",
              status: 0,
              createdOn: ""));
      setState(() {
        _selectedLocation = location;
      });
    } else {
      showLocationPopup(context);  // Show location popup if not set
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationViewModel = Provider.of<LocationViewModel>(context);
    final cartProvider = Provider.of<CartProvider>(context); // Get cartProvider here

    if (locationViewModel.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (locationViewModel.errorMessage.isNotEmpty) {
      return Center(
        child: Text('Error: ${locationViewModel.errorMessage}', style: TextStyle(color: Colors.red)),
      );
    }

    return Container(
      color: Colors.grey[200],
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
                  'Shop Name',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                locationViewModel.locations.isNotEmpty
                    ? DropdownButton<Location>(
                  hint: Text('Select Location'),
                  value: _selectedLocation,
                  onChanged: (Location? newValue) {
                    setState(() {
                      _selectedLocation = newValue;
                    });
                    if (newValue != null) {
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setInt('location', newValue.id);
                      });
                    }
                  },
                  items: locationViewModel.locations
                      .map<DropdownMenuItem<Location>>((Location location) {
                    return DropdownMenuItem<Location>(value: location, child: Text(location.location));
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.GLOBAL_SEARCH);
                  },
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: 'Search Product',
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.ShoppingCart);
                    },
                    child: Image.asset(
                      'assets/cart.png',
                      color: Colors.black,
                      width: 38,
                      height: 38,
                    ),
                  ),
                  if (cartProvider.cartItemCount > -1)
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: 20,
                        height: 20,
                        child: Center(
                          child: Text(
                            '${cartProvider.cartItemCount}',
                            style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
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
    final locationViewModel =
    Provider.of<LocationViewModel>(context, listen: false);
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
                      items: locationViewModel.locations
                          .map((Location location) {
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
                        backgroundColor: AppColors.primaryColor,
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
                          print(
                              'Selected Location: ${_selectedLocation!.location}');
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




