class ExerciseModel {
  int? id;
  String name;
  String description;
  String image;

  ExerciseModel({
    this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
    };
  }

  // Construtor para criar um objeto User a partir de um map.
  ExerciseModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'],
        image = map['image'];
}