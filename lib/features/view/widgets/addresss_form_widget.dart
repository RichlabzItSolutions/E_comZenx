
import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:hygi_health/common/Utils/app_strings.dart';
import 'package:provider/provider.dart';

import '../../../viewmodel/AddressViewModel.dart';

class AddressFormWidget extends StatelessWidget {
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AddressViewModel>(context);

    // Load states when the widget is initialized
    // Load states only once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.availableStates.isEmpty) {
        viewModel.loadStates();
      }
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Attach form key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                onChanged: viewModel.updateApartmentNumber,
                decoration: const InputDecoration(labelText: AppStrings.apartMentorHouseNo),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseenterApartMentHouseNumber;
                  }
                  return null;
                },
              ),
              TextFormField(
                onChanged: viewModel.updateStreetDetails,
                decoration: const InputDecoration(labelText: AppStrings.streetDetails),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseenterStreetDetails;
                  }
                  return null;
                },
              ),
              TextFormField(
                onChanged: viewModel.updateLandmark,
                decoration: const InputDecoration(labelText:AppStrings.landmark ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseenterLandmark;
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: viewModel.updateFirstName,
                      decoration: const InputDecoration(labelText: AppStrings.firstName),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseenterFirstName;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      onChanged: viewModel.updateLastName,
                      decoration: const InputDecoration(labelText: AppStrings.lastName),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseenterLastName;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                onChanged: viewModel.updateMobileNumber,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration(labelText: AppStrings.mobile),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseEnterMobileNumber;
                  }
                  if (value.length != 10) {
                    return AppStrings.pleaseEnterValidMobileNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // State Dropdown with dynamic API data
              Consumer<AddressViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.availableStates.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return DropdownButtonFormField<String>(
                    value: viewModel.selectedState.isEmpty ? null : viewModel.selectedState,
                    hint: const Text("Select State"),
                    items: viewModel.availableStates.map((state) {
                      final stateName = state['stateName'];
                      return DropdownMenuItem<String>(
                        value: stateName,
                        child: Text(stateName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        final state = viewModel.availableStates.firstWhere((state) => state['stateName'] == value);
                        final stateId = state['stateId'];
                        viewModel.updateSelectedState(value, stateId);
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: AppStrings.state,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return  AppStrings.pleaseenterState;
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                onChanged: viewModel.updateCity,
                decoration: const InputDecoration(labelText: "City"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                onChanged: viewModel.updateArea,
                decoration: const InputDecoration(labelText: AppStrings.area),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseenterArea;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Pincode Field
              TextFormField(
                onChanged: viewModel.updatePincode,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(labelText: AppStrings.pincode),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.pleaseenterPincode;
                  }
                  if (value.length != 6) {
                    return AppStrings.pleaseenterPincode;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Address Type Buttons (Updated)
              Row(
                children: [
                  _buildAddressTypeButton(context, "Home", 1),
                  _buildAddressTypeButton(context, "Office", 2),
                  _buildAddressTypeButton(context, "Other", 3),
                ],
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: viewModel.address.isDefault,
                onChanged: (value) => viewModel.toggleDefaultAddress(value!),
                title: const Text(AppStrings.defaultAddress),
                activeColor: AppColors.primaryColor,
                checkColor: Colors.white,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate form before saving the address
                    if (_formKey.currentState!.validate()) {
                      viewModel.saveAddress(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    "Save Address",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressTypeButton(BuildContext context, String type, int typeId) {
    final viewModel = Provider.of<AddressViewModel>(context, listen: false);
    final isSelected = viewModel.address.addressTypeId == typeId;

    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          viewModel.updateAddressType(typeId); // Pass typeId as int
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Colors.green : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          side: BorderSide(color: isSelected ? Colors.green : Colors.grey),
        ),
        child: Text(type),
      ),
    );
  }

}
