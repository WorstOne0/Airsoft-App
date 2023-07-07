class User {
  late int id;

  User.fromJson(dynamic json) {
    id = json["id"] ?? 0;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    return json;
  }
}
