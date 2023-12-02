class PerfilAcessoModel {
  int? id;
  String name;
  String description;
  String user;

  PerfilAcessoModel(
    {
    int? id,  
    required this.name,
    required this.description,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'user': user,
    };
  }

  // Construtor para criar um objeto User a partir de um map.
  PerfilAcessoModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'],
        user = map['user'];
}