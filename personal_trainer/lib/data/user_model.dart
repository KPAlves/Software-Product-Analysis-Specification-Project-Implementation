class UserModel {
  int? id;
  String name;
  DateTime birthDate;
  String gender;
  String phone;
  String email;

  UserModel({
    this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender,
      'phone': phone,
      'email': email,
    };
  }

  // Construtor para criar um objeto User a partir de um map.
  UserModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        birthDate = DateTime.parse(map['birthDate']),
        gender = map['gender'],
        phone = map['phone'],
        email = map['email'];
}