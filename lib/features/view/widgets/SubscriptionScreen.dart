//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// // Import CategoryViewModel
// import 'package:hygi_health/features/view/widgets/horizontal_category_list.dart';
// import 'package:hygi_health/features/view/widgets/product_list_view.dart'; // If needed for ProductListView
// import 'package:hygi_health/viewmodel/subscribe_view_model.dart';
// import 'package:hygi_health/features/view/BaseScreen.dart';
// import 'package:provider/provider.dart';
// import 'package:hygi_health/data/model/subscribe_model.dart';
//
// // SubscriptionScreen
// class SubscriptionScreen extends StatelessWidget {
//   final SubscribeModel product = SubscribeModel(
//     name: "Organic Tender Coconut",
//     imageUrl: "https://example.com/coconut.png", // Replace with your image URL
//     price: 85.0,
//     originalPrice: 100.0,
//     unit: "1 Piece(s)",
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => SubscribeViewModel(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Product Frequency"),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//         body: Consumer<SubscribeViewModel>(
//           builder: (context, viewModel, child) {
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "How often do you want to receive this item?",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//
//                   // Tabs
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       FrequencyTab(label: "Everyday", viewModel: viewModel),
//                       FrequencyTab(label: "Custom", viewModel: viewModel),
//                       FrequencyTab(label: "Intervals", viewModel: viewModel),
//                     ],
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Dynamic View Based on Selected Tab
//                   Expanded(
//                     child: _buildSelectedView(viewModel),
//                   ),
//
//                   const Spacer(),
//
//                   // Footer
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text("Total ₹60",
//                           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                       ElevatedButton.icon(
//                         onPressed: () {
//                           // Add to cart functionality
//                         },
//                         icon: const Icon(Icons.shopping_cart),
//                         label: const Text("Add to cart"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSelectedView(SubscribeViewModel viewModel) {
//     switch (viewModel.selectedFrequency) {
//       case "Everyday":
//         return EverydayView(viewModel: viewModel);
//       case "Custom":
//         return CustomView(viewModel: viewModel);
//       case "Intervals":
//         return IntervalsView(viewModel: viewModel);
//       default:
//         return EverydayView(viewModel: viewModel);
//     }
//   }
// }
//
// // FrequencyTab Widget
// class FrequencyTab extends StatelessWidget {
//   final String label;
//   final SubscribeViewModel viewModel;
//
//   const FrequencyTab({required this.label, required this.viewModel});
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => viewModel.setFrequency(label),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: viewModel.selectedFrequency == label
//                 ? Colors.green
//                 : Colors.white,
//             border: Border.all(color: Colors.green),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             label,
//             style: TextStyle(
//               color: viewModel.selectedFrequency == label
//                   ? Colors.white
//                   : Colors.green,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // EverydayClass View
//
// class EverydayView extends StatelessWidget {
//   final SubscribeViewModel viewModel;
//
//   const EverydayView({required this.viewModel});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Receive the product every day.",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 20),
//
//         // Quantity Selector
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold)),
//             Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.remove),
//                   onPressed: viewModel.decrementQuantity,
//                 ),
//                 Text("${viewModel.quantity}", style: const TextStyle(fontSize: 18)),
//                 IconButton(
//                   icon: const Icon(Icons.add),
//                   onPressed: viewModel.incrementQuantity,
//                 ),
//               ],
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 20),
//
//         // Frequency Summary
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text("Frequency", style: TextStyle(fontWeight: FontWeight.bold)),
//             Text("${viewModel.quantity} Quantity ${viewModel.selectedFrequency}"),
//           ],
//         ),
//
//         const SizedBox(height: 20),
//
//         // Delivery Date
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text("Select delivery date", style: TextStyle(fontWeight: FontWeight.bold)),
//             GestureDetector(
//               onTap: () async {
//                 final DateTime? picked = await showDatePicker(
//                   context: context,
//                   initialDate: viewModel.selectedDate,
//                   firstDate: DateTime(2020),
//                   lastDate: DateTime(2101),
//                 );
//                 if (picked != null && picked != viewModel.selectedDate) {
//                   viewModel.setSelectedDate(picked);
//                 }
//               },
//               child: Row(
//                 children: [
//                   const Icon(Icons.calendar_today, size: 16),
//                   const SizedBox(width: 5),
//                   Text(
//                     DateFormat.yMMMd().format(viewModel.selectedDate), // Using intl package to format the date
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 20),
//
//         // Delivery Slot
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text("Select delivery slot", style: TextStyle(fontWeight: FontWeight.bold)),
//             GestureDetector(
//               onTap: () async {
//                 final TimeOfDay? picked = await showTimePicker(
//                   context: context,
//                   initialTime: viewModel.selectedTime,
//                 );
//                 if (picked != null && picked != viewModel.selectedTime) {
//                   viewModel.setSelectedTime(picked);
//                 }
//               },
//               child: Row(
//                 children: [
//                   const Icon(Icons.access_time, size: 16),
//                   const SizedBox(width: 5),
//                   Text("${viewModel.selectedTime.format(context)}"),
//                 ],
//               ),
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 20),
//
//         // Delivery Address
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text("Delivery Address", style: TextStyle(fontWeight: FontWeight.bold)),
//             IconButton(
//               icon: const Icon(Icons.edit, size: 16),
//               onPressed: () {
//                 // Replace this with actual functionality to edit the address
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: const Text("Edit Address"),
//                       content: TextField(
//                         controller: TextEditingController(
//                           text: "512, 100 Feet Rd, Ayyappa Society, Mega Hills, Madhapur, Hyderabad.",
//                         ),
//                         decoration: const InputDecoration(labelText: "New Address"),
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             // Handle address saving
//                             Navigator.pop(context);
//                           },
//                           child: const Text("Save"),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Text("Cancel"),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//         const Text(
//           "512, 100 Feet Rd, Ayyappa Society, Mega Hills, Madhapur, Hyderabad.",
//           style: TextStyle(color: Colors.grey),
//         ),
//       ],
//     );
//   }
// }
//
//
// // Placeholder for other views
//
// // Custom View
// class CustomView extends StatelessWidget {
//   final SubscribeViewModel viewModel;
//
//   const CustomView({required this.viewModel});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Set a custom frequency for receiving this product.",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 20),
//         TextField(
//           decoration: const InputDecoration(
//             labelText: "Enter custom days (e.g., Mon, Wed, Fri)",
//             border: OutlineInputBorder(),
//           ),
//         ),
//         const SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: () {
//             // Custom frequency logic
//           },
//           child: const Text("Set Frequency"),
//         ),
//       ],
//     );
//   }
// }
//
// // Intervals View
// class IntervalsView extends StatelessWidget {
//   final SubscribeViewModel viewModel;
//
//   const IntervalsView({required this.viewModel});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Select intervals for receiving this product.",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 20),
//         DropdownButton<int>(
//           value: 1,
//           items: List.generate(
//             10,
//                 (index) => DropdownMenuItem(
//               value: index + 1,
//               child: Text("Every ${index + 1} day(s)"),
//             ),
//           ),
//           onChanged: (value) {
//             // Interval frequency logic
//           },
//         ),
//       ],
//     );
//   }
// }
//
//
// // class CustomView extends StatelessWidget {
// //   final ProductFrequencyViewModel viewModel;
// //
// //   CustomView(this.viewModel);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(16.0),
// //       child: Column(
// //         children: [
// //           const Text(
// //             "Set a custom frequency for receiving this product.",
// //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //           ),
// //           const SizedBox(height: 20),
// //           TextField(
// //             decoration: const InputDecoration(
// //               labelText: "Enter custom days (e.g., Mon, Wed, Fri)",
// //               border: OutlineInputBorder(),
// //             ),
// //           ),
// //           const SizedBox(height: 20),
// //           ElevatedButton(
// //             onPressed: () {
// //               // Custom frequency logic
// //             },
// //             child: const Text("Set Frequency"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// //
// // class EverydayView extends StatelessWidget {
// //   final ProductFrequencyViewModel viewModel;
// //
// //   EverydayView(this.viewModel);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(16.0),
// //       child: Column(
// //         children: [
// //           const Text(
// //             "Receive the product every day.",
// //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //           ),
// //           const SizedBox(height: 20),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               const Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold)),
// //               Row(
// //                 children: [
// //                   IconButton(
// //                     icon: const Icon(Icons.remove),
// //                     onPressed: viewModel.decrementQuantity,
// //                   ),
// //                   Text("${viewModel.quantity}", style: const TextStyle(fontSize: 18)),
// //                   IconButton(
// //                     icon: const Icon(Icons.add),
// //                     onPressed: viewModel.incrementQuantity,
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// //
// // class IntervalsView extends StatelessWidget {
// //   final ProductFrequencyViewModel viewModel;
// //
// //   IntervalsView(this.viewModel);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(16.0),
// //       child: Column(
// //         children: [
// //           const Text(
// //             "Select intervals for receiving this product.",
// //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //           ),
// //           const SizedBox(height: 20),
// //           DropdownButton<int>(
// //             value: 1,
// //             items: List.generate(
// //               10,
// //                   (index) => DropdownMenuItem(
// //                 value: index + 1,
// //                 child: Text("Every ${index + 1} day(s)"),
// //               ),
// //             ),
// //             onChanged: (value) {
// //               // Interval frequency logic
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
