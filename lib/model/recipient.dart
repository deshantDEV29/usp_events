class Recipient {
  int id = 0;
  String name = "";

  Recipient(this.id, this.name);

  Recipient.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }
}
