import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../viewmodel/help_center_viewmodel.dart';
import 'package:permission_handler/permission_handler.dart';
class HelpCenterScreen extends StatefulWidget {
  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch help center details only once when the screen is loaded
    final viewModel = Provider.of<HelpCenterViewModel>(context, listen: false);
    viewModel.fetchHelpCenterDetails();
  }

  // Function to make a phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    if (await Permission.phone.request().isGranted) {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunch(phoneUri.toString())) {
        await launch(phoneUri.toString());
      } else {
        print('Could not launch phone');
      }
    } else {
      print('Permission to make phone calls denied');
    }
  }

  // Function to send an email
  Future<void> _sendEmail(String emailAddress) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      queryParameters: {'subject': 'Help & Support Inquiry'},
    );
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      print('Could not launch email');
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HelpCenterViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Navigate back
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/backarrow.png',
              height: 24,
              width: 24,
              fit: BoxFit.contain,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Help & Support',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject Input
            TextField(
              controller: viewModel.subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                hintText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Message Input
            TextField(
              controller: viewModel.messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Enter Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Submit Button
            ElevatedButton(
              onPressed: () async {
                // Submit the form
                await viewModel.submitForm(context);
                // Clear the form data after submission
                viewModel.subjectController.clear();
                viewModel.messageController.clear();
              },
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: AppColors.primaryColor, // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Display the Email and Mobile below the button
            if (viewModel.helpCenter != null) ...[
              const SizedBox(height: 16), // Space between button and contact details
              // Email Section
              GestureDetector(
                onTap: () {
                  _sendEmail(viewModel.helpCenter!.email);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.email, // Email icon
                      color: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      viewModel.helpCenter!.email,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Phone Number Section
              GestureDetector(
                onTap: () {
                  _makePhoneCall(viewModel.helpCenter!.mobile);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.phone, // Phone icon
                      color: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      viewModel.helpCenter!.mobile,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
