// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart'; // Import Geolocator package
//
// class LocationScreen extends StatefulWidget {
//   @override
//   _LocationScreenState createState() => _LocationScreenState();
// }
//
// class _LocationScreenState extends State<LocationScreen> {
//   String _locationMessage = "";
//
//   // Function to get current location
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled, handle accordingly
//       setState(() {
//         _locationMessage = "Location services are disabled";
//       });
//       return;
//     }
//
//     // Check for location permission
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       // Request permission if denied
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         setState(() {
//           _locationMessage = "Location permission denied";
//         });
//         return;
//       }
//     }
//
//     // Get current position
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//
//     setState(() {
//       _locationMessage = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Get Current Location")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(_locationMessage),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _getCurrentLocation,
//               child: Text("Get Location"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: LocationScreen(),
//   ));
// }
