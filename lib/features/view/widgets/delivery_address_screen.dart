import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../common/Utils/dottedborder.dart';
import '../../../data/model/DeliveryAddress.dart';
import '../../../data/model/PaymentMethod.dart';
import '../../../routs/Approuts.dart';
import '../../../viewmodel/delivery_address_viewmodel.dart';
import '../BaseScreen.dart';

class DeliveryAddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeliveryViewModel()
        ..loadDeliveryAddresses(), // Load delivery addresses
      child: BaseScreen(
        title: 'Delivery Address',
        // Example cart item count
        showCartIcon: false,
        showShareIcon: false,
        child: Scaffold(
          body: Consumer<DeliveryViewModel>(builder: (context, viewModel, _) {
            // Ensure COD and Online Payment are both visible
            // Set Online Payment as initially selected
            if (viewModel.paymentMethods.isEmpty) {
              viewModel.paymentMethods
                  .add(PaymentMethod(type: "COD", isSelected: false));
              //viewModel.paymentMethods.add(PaymentMethod(type: "Online Payment", isSelected: true)); // Set this as selected by default
            }

            // Check if delivery address and payment method are selected
            bool isAddressSelected = viewModel.selectedAddressIndex != null;
            bool isPaymentMethodSelected =
                viewModel.paymentMethods.any((method) => method.isSelected);

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Delivery Addresses Section
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Delivery Address",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        viewModel.deliveryAddresses.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "No address found.",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: viewModel.deliveryAddresses.length,
                                separatorBuilder: (context, index) =>
                                    Divider(color: Colors.grey.shade300),
                                itemBuilder: (context, index) {
                                  DeliveryAddress address =
                                      viewModel.deliveryAddresses[index];
                                  return ListTile(
                                    leading: Icon(Icons.location_on,
                                        color: AppColors.primaryColor),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _getAddressTypeLabel(
                                                address.addressType),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                            overflow: TextOverflow
                                                .ellipsis, // Handle long text gracefully
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            // Navigate to the edit screen with the specific address
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes.ADDADDRESS,
                                              arguments:
                                                  address, // Pass the selected address for editing
                                            );
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: AppColors.primaryColor,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      '${address.name}, ${address.mobile}, ${address.address}, ${address.area}, ${address.city}, ${address.pincode}' +
                                          (address.landmark != null
                                              ? ", ${address.landmark}"
                                              : ""),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                    ),
                                    trailing: Radio(
                                      value: index,
                                      groupValue:
                                          viewModel.selectedAddressIndex,
                                      activeColor: AppColors.primaryColor,
                                      onChanged: (value) => viewModel
                                          .selectDeliveryAddress(index),
                                    ),
                                  );
                                },
                              ),

                        const SizedBox(height: 16), // Add spacing
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.ADDADDRESS);
                            // Handle "Add New Address" action
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: DottedBorderContainer(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add,
                                      color: AppColors.primaryColor),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Add New Delivery Address",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Payment Methods Section
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              "Payment Method",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        // Cash on Delivery (COD) Section
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            "Cash on Delivery (COD)",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Column(
                          children: List.generate(
                            viewModel.paymentMethods.length,
                            (index) {
                              PaymentMethod method =
                                  viewModel.paymentMethods[index];
                              return _buildPaymentMethodContainer(
                                  method, index, viewModel);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // "Place Order" Button
                // "Place Order" Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Visibility(
                    visible: viewModel.deliveryAddresses.isNotEmpty,
                    // Check if addresses exist
                    child: ElevatedButton(
                      onPressed: isAddressSelected && isPaymentMethodSelected
                          ? () {
                              viewModel.confirmOrder(context);
                              // Handle "Place Order" action
                            }
                          : null, // Disable button if conditions are not met
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50), // Full width
                        backgroundColor:
                            isAddressSelected && isPaymentMethodSelected
                                ? AppColors.primaryColor
                                : Colors.grey, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Place Order",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodContainer(
      PaymentMethod method, int index, DeliveryViewModel viewModel) {
    return GestureDetector(
      onTap: () => viewModel.selectPaymentMethod(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: viewModel.paymentMethods[index].isSelected
              ? Colors.blue.shade50
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: viewModel.paymentMethods[index].isSelected
                ? AppColors.primaryColor
                : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              method.type == "COD" ? Icons.local_shipping : Icons.credit_card,
              size: 24,
              color: viewModel.paymentMethods[index].isSelected
                  ? AppColors.primaryColor
                  : Colors.grey,
            ),
            const SizedBox(width: 16),
            Text(
              method.type,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: viewModel.paymentMethods[index].isSelected
                    ? AppColors.primaryColor
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAddressTypeLabel(String addressType) {
    // Return a human-readable label based on the address type
    switch (addressType) {
      case 'Home':
        return "Home Address";
      case 'Office':
        return "Office Address";
      case 'Others':
        return "Other Address";
      default:
        return "Unknown Address Type";
    }
  }
}
