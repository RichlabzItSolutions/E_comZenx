class ConfirmOrderResponse {
  final bool success;
  final String message;
  final OrderData? data;

  ConfirmOrderResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ConfirmOrderResponse.fromJson(Map<String, dynamic> json) {
    return ConfirmOrderResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
    );
  }
}

class OrderData {
  final int orderId;
  final String orderRefNumber;
  final double totalAmount;
  final int totalItems;

  OrderData({
    required this.orderId,
    required this.orderRefNumber,
    required this.totalAmount,
    required this.totalItems,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {

    return OrderData(
    orderId: json['order_id'] ?? 0, // Default to 0 if null
    orderRefNumber: json['order_ref_number'] ?? '',
    totalAmount: (json['total_amount'] ?? 0.0).toDouble(), // Default to 0.0 if null
    totalItems: json['total_items'] ?? 0, // Default to 0 if null
    );

  }
}
