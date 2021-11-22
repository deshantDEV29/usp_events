class FAQ {
  int id = 0;
  String question = "";
  String answer = "";

  FAQ(this.id, this.question, this.answer);

  FAQ.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
  }
}
