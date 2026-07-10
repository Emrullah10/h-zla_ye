/// Login response'undaki `driver` objesi — `/gateway/me` bunu döndürmez,
/// bu yüzden login sırasında secure storage'a persist edilir.
class DriverProfile {
  const DriverProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehicleType,
  });

  final String id;
  final String name;
  final String phone;
  final String? vehicleType;

  factory DriverProfile.fromJson(Map<String, dynamic> json) => DriverProfile(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        vehicleType: json['vehicleType']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'vehicleType': vehicleType,
      };
}
