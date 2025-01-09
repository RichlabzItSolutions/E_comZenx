import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hygi_health/common/globally.dart';
import 'dart:io'; // For handling SocketException

import '../data/model/checkoutmodel.dart';

class CheckoutViewModel extends ChangeNotifier {

  bool _isLoading = false;
  String _errorMessage = '';
  List<CartItem> _cartItems = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  /// Fetch cart items dynamically from the API
  Future<void> fetchCartItems() async {
    _setLoadingState(true);

    // try {
    //   final response = await authService.getCartItems();
    //   final checkoutResponse = CheckoutResponse.fromJson(response);
    //
    //   if (checkoutResponse.success) {
    //     _cartItems = checkoutResponse.cartItems;
    //   } else {
    //     _errorMessage = checkoutResponse.message;
    //   }
    // } on SocketException catch (e) {
    //   // Network error: No internet connection
    //   _errorMessage = 'Network error: Please check your internet connection.';
    // } on http.ClientException catch (e) {
    //   // API client error
    //   _errorMessage = 'API error: ${e.message}';
    // } catch (e) {
    //   // General error
    //   _errorMessage = 'An unexpected error occurred: ${e.toString()}';
    // } finally {
    //   _setLoadingState(false);
    }

  removeCartItem(int index) {}

  editProduct(int index) {}

  void placeOrder(BuildContext context) {}

  void clearCart() {}
  }

  // /// Remove a product by its index
  // void removeCartItem(int index) {
  //   // if (index < 0 || index >= _cartItems.length) {
  //   //   _errorMessage = 'Invalid index. Unable to remove cart item.';
  //   //   notifyListeners();
  //   //   return;
  //   // }
  //   //
  //   // _cartItems.removeAt(index);
  //   // notifyListeners();
  // }
  //
  // /// Clear the cart
  // void clearCart() {
  //   _cartItems.clear();
  //   notifyListeners();
  // }

  /// Add a placeholder method for placing an order
  Future<void> placeOrder(BuildContext context) async {
    // if (_cartItems.isEmpty) {
    //   _showSnackbar(context, 'Your cart is empty. Add items to proceed.');
    //   return;
    // }

    try {
      //await authService.placeOrder(_cartItems); // Assuming API service handles order placement
      //clearCart(); // Clear cart upon successful order placement
      _showSnackbar(context, 'Order placed successfully!');
    } on SocketException catch (e) {
      _showSnackbar(context, 'Network error: ${e.message}');
    } on http.ClientException catch (e) {
      _showSnackbar(context, 'API error: ${e.message}');
    } catch (e) {
      _showSnackbar(context, 'Error placing order: ${e.toString()}');
    }
  }

  /// Helper method to handle loading state
  void _setLoadingState(bool isLoading) {
    // _isLoading = isLoading;
    // notifyListeners();
  }

  /// Helper method to display snackbars
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // void editProduct(int index) {
  //   // Logic to edit the product (e.g., show a dialog or navigate to an edit screen)
  //   print("Edit product at index: $index");
  //  // notifyListeners();
  // }

