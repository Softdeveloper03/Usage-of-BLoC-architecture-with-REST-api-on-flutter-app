class NameModel {
  final int id;
  final String name;

  NameModel({required this.id, required this.name});

  factory NameModel.fromJson(Map<String, dynamic> json) {
    return NameModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
