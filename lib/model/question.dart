class Question {
  int id = 0;
  int quizID = 0;
  String question = "";
  String option_1 = "";
  String option_2 = "";
  String option_3 = "";
  String option_4 = "";
  String answer = "";
  String response = "";

  Question(this.id, this.quizID, this.question, this.option_1, this.option_2,
      this.option_3, this.option_4, this.answer);

  Question.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    quizID = json["quizID"];
    question = json["question"];
    option_1 = json["option_1"];
    option_2 = json["option_2"];
    option_3 = json["option_3"];
    option_4 = json["option_4"];
    answer = json["answer"];
  }
  set setResponse(String res) {
    this.response = res;
  }
}
