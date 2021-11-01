class Quiz {
  int id = 0;
  String name = "";

  Quiz(this.id, this.name);

  Quiz.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }
}
