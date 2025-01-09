
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/globally.dart';
import '../data/model/AddressModel.dart';
import '../routs/Approuts.dart';

class AddressViewModel extends ChangeNotifier {
  final AddressModel _address = AddressModel();

  List<Map<String, dynamic>> availableStates = []; // Store state objects with id and name
  String selectedState = "";
  int selectedStateId = 0;




  AddressModel get address => _address;

  List<Map<String, dynamic>> _addressTypes = [];
  List<Map<String, dynamic>> get addressTypes => _addressTypes;

  String _selectedAddressType = '';
  String get selectedAddressType => _selectedAddressType;

  // Fetch Address Types from API
  Future<void> loadAddressTypes() async {
    try {
      _addressTypes = await authService.fetchAddressTypes();
      notifyListeners(); // Notify UI to rebuild when data is fetched
    } catch (error) {
      print("Error fetching address types: $error");
    }
  }



  // Fetch states from the API
  Future<void> loadStates() async {
    try {
      final response = await authService.fetchStates(); // API call to fetch states
      print("API Response: ${response.data}"); // Debug print to verify API response
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
            final nestedData = data['data'];
            if (nestedData.containsKey('States') && nestedData['States'] is List) {
              availableStates = List<Map<String, dynamic>>.from(
                nestedData['States'].map((x) => {
                  'stateId': x['id'],
                  'stateName': x['stateName'],
                }),
              );
              notifyListeners(); // Notify listeners after updating availableStates
              print("States loaded: $availableStates"); // Debug print to verify states
            } else {
              print("States key not found or is not a valid List. Nested keys: ${nestedData.keys}");
            }
          } else {
            print("Data key not found or is not a valid Map. Available keys: ${data.keys}");
          }
        } else {
          print("Invalid API response. Expected a Map<String, dynamic>, but got: ${data.runtimeType}");
        }

      }
    } catch (e) {
      print("Error loading states: $e");
    }
  }

  // Update selected state and stateId
  void updateSelectedState(String stateName, int stateId) {
    selectedState = stateName;
    selectedStateId = stateId;
    _address.stateId = stateId; // Bind the selected state to the address model
    notifyListeners();
  }

  // Update dynamic fields
  void updatePincode(String value) {
    _address.pincode = value.isNotEmpty ? value : null; // Handle null or empty input
    notifyListeners();
  }

  void updateApartmentNumber(String value) {
    _address.address = value.isNotEmpty ? value : null; // Handle null or empty input
    notifyListeners();
  }

  void updateStreetDetails(String value) {
    _address.apartmentName = value.isNotEmpty ? value : null; // Handle null or empty input
    notifyListeners();
  }

  void updateLandmark(String value) {
    _address.landmark = value.isNotEmpty ? value : null; // Handle null or empty input
    notifyListeners();
  }

  void updateFirstName(String value) {
    _address.firstName = value.isNotEmpty ? value : null; // Handle null or empty input
    notifyListeners();
  }

  void updateLastName(String value) {
    _address.lastName = value.isNotEmpty ? value : null; // Handle null or empty input
    notifyListeners();
  }

  void updateMobileNumber(String value) {
    _address.mobile = value.isNotEmpty ? value : null; // Handle null or empty input
    notifyListeners();
  }

  void updateAddressType(int typeId) {
    address.addressTypeId = typeId;
    notifyListeners(); // Ensure UI updates
  }

  void toggleDefaultAddress(bool value) {
    _address.isDefault = value;
    notifyListeners();
  }
  void updateCity(String value) {
    address.city = value;
    notifyListeners();
  }

  void updateArea(String value) {
    address.area = value;
    notifyListeners();
  }
  // Save address to the server
  Future<void> saveAddress(BuildContext context) async {

    // Combine apartmentNumber and apartmentName
    final fullAddress = '${_address.apartmentNumber ?? ''} ${_address.apartmentName ?? ''}';
    // Retrieve the dynamic user ID from your authentication service or local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userIdString = prefs.getString('userId');
    int userId = int.tryParse(userIdString ?? '') ?? 0; // Use 0 or any default value
    // Assuming you have a method to get the user ID

    // Handle null values by using the null-aware operator `??` to provide default values
    final addressTypeId = address.addressTypeId;
    final stateId = selectedStateId; // Use the selected stateId dynamically
    final city = _address.city ?? ""; // Default to "hyd" if null
    final area = _address.area ?? ""; // Default to "madhapur" if null
    final landmark = _address.landmark ?? ""; // Default to empty string if null

    // Call the save address API with dynamic values
    final success = await authService.saveAddress(
      userId: userId, // Dynamic user ID
      addressTypeId: addressTypeId??0,
      name: "${_address.firstName ?? ''} ${_address.lastName ?? ''}", // Handle null first and last name
      mobile: _address.mobile ?? "", // Handle null mobile number
      defaultAddress: _address.isDefault, // Use dynamic default address flag
      address: fullAddress, // Use the full combined address/ Default to empty string if null
      city: city, // Dynamic city
      stateId: stateId, // Dynamic state ID
      pincode: _address.pincode ?? "", // Default to empty string if null
      area: area, // Dynamic area
      landmark: landmark, // Dynamic landmark
      latitude: "", // Optional, use as needed
      longitude: "", // Optional, use as needed
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Address saved successfully!'),
          backgroundColor: Color(0xFF1A73FC),
          duration: const Duration(seconds: 3),

        ),

      );
      Navigator.pushNamed(
          context,
          AppRoutes.DeliveryAddress);
    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to save address'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
