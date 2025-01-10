
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hygi_health/data/model/confirmorder.dart';
import 'package:hygi_health/data/model/order_model.dart';
import 'package:hygi_health/data/model/product_view.dart';
import 'package:hygi_health/data/model/removecartItemrequest.dart';
import 'package:hygi_health/data/model/verify_otp_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/constants/constans.dart';
import '../../model/CartResponse.dart';
import '../../model/DeliveryAddress.dart';
import '../../model/category_model.dart';
import '../../model/confirm_order_response.dart';
import '../../model/product_model.dart';
import '../../model/request_user_data.dart';

import '../../model/subcategory_model.dart';
import '../../model/verify_otp_response_model.dart';

class ApiService {
  Dio _dio = Dio();


  // Login function
  Future<String> login(RequestUserData user) async {
    try {
      final response = await _dio.post(
        '${AppConstants.baseUrl}login',
        data: {
          'mobile': user.mobile,
        },
      );

      if (response.statusCode == 200) {
        final responseBody = response.data; // The response is already a Map

        // Parse userId and OTP from response
        final Map<String, dynamic> parsedData = _parseUserData(responseBody);

        if (parsedData.isNotEmpty) {
          final otp = parsedData['otp'];
          await _saveMobileNumber(user.mobile);
          await _saveOtp(otp); // Save OTP
          return 'Login successful  Otp is : $otp'; // Return success message with OTP
        } else {
          throw Exception('Invalid response: userId or otp is missing.');
        }
      } else {
        throw Exception('Invalid phone or password');
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Login failed: $e');
    }
  }

  // // Verify OTP function
  Future<String> verifyOtp(VerifyOtpModelRequest otpRequest) async {
    try {
      // Send a POST request with userId and otp
      final response = await _dio.post(
        '${AppConstants.baseUrl}verify_otp',
        data: {
          'mobile': otpRequest.mobile, // Use the passed object's properties
          'otp': otpRequest.otp,
        },
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse the response into the OtpVerificationResponse model
        final responseBody = response.data;
        final otpResponse = OtpVerificationResponse.fromJson(responseBody);

        // Check if OTP verification is successful
        if (otpResponse.success) {
          // Save userId and otpStatus to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              'userId', otpResponse.data?.user?.id.toString() ?? '');
          await prefs.setString(
              'otpStatus', otpResponse.data?.user?.otpStatus.toString() ?? '');

          return otpResponse.message; // Return the message from the server
        } else {
          throw Exception(otpResponse.message);
        }
      } else {
        throw Exception('Invalid OTP or server error. Please try again.');
      }
    } catch (e) {
      print('Error during OTP verification: $e');
      throw Exception('OTP verification failed: ${e.toString()}');
    }
  }


  // Method to parse userId and OTP from API response
  Map<String, dynamic> _parseUserData(Map<String, dynamic> responseBody) {
    try {
      final data = responseBody['data'];
      if (data == null) {
        throw Exception('Data is missing in the response.');
      }

      // Extract userId and otp

      final otp = data['otp'];


      if (otp == null) {
        throw Exception('userId or otp is missing in the response.');
      }

      return {
        // Ensure it's a string
        'otp': otp.toString(), // Ensure OTP is a string as well
        // ENSURE Otp Status
      };
    } catch (e) {
      print('Error parsing user data: $e');
      throw Exception('Failed to parse user data');
    }
  }

  // Optionally save OTP in SharedPreferences or elsewhere
  Future<void> _saveOtp(String otp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('otp', otp);
  }

  // Optionally save OTP in SharedPreferences or elsewhere
  Future<void> _saveOtpStatus(String otpstatus) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('otpStatus', otpstatus);
  }

  // Store userId in SharedPreferences
  Future<void> _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  // Store MobileNumber in SharedPreferences
  Future<void> _saveMobileNumber(String mobileNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobile', mobileNumber);
  }

  // Retrieve userId from SharedPreferences
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }


  // Fetch banners from the API
  Future<List<String>> fetchBanners() async {
    try {
      final response = await _dio.get('${AppConstants
          .baseUrl}fetchSliders'); // Replace with your API endpoint

      // Check if the status code is 200
      if (response.statusCode == 200) {
        // Decode the response body
        final data = response.data;

        // Ensure the response has the correct structure
        if (data['success'] == true) {
          // Extract banner image URLs
          List<String> bannerUrls = [];
          for (var slider in data['data']['sliders']) {
            // Ensure slider['sliderImage'] is a valid string
            if (slider['sliderImage'] != null) {
              bannerUrls.add(slider['sliderImage']);
            }
          }
          return bannerUrls; // Return the list of banner URLs
        } else {
          // Handle failed response
          throw Exception('Failed to load banners. Success flag is false.');
        }
      } else {
        // Handle non-200 status codes
        throw Exception(
            'Failed to load banners. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Log the error
      print('Error fetching banners: $e');
      // Rethrow the exception
      throw Exception('Error fetching banners');
    }
  }


// Fetch categories from the API
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _dio.get(
          '${AppConstants
              .baseUrl}fetchCategories'); // Replace with your API endpoint
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true) {
          final categories = data['data']?['categories']; // Safe navigation operator
          if (categories != null) {
            return (categories as List)
                .map((category) => Category.fromJson(category))
                .toList();
          } else {
            throw Exception('Categories not found in the response');
          }
        } else {
          throw Exception('Failed to load categories');
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }

//Fetch products for a specific category from the API
  Future<List<Product>> fetchProducts(ProductFilterRequest payload) async {
    try {
      // Define your API endpoint
      final String apiUrl = '${AppConstants.baseUrl}fetchProducts'; // Replace with your actual API endpoint

      // Convert the payload object to JSON
      final Map<String, dynamic> jsonPayload = {
        "categoryId": payload.categoryId,
        "subCategoryId": payload.subCategoryId,
        "listSubCategoryId": payload.listSubCategoryId,
        "productTitle": payload.productTitle,
        "brand": payload.brand,
        "priceFrom": payload.priceFrom,
        "priceTo": payload.priceTo,
        "uomOrSize": payload.uomOrSize,
        "colour": payload.colour,
        "priceSort": payload.priceSort,
      };

      // Configure Dio to use the correct endpoint and handle the request
      final response = await _dio.post(
        apiUrl,
        data: jsonPayload, // Send the JSON payload as the body of the POST request
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Parse the JSON response if the status is 200
        final data = response.data;
        if (data['success']) {
          // Map JSON data to Product objects
          return (data['data']['products'] as List)
              .map((product) => Product.fromJson(product))
              .toList();
        } else {
          // Handle API-level errors
          throw Exception(data['message'] ?? 'Failed to load products');
        }
      } else if (response.statusCode == 204) {
        // Handle the case when no content is returned (HTTP 204)
        print('No products found (HTTP 204 No Content).');
        return []; // Return an empty list since no products were found
      } else {
        // Handle non-200 and non-204 HTTP responses
        throw Exception('Error: HTTP ${response.statusCode}');
      }
    } catch (e) {
      // Log the error and rethrow for higher-level handling
      print('Error fetching products: $e');
      rethrow; // Propagate the error to the higher level
    }
  }



// Fetch product details using POST method with productId and variantId
  Future<ProductView?> fetchProduct(String productId, String variantId) async {
    try {
      // Define the endpoint for the POST request
      final String apiUrl = '${AppConstants.baseUrl}fetchProduct';

      // Define the body with productId and variantId
      final body = {
        'productId': productId,
        'variantId': variantId,
      };

      // Configure Dio to use the correct endpoint and handle the request
      final response = await _dio.post(
        apiUrl,
        data: body, // Send the JSON payload as the body of the POST request
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> responseData = response.data;

        // Check if the response is successful
        if (responseData['success'] == true) {
          // Parse and return the product data from the response using fromJson
          return ProductView.fromJson(responseData['data']);
        } else {
          // Handle API failure message
          print(responseData['message']);
          return null;
        }
      } else {
        // Handle server errors
        throw Exception('Failed to load product');
      }
    } catch (e) {
      // Handle exceptions like no internet connection, invalid URL, etc.
      print('Error: $e');
      return null;
    }
  }

// Method to add a product to the cart
  Future<Map<String, dynamic>> addToCart({
    required int productId,
    required int variantId,
    required String qty,
    required String userId,
  }) async {
    final String apiUrl = '${AppConstants.baseUrl}addToCart';

    try {
      final response = await _dio.post(
        apiUrl,
        data: {
          'productId': productId,
          'variantId': variantId,
          'qty': qty,
          'userId': userId,
        },
      );

      if (response.statusCode == 200) {
        // Directly return the data since Dio handles JSON parsing automatically
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to add to cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding to cart: $e');
    }
  }


  // Method to fetch cart items
  Future<CartResponse> fetchCartItems(int userId) async {
    try {
      // Making POST request to the API
      final response = await _dio.post(
        '${AppConstants.baseUrl}fetchCartItems',
        data: {
          'userId': userId,
        },
      );

      // Checking if response is successful
      if (response.statusCode == 200) {
        // Parsing the JSON data into CartResponse object
        return CartResponse.fromJson(response.data);
      } else {
        // Handle non-200 status codes
        throw Exception('Failed to load cart data: ${response.statusCode}');
      }
    } catch (e) {
      // Catching and handling errors (network issues, invalid response, etc.)
      if (e is DioError) {
        // DioError gives more specific error data
        if (e.response != null) {
          // If we have a response from server
          throw Exception('Error: ${e.response?.data}');
        } else {
          // If no response, likely network error
          throw Exception('Network error: ${e.message}');
        }
      } else {
        // If any other error occurs
        throw Exception('Error: $e');
      }
    }
  }


  //Remove item from the cart based on userId, productId, and variantId
  Future<bool> removeFromCart(RemoveCartItemRequest cartItemRequest) async {
    final String apiUrl = '${AppConstants.baseUrl}removeFromCart';
    final response = await _dio.post(
        apiUrl,
        data: {
          'userId': cartItemRequest.userId,
          'productId': cartItemRequest.productId,
          'variantId': cartItemRequest.variantId,
        });

    if (response.statusCode == 200) {
      return true; // Successfully removed
    } else {
      throw Exception('Failed to remove item from cart');
    }
  }

  // Fetch States
  Future<Response> fetchStates() async {
    try {
      // Build the URL using the base URL and endpoint
      final String url = '${AppConstants.baseUrl}fetchStates';

      // Perform the GET request using Dio
      final Response response = await _dio.get(url);

      // Check response status and return data
      if (response.statusCode == 200) {
        return response; // Successful response
      } else {
        // Handle unexpected status codes
        throw Exception(
            'Failed to fetch states. Status code: ${response.statusCode}');
      }
    } on DioError catch (dioError) {
      // Handle Dio-specific errors
      throw Exception('Dio error occurred: ${dioError.message}');
    } catch (e) {
      // Handle any other unexpected errors
      throw Exception('An error occurred: $e');
    }
  }

  // Method to save an address
  Future<bool> saveAddress({
    required int userId,
    required int addressTypeId,
    required String name,
    required String mobile,
    required bool defaultAddress,
    required String address,
    required String city,
    required int stateId,
    required String pincode,
    required String area,
    required String landmark,
    required String latitude,
    required String longitude,
  }) async {
    final String url = '${AppConstants
        .baseUrl}addAddress'; // Assuming your API endpoint

    // Create the body for the POST request
    final Map<String, dynamic> body = {
      'userId': userId,
      'addressTypeId': addressTypeId,
      'name': name,
      'mobile': mobile,
      'defaultAddress': defaultAddress ? 1 : 0,
      'address': address,
      'city': city,
      'stateId': stateId,
      'pincode': pincode,
      'area': area,
      'landmark': landmark,
      'latitude': latitude,
      'longitude': longitude,
    };

    try {
      // Send the POST request
      final response = await _dio.post(
        url,
        data: json.encode(body),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, return true (success)
        return true;
      } else {
        // If the server returns an error, print the response and return false
        print('Failed to save address: ${response.data}');
        return false;
      }
    } catch (e) {
      print("Error saving address: $e");
      return false;
    }
  }


// Fetch addresses using userId
  Future<List<DeliveryAddress>> fetchAddressesByUserId(int userId) async {
    try {
      final response = await _dio.post(
        '${AppConstants.baseUrl}fetchAddressBook',
        data: {
          'userId': userId,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        if (data['success']) {
          final List<dynamic> addressData = data['data']['addresses'];
          return addressData
              .map((addressJson) => DeliveryAddress.fromJson(addressJson))
              .toList();
        } else {
          throw Exception('Failed to fetch addresses');
        }
      } else {
        throw Exception('Failed to load addresses');
      }
    } catch (e) {
      print("Error fetching addresses: $e");
      return [];
    }
  }

  // Fetch Address Types
  Future<List<Map<String, dynamic>>> fetchAddressTypes() async {
    final String url = ('${AppConstants
        .baseUrl}fetchAddressTypes'); // Your API endpoint

    try {
      // Perform the GET request using Dio
      final Response response = await _dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        // Check if the response is successful
        if (data['success']) {
          final List<dynamic> addressTypesData = data['data']['AddressTypes'];
          // Map the response to a List of Map
          return addressTypesData.map((type) {
            return {
              'addressTypeId': type['id'],
              'typeName': type['addressType'],
            };
          }).toList();
        } else {
          throw Exception('Failed to load address types');
        }
      } else {
        throw Exception('Failed to load address types');
      }
    } catch (e) {
      throw Exception('Failed to fetch address types: $e');
    }
  }


  // Method to fetch the list of subcategories

  Future<List<Subcategory>> postCategorySubcategory(int categoryId, String searchSubCategory) async {
    try {
      // Create the request body with categoryId
      final Map<String, dynamic> requestBody = {
        'categoryId': categoryId,
        'searchSubCategory': searchSubCategory ?? ' ',  // If searchSubCategory is null, use an empty string
      };

      final String url = '${AppConstants.baseUrl}fetchSubCategories';

      // Send POST request
      final response = await _dio.post(
        url,
        data: json.encode(requestBody), // Explicitly encode the body to JSON
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Check if response data is not null
        if (response.data != null && response.data['success'] == true) {
          final List subcategoryData = response.data['data']['subcategories'] ?? [];
          return subcategoryData
              .map((item) => Subcategory.fromJson(item))
              .toList();
        } else {
          throw Exception('Failed to retrieve subcategories');
        }
      } else {
        // Handle non-200 status codes
        throw Exception('Failed to post data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Log the error and rethrow it for handling in the calling code
      print('Error during POST request: $e');
      throw Exception('Error during POST request: $e');
    }
  }


  Future<List<Order>> fetchOrders(int userId, String orderStatus) async {
    // Construct the API URL with query parameters
    final String url = '${AppConstants.baseUrl}fetchMyOrders';

    // Fetch the response from the API
    final response = await _dio.post(
        url,
        data: {
          'userId': userId,
          'orderStatus': orderStatus,
        }
    );

    if (response.statusCode == 200) {
      // If the server returns a successful response, parse the JSON
      OrdersResponse ordersResponse = OrdersResponse.fromJson(response.data);
      return ordersResponse.orders;  // Return the list of orders
    } else {
      // If the server returns an error
      throw Exception('Failed to load orders');
    }
  }
// confirm Order
  Future<ConfirmOrderResponse> confirmOrder(ConfirmOrder order) async {
    final String url = '${AppConstants.baseUrl}confirmOrder';
    final response = await _dio.post(
        url,
      data: jsonEncode(order.toJson()),
    );

    // Check for success or failure
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      return ConfirmOrderResponse.fromJson((response.data));
    } else {
      // Handle errors or unexpected responses appropriately
      return ConfirmOrderResponse(
        success: false,
        message: 'Error: Unable to confirm order',
        data: null,
      );
    }
  }

}















