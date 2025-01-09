class DeliveryAddress {
  int id;
  String name;
  String mobile;
  int defaultAddress;
  String address;
  String city;
  String area;
  String? landmark; // Nullable
  int pincode;
  String stateName;
  String addressType;
  String createdOn;

  DeliveryAddress({
    required this.id,
    required this.name,
    required this.mobile,
    required this.defaultAddress,
    required this.address,
    required this.city,
    required this.area,
    this.landmark,
    required this.pincode,
    required this.stateName,
    required this.addressType,
    required this.createdOn,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      id: json['id'],
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      defaultAddress: json['defaultAddress'] ?? 0,
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      area: json['area'] ?? '',
      landmark: json['landmark'],
      pincode: json['pincode'] ?? 0,
      stateName: json['stateName'] ?? '',
      addressType: json['addressType'] ?? '',
      createdOn: json['createdOn'] ?? '',
    );
  }
}
