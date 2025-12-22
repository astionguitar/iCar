class Workshop {
  final int id;
  final String name;
  final String type;
  final String neighborhood;
  final String city;
  final String state;
  final String phone;
  final String whatsapp;
  final double? latitude;
  final double? longitude;
  final double rating;
  final bool isPremium;

  Workshop({
    required this.id,
    required this.name,
    required this.type,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.phone,
    required this.whatsapp,
    this.latitude,
    this.longitude,
    required this.rating,
    required this.isPremium,
  });

  factory Workshop.fromMap(Map<String, dynamic> map) {
    return Workshop(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      neighborhood: map['neighborhood'],
      city: map['city'],
      state: map['state'],
      phone: map['phone'],
      whatsapp: map['whatsapp'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      rating: (map['rating'] ?? 0).toDouble(),
      isPremium: map['is_premium'] ?? false,
    );
  }
}
