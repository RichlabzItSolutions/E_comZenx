class Slob {
  final int id;
  final int fromTotal;
  final int toTotal;
  final int deliveryCharges;

  Slob({
    required this.id,
    required this.fromTotal,
    required this.toTotal,
    required this.deliveryCharges,
  });

  // Convert JSON to Slob object
  factory Slob.fromJson(Map<String, dynamic> json) {
    return Slob(
      id: json['id'],
      fromTotal: json['fromTotal'],
      toTotal: json['toTotal'],
      deliveryCharges: json['deliveryCharges'],
    );
  }
}
