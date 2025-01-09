import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hygi_health/features/view/widgets/banner_section_Screen.dart';
import 'package:provider/provider.dart';
import '../../routs/Approuts.dart'; // Update the import for your routes
import '../../viewmodel/category_view_model.dart';
import 'ProductScreen.dart';
import 'category_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;
  late List<DateTime> daysOfWeek;
  DateTime selectedDate = DateTime.now();

  // Bottom Navigation Bar
  int _selectedIndex = 0; // To track the selected tab

  @override
  void initState() {
    super.initState();
    _generateWeekDays();

  }

  // Generate the days of the current week starting from Monday
  void _generateWeekDays() {
    final DateTime today = DateTime.now();
    final DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1)); // Monday as the first day
    daysOfWeek = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

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
            ? HomeContent(
          daysOfWeek: daysOfWeek,
          selectedDate: selectedDate,
          onDateSelected: (date) {
            setState(() {
              selectedDate = date;
            });
          },
        )
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
        selectedItemColor:Color(0xFF1A73FC),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
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
            label: "My Cart",
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
            label: "Wallet",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "My Orders",
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
            label: "Account",
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
  final List<DateTime> daysOfWeek;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const HomeContent({
    required this.daysOfWeek,
    required this.selectedDate,
    required this.onDateSelected,
  });

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
                            'All Categories',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Buy from any category',
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
                            Text('View All', style: TextStyle(fontSize: 14, color: Colors.green)),
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
      color: Color(0xFFE1F5D5),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row for logo and location
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/logo.png', // Replace with your logo image
                height: 100, // Fixed height
                width: 150,  // Adjust width as needed
                fit: BoxFit.contain,  // Ensures the image scales correctly without distortion
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
          SizedBox(height: 20),
          // Row for search bar and shopping cart icon
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for Idly Batter',
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
                        color: Colors.red, // Badge color
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
              )






              ,
            ],
          ),
        ],
      ),
    );
  }
}

class WeeklyCalendar extends StatelessWidget {
  final List<DateTime> daysOfWeek;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const WeeklyCalendar({
    required this.daysOfWeek,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFE1F5D5), // Background color for the container
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          // Week Calendar Section
          SizedBox(
            height: 100, // Height for the calendar
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: daysOfWeek.length,
              itemBuilder: (context, index) {
                final DateTime currentDay = daysOfWeek[index];

                // Format day and date
                final String dayName = [
                  'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
                ][currentDay.weekday - 1];
                final String dateNumber = currentDay.day.toString();

                // Check if the current day is today
                final bool isToday = currentDay.day == DateTime.now().day &&
                    currentDay.month == DateTime.now().month &&
                    currentDay.year == DateTime.now().year;

                // Check if this date is selected
                final bool isSelected = currentDay.year == selectedDate.year &&
                    currentDay.month == selectedDate.month &&
                    currentDay.day == selectedDate.day;

                return GestureDetector(
                  onTap: () {
                    onDateSelected(currentDay); // Trigger the callback on date tap
                  },
                  child: Container(
                    width: 80, // Fixed width for each day item
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: isToday
                          ? Border.all(color: Colors.orange, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          dateNumber,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        if (isToday)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              "Today",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          // Status Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Delivered Status
                _statusWidget("Delivered", Colors.green),
                // Upcoming Status
                _statusWidget("Upcoming", Colors.blue),
                // Vacation Status
                _statusWidget("Vacation", Colors.orange),
                // Hold Status
                _statusWidget("Hold", Colors.red),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Single Row with White Background, Padding, and Rounded Border
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white, // White background for the row
              borderRadius: BorderRadius.circular(16), // Rounded corners
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            // Padding for left and right
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Calendar Icon and Text
                Row(
                  children: [
                    Image.asset(
                      'assets/calendar.png', // Replace with your logo image
                      height: 24, // Fixed height
                      width: 24,  // Adjust width as needed
                      fit: BoxFit.contain,  // Ensures the image scales correctly without distortion
                    ),
                    SizedBox(width: 8),
                    Text(
                      'There is no Order Scheduled for \n this Today',
                      style: TextStyle(fontSize: 13, color: Colors.black),
                      softWrap: true, // Allow text to wrap to the next line
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                // Add Product Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.CategoryViewAll);
                    // Handle adding product functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Background color
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  ),
                  child: Text(
                    ' + Add Product',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper widget to create status indicators with text
Widget _statusWidget(String statusText, Color color) {
  return Row(
    children: [
      // Status color indicator
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      SizedBox(width: 4), // Space between circle and text
      // Status text
      Text(
        statusText,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
    ],
  );
}

extension DateTimeExtension on DateTime {
  String weekdayString() {
    switch (this.weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }
}
