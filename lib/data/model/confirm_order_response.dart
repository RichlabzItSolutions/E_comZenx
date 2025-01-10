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
      orderId: json['order_id'],
      orderRefNumber: json['order_ref_number'],
      totalAmount: json['total_amount'].toDouble(),
      totalItems: json['total_items'],
    );
  }
}
