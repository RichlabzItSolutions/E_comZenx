import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routs/Approuts.dart'; // Import your AppRoutes file
import '../../viewmodel/verify_otp_view_model.dart';

class VerifyOtpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VerifyOtpViewModel(),
      child: Scaffold(
        body: Consumer<VerifyOtpViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Banner Image
                  Container(
                    width: double.infinity,
                    height: 250,

                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Verify Code",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Enter the OTP sent to your mobile number",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // OTP Input Section
                  // OTP Input Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        4,
                            (index) => SizedBox(
                          width: 60,  // Control the width of each OTP input field
                          height: 60,  // Control the height of the OTP input field
                          child: TextField(
                            controller: viewModel.controllers[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            decoration: InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF6F6F6),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 3) {
                                FocusScope.of(context).nextFocus();
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(context).previousFocus();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Timer or Resend Link
                  viewModel.canResend
                      ? GestureDetector(
                    onTap: () async {
                      await viewModel.handleResend(context); // Await the resend operation
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Don't receive the OTP? ",
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Resend",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      : Text(
                    viewModel.formatTime(viewModel.start),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 20),

                  // Verify OTP Button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () async {
                        await viewModel.verifyOtp(context); // Await OTP verification
                        if (viewModel.isOtpVerified) {
                          // Navigate to the next screen if OTP is verified
                          Navigator.pushNamed(context, AppRoutes.HOME);

                        } else {
                          // If OTP is invalid, show the error message
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(content: Text(viewModel.errorMessage)),
                          // );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A73FC),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Verify OTP',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Error Message

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}