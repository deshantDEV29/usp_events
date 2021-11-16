class Session {
  int id = 0;
  int eventid = 0;
  String date = "";
  String time = "";
  String createdat = "";
  String updatedat = "";

  Session(this.id, this.eventid, this.date, this.time, this.createdat,
      this.updatedat);

  Session.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventid = json['event_id'];
    date = json['date'];
    time = json['time'];
    createdat = json['created_at'];
    updatedat = json['updated_at'];
  }
}
