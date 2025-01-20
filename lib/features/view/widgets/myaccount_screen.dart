import 'package:flutter/material.dart';
import 'package:hygi_health/features/view/BaseScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routs/Approuts.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'My Account',
      // Example cart item count
      showCartIcon: false,
      showShareIcon: false,
      child: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            // Retained header space
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                    ),
                    GestureDetector(
                      // onTap: viewModel.pickImageFromCamera,
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
                    color: Colors.black, // Set text color to black
                  ),
                ),
              ],
            ),
          ),
          // Options List
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Image.asset("assets/profile.png"),
                  title: const Text(
                    'Your Profile',
                    style: TextStyle(
                        color: Colors.black), // Set text color to black
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    print("Profile");
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading: Image.asset("assets/location.png"),
                  title: const Text(
                    'My Address Book',
                    style: TextStyle(
                        color: Colors.black), // Set text color to black
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {

                    Navigator.pushNamed(
                      context,
                      AppRoutes.DeliveryAddress,
                      arguments: {'from': 2}, // Passing arguments as a map
                    );
                  },
                ),
                _buildDivider(),
                ListTile(
                  leading: Image.asset("assets/cart.png"),
                  title: const Text(
                    'My Orders',
                    style: TextStyle(
                        color: Colors.black), // Set text color to black
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.MYORDERS);
                  },
                ),
                _buildDivider(),
                // ListTile(
                //   leading: Image.asset("assets/info.png"),
                //   title: const Text(
                //     'Help Center',
                //     style: TextStyle(color: Colors.black), // Set text color to black
                //   ),
                //   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                //   onTap: () {},
                // ),
                // _buildDivider(),
                ListTile(
                  leading: Image.asset("assets/privacy.png"),
                  title: const Text(
                    'Privacy Policy',
                    style: TextStyle(
                        color: Colors.black), // Set text color to black
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                _buildDivider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                        color: Colors.black), // Set text color to black
                  ),
                  onTap: () {
                    _logout(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        thickness: 1,
        color: Colors.grey,
        height: 1, // Reduced height for minimal vertical space
      ),
    );
  }
}

Future<void> _logout(BuildContext context) async {
  bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout ?'),
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
