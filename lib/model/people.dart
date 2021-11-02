class People {
  int id = 0;
  String name = "";

  People(this.id, this.name);

  People.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }
}
