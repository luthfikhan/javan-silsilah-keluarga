class UserModel {
  final String name;
  final int id;
  final int genderId;
  final int ortuId;
  final int status;

  UserModel(
      {this.name = '',
      this.id,
      this.genderId = 0,
      this.ortuId = 0,
      this.status = 0});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "id_user": id,
      "gender": genderId,
      "id_ortu": ortuId,
      "status": status
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'],
        id: json['id_user'],
        genderId: json['gender'],
        ortuId: json['id_ortu'],
        status: json['status']);
  }
}
