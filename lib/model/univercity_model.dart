class University {
  final int id;
  final String name;
  final String image;

  University({required this.id, required this.name, required this.image});

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}