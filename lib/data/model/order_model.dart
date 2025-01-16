class OrdersResponse {
  final bool success;
  final String message;
  final List<Order> orders;

  OrdersResponse({
    required this.success,
    required this.message,
    required this.orders,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      orders: (json['data']['orders'] as List)
          .map((orderJson) => Order.fromJson(orderJson))
          .toList(),
    );
  }

  // The map method takes a function as an argument that transforms the order object
  List<T> map<T>(T Function(Order) transform) {
    return orders.map(transform).toList();
  }
}



class Order {
  final int id;
  final String name;
  final String mobile;
  final String? email;
  final int addressId;
  final String orderRefNumber;
  final String orderDate;
  final String totalAmount;
  final String? totalItems;
  final String gst;
  final String discount;
  final double finalAmount;
  final String shippingCharges;
  final double payableAmount;
  final int paymentStatus;
  final int paymentMode;
  final String? createdIpAddress;
  late final int orderStatus;
  final String? paymentRefNumber;
  final String? cancelledReason;
  final String createdOn;
  final AddressDetails addressDetails;

  Order({
    required this.id,
    required this.name,
    required this.mobile,
    this.email,
    required this.addressId,
    required this.orderRefNumber,
    required this.orderDate,
    required this.totalAmount,
    required this.totalItems,
    required this.shippingCharges,
    required this.gst,
    required this.discount,
    required this.finalAmount,
    required this.payableAmount,
    required this.paymentStatus,
    required this.paymentMode,
    this.createdIpAddress,
    required this.orderStatus,
    this.paymentRefNumber,
    this.cancelledReason,
    required this.createdOn,
    required this.addressDetails,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      email: json['email'] as String?,
      addressId: json['address_id'] as int,
      orderRefNumber: json['orderRefNumber'] as String,
      orderDate: json['orderDate'] as String,
      totalAmount: json['totalAmount'] as String,
      totalItems: json['totalItems'] as String?,
      gst: json['gst'] as String,
      discount: json['discount'] as String,
      finalAmount: (json['finalAmount'] as num).toDouble(),
      shippingCharges: json['shippingCharges'] as String,
      payableAmount: (json['PayableAmount'] as num).toDouble(),
      paymentStatus: json['paymentStatus'] as int,
      paymentMode: json['paymentMode'] as int,
      createdIpAddress: json['createdIpAddress'] as String?,
      orderStatus: json['orderStatus'] as int,
      paymentRefNumber: json['paymentRefNumber'] as String?,
      cancelledReason: json['cancelledReason'] as String?,
      createdOn: json['createdOn'] as String,
      addressDetails: AddressDetails.fromJson(json['addressDetails']),
    );
  }
}

class AddressDetails {
  final String address;
  final int defaultAddress;  // Corrected field name
  final String name;
  final String mobile;
  final String city;
  final String area;
  final String? landmark;
  final String? latitude;
  final String? longitude;
  final String addressType;

  AddressDetails({
    required this.address,
    required this.defaultAddress,
    required this.name,
    required this.mobile,
    required this.city,
    required this.area,
    this.landmark,
    this.latitude,
    this.longitude,
    required this.addressType,
  });

  factory AddressDetails.fromJson(Map<String, dynamic> json) {
    return AddressDetails(
      address: json['address'] as String,
      defaultAddress: json['deafultAddress'] as int,  // Ensure correct mapping of defaultAddress
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      city: json['city'] as String,
      area: json['area'] as String,
      landmark: json['landmark'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      addressType: json['addressType'] as String,
    );
  }
}
