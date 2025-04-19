// In univercity_model.dart
class University {
  final int id; // Make sure this is int, not String
  final String name;
  final String image;

  University({required this.id, required this.name, required this.image});

  factory University.fromJson(Map<String, dynamic> json) {
    // Convert ID to int if it's a string in the JSON
    int id = json['id'] is String ? int.parse(json['id']) : json['id'];

    return University(
      id: id,
      name: json['name'],
      image: json['image'],
    );
  }
}