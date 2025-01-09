import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                decoration: const InputDecoration(labelText: "Apartment/House No."),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter apartment/house number';
                  }
                  return null;
                },
              ),
              TextFormField(
                onChanged: viewModel.updateStreetDetails,
                decoration: const InputDecoration(labelText: "Apartment Name/Street Details"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter street details';
                  }
                  return null;
                },
              ),
              TextFormField(
                onChanged: viewModel.updateLandmark,
                decoration: const InputDecoration(labelText: "Landmark"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a landmark';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: viewModel.updateFirstName,
                      decoration: const InputDecoration(labelText: "First Name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      onChanged: viewModel.updateLastName,
                      decoration: const InputDecoration(labelText: "Last Name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter last name';
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
                decoration: const InputDecoration(labelText: "Mobile Number"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  if (value.length != 10) {
                    return 'Mobile number must be 10 digits';
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
                      final stateId = state['stateId'];
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
                      labelText: "State",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a state';
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
                decoration: const InputDecoration(labelText: "Area"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter area';
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
                decoration: const InputDecoration(labelText: "Pincode"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pincode';
                  }
                  if (value.length != 6) {
                    return 'Pincode must be 6 digits';
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
                title: const Text("Set as default Address"),
                activeColor: Colors.green,
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
                    backgroundColor: Colors.green,
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
