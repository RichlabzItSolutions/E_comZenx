class HelpCenter {
  final int id;
  final String email;
  final String mobile;
  final String? address; // Nullable field

  HelpCenter({
    required this.id,
    required this.email,
    required this.mobile,
    this.address,
  });

  // Factory method to create an instance of HelpCenter from JSON
  factory HelpCenter.fromJson(Map<String, dynamic> json) {
    return HelpCenter(
      id: json['id'],
      email: json['email'],
      mobile: json['mobile'],
      address: json['address'], // Nullable
    );
  }

  // Method to convert HelpCenter instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'mobile': mobile,
      'address': address, // Nullable field can be null
    };
  }
}
