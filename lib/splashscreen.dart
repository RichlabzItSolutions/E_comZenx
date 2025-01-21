import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hygi_health/routs/Approuts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences
        .getInstance(); // Initialize SharedPreferences
    final userId = prefs.getString(
        'userId'); // Retrieve userId from SharedPreferences
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
      backgroundColor: const Color(0xFFFFFFFF), // Set the background color to white
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Image that adapts to device dimensions
            Image.asset(
              'assets/splash.png', // Path to the image in the assets folder
              width: MediaQuery.of(context).size.width, // Full device width
              height: MediaQuery.of(context).size.height * 0.6, // 60% of device height
              fit: BoxFit.contain, // Scale image to fill both dimensions while preserving aspect ratio
            ),
          ],
        ),
      ),
    );
  }

}
