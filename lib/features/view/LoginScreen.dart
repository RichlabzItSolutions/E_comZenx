import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routs/Approuts.dart';
import '../../viewmodel/login_view_model.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<LoginViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full-width image banner
                    SizedBox(
                      width: double.infinity,
                      height: 250,
                    ),
                    SizedBox(height: 80),
                    // Apply padding only to the "Login" and below layout
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Login Text
                          Text(
                            "Login",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Please enter mobile number to login/Signup",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          SizedBox(height: 30),
                          // Mobile number input field
                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12.0), // Adjust icon padding
                                child: Image.asset(
                                  'assets/mobile.png', // Replace with your custom icon
                                  width: 16,
                                  height: 16,
                                ),
                              ),
                              hintText: 'Enter Mobile Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey, // Set border color to gray
                                  width: 1.0, // Set the width of the border
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey, // Gray border when the field is enabled
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.blue, // Blue border when the field is focused
                                  width: 2.0,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                              counterText: '',
                            ),
                            onChanged: (value) {
                              viewModel.setPhone(value); // Update phone number in ViewModel
                            },
                          ),
                          SizedBox(height: 30),
                          // Send OTP Button
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: viewModel.isLoading
                                  ? null
                                  : () async {
                                await viewModel.login();
                                // Handle successful login
                                if (viewModel.successMessage != null) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(viewModel.successMessage!),
                                      backgroundColor: Color(0xFF1A73FC),
                                    ),
                                  );
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.VERIFY,
                                  );
                                } else if (viewModel.errorMessage.isNotEmpty) {
                                  // Handle errors
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(viewModel.errorMessage),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A73FC),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Send OTP',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          // Terms and Conditions Text
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "By proceeding, I agree to ",
                              style: TextStyle(fontSize: 14, color: Colors.black54), // Default text style
                              children: [
                                TextSpan(
                                  text: "Terms and Conditions",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                TextSpan(
                                  text: " & ",
                                  style: TextStyle(color: Colors.black54), // Default style for '&'
                                ),
                                TextSpan(
                                  text: " \t\nPrivacy Policy",
                                  style: TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          // Display error message if any
                          if (viewModel.errorMessage.isNotEmpty)
                            Text(
                              viewModel.errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          // Display loading indicator if isLoading is true
                          // Loading indicator
                          Consumer<LoginViewModel>( // Wrap with Consumer to access viewModel
                            builder: (context, viewModel, child) {
                              if (viewModel.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return const SizedBox.shrink(); // Return empty widget when not loading
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
