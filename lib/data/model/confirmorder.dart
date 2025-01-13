class ConfirmOrder {
  final String userId;
  final String addressId;
  final int paymentMode;
  final int locationId;


  ConfirmOrder({required this.userId, required this.addressId, required this.paymentMode, required this.locationId});

  // Convert a Order object into a Map object which can be used to send in the API request
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'addressId': addressId,
      'paymentMode': paymentMode,
      'locationId': locationId,
    };
  }
}