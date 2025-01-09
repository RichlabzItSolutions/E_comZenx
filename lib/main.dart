import 'package:flutter/material.dart';
import 'package:hygi_health/data/model/notification_model.dart';
import 'package:hygi_health/features/view/HomeDashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hygi_health/features/view/add_address_screen.dart';
import 'package:hygi_health/features/view/notifications_screen.dart';
import 'package:hygi_health/features/view/widgets/coupon_screen.dart';
import 'package:hygi_health/features/view/widgets/delivery_address_screen.dart';
import 'package:hygi_health/features/view/widgets/myaccount_screen.dart';
import 'package:hygi_health/features/view/widgets/orderscreen.dart';
import 'package:hygi_health/features/view/widgets/shopping_cart_screen.dart';
import 'package:hygi_health/viewmodel/AddressViewModel.dart';
import 'package:hygi_health/viewmodel/coupon_view_model.dart';
import 'package:hygi_health/viewmodel/delivery_address_viewmodel.dart';
import 'package:hygi_health/viewmodel/myaccount_view_Model.dart';
import 'package:hygi_health/viewmodel/notification_viewmodel.dart';
import 'package:hygi_health/viewmodel/order_view_model.dart';
import 'package:hygi_health/viewmodel/shopping_cart_view_model.dart';
import 'package:hygi_health/viewmodel/slide_view_model.dart';
import 'package:hygi_health/viewmodel/subcategory_view_model.dart';
import 'dart:async'; // For Timer
import 'data/model/category_model.dart';
import 'features/view/LoginScreen.dart';
import 'features/view/VerifyOtpScreen.dart';
import 'features/view/sub_category_list_page.dart';
import 'features/view/viewAllScreen.dart';
import 'features/view/category_view.dart';
import 'features/view/widgets/OrderConfirmationPage.dart';
import 'routs/Approuts.dart';

import "package:hygi_health/viewmodel/category_view_model.dart";
import 'package:hygi_health/features/view/product_viewmodel_screen.dart';
import 'package:provider/provider.dart';
import 'package:hygi_health/features/view/widgets/checkout_screen.dart';
import "package:hygi_health/viewmodel/checkout_view_model.dart";
import "package:hygi_health/viewmodel/base_view_ model.dart";
import "package:hygi_health/viewmodel/product_view_model.dart";
import "package:hygi_health/viewmodel/verify_otp_view_model.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => CheckoutViewModel()),
        ChangeNotifierProvider(create: (_) => BaseViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => VerifyOtpViewModel()),
        ChangeNotifierProvider(create: (_) => ShoppingCartViewModel()),
        ChangeNotifierProvider(create: (_) => MyAccountViewModel()),
        ChangeNotifierProvider(create: (_) => DeliveryViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => CouponViewModel()),
        ChangeNotifierProvider(create: (_) => SliderViewModel()),
        ChangeNotifierProvider(create: (_) => AddressViewModel()),
        ChangeNotifierProvider(create: (_) => SubcategoryViewModel()),
        ChangeNotifierProvider(create: (_) =>OrderViewModel()),


        // Add other providers here if needed
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1A73FC),
          iconTheme: IconThemeData(
            color: Color(0xFF1A73FC), // Change the back arrow color here
          ),
          // Set the global AppBar color
        ),
        // textTheme: TextTheme(
        //   bodyText1: TextStyle(color: Colors.black), // Ensure global text is black
        // ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        AppRoutes.SPLASH: (context) => SplashScreen(),
        AppRoutes.LOGIN: (context) => LoginScreen(),
        AppRoutes.VERIFY: (context) => VerifyOtpScreen(),
        AppRoutes.HOME: (context) => HomePage(),
        AppRoutes.VIEWALL: (context) {
          final categories =
              ModalRoute.of(context)!.settings.arguments as List<Category>? ??
                  [];
          return ViewAllScreen(
              categories: categories); // Pass categories to ViewAllScreen
        },
        AppRoutes.CategoryViewAll: (context) {
          // Extract the arguments passed during navigation
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

          // Retrieve categoryId and position from the arguments
          final categoryId = args['categoryId']!;
          final position = args['position']!;

          // Pass the categoryId and position to CategoryView
          return CategoryView(categoryId: categoryId, position: position);
        },

        AppRoutes.productviewmodel: (context) => ProductViewmodelScreen(),
        AppRoutes.CHECKOUT: (context) => CheckoutScreen(),
        AppRoutes.ShoppingCart: (context) => ShoppingCartScreen(),
        AppRoutes.MyAccount: (context) => MyAccountScreen(),
        AppRoutes.DeliveryAddress: (context) => DeliveryAddressScreen(),
        AppRoutes.NOTIFICATION: (context) => NotificationsScreen(),
        AppRoutes.COUPON: (context) => CouponScreen(),
        AppRoutes.ADDADDRESS: (context) => AddAddressScreen(),
        AppRoutes.SUBCATEGORY: (context) {
          // Extract arguments from the route settings
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, int>;

          // Retrieve categoryId and subcategoryId from the arguments
          final categoryId = args['categoryId']!;

          // Pass the arguments to the SubcategoryListPage
          return SubcategoryListPage(categoryId: categoryId);
        },
        AppRoutes.MYORDERS: (context) => OrderTabsView(),
        AppRoutes.SUCCESS: (context) => OrderConfirmationPage()
      },

    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  // Check if the user ID is stored in Hive
  Future<void> _checkUserStatus() async {
    final prefs = await SharedPreferences.getInstance(); // Initialize SharedPreferences
    final userId = prefs.getString('userId'); // Retrieve userId from SharedPreferences
    // Delay to simulate splash screen, then navigate based on user login status
    Future.delayed(Duration(seconds: 3), () {
      if (userId != null) {
        // If userId is present, navigate to Home screen
        Navigator.pushReplacementNamed(context, AppRoutes.HOME);
      } else {
        // If userId is not present, navigate to Login screen
        Navigator.pushReplacementNamed(context, AppRoutes.LOGIN);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF), // Set the background color to red
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Image
            Image.asset(
              'assets/logo.png', // Path to the image in the assets folder
              width: 150, // Adjust width
              height: 150, // Adjust height
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
