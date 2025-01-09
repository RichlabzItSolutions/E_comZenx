import 'package:flutter/material.dart';
import 'package:hygi_health/features/view/BaseScreen.dart';
import 'package:hygi_health/viewmodel/myaccount_view_Model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routs/Approuts.dart';
class MyAccountScreen extends StatelessWidget {
  const  MyAccountScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MyAccountViewModel>(context);
    return BaseScreen(
      title: 'Profile',
      cartItemCount: 3,
      // Example cart item count
      showCartIcon: false,
      showShareIcon: false,
        child: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,

                    ),
                    GestureDetector(
                      //onTap: viewModel.pickImageFromCamera,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ramesh Sudhanapu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, color: Colors.grey),

          // Options List
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Your Profile'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    print("Profile");
                  }, // Add navigation or functionality here
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: 12,right: 12) , // Adjust horizontal space
                //   child: Divider(
                //     thickness: 1, // Optional: to change the thickness of the line
                //     color: Colors.grey, // Optional: to change the color
                //   ),
                // ),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text('Manage Address'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.DeliveryAddress);
                  },
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: 12,right: 12) , // Adjust horizontal space
                //   child: Divider(
                //     thickness: 1, // Optional: to change the thickness of the line
                //     color: Colors.grey, // Optional: to change the color
                //   ),
                // ),
                ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: const Text('Payment Methods'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: 12,right: 12) , // Adjust horizontal space
                //   child: Divider(
                //     thickness: 1, // Optional: to change the thickness of the line
                //     color: Colors.grey, // Optional: to change the color
                //   ),
                // ),

                ListTile(
                  leading: const Icon(Icons.account_balance_wallet),
                  title: const Text('My Wallet'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: 12,right: 12) , // Adjust horizontal space
                //   child: Divider(
                //     thickness: 1, // Optional: to change the thickness of the line
                //     color: Colors.grey, // Optional: to change the color
                //   ),
                // ),
                ListTile(
                  leading: const Icon(Icons.local_offer),
                  title: const Text('My Coupons'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.COUPON);
                  },
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: 12,right: 12) , // Adjust horizontal space
                //   child: Divider(
                //     thickness: 1, // Optional: to change the thickness of the line
                //     color: Colors.grey, // Optional: to change the color
                //   ),
                // ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.NOTIFICATION);
                  },
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: 12,right: 12) , // Adjust horizontal space
                //   child: Divider(
                //     thickness: 1, // Optional: to change the thickness of the line
                //     color: Colors.grey, // Optional: to change the color
                //   ),
                // ),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Help Center'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: 12,right: 12) , // Adjust horizontal space
                //   child: Divider(
                //     thickness: 1, // Optional: to change the thickness of the line
                //     color: Colors.grey, // Optional: to change the color
                //   ),
                // ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: 12,right: 12) , // Adjust horizontal space
                //   child: Divider(
                //     thickness: 1, // Optional: to change the thickness of the line
                //     color: Colors.grey, // Optional: to change the color
                //   ),
                // ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    _logout(context);
                  }, // Add logout functionality here
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
Future<void> _logout(BuildContext context) async {
  // Show confirmation dialog
  bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );

  if (confirmed == true) {
    // Clear all SharedPreferences values
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to the login screen
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }


  if (confirmed == true) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }
}