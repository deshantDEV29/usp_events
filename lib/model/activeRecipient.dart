class ActiveRecipient {
  int tokenableId = 0;
  String name = "";

  ActiveRecipient(this.tokenableId, this.name);

  ActiveRecipient.fromJson(Map<String, dynamic> json) {
    tokenableId = json["tokenable_id"];
    name = json["name"];
  }
}
