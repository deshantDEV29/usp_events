class Events {
  int eventid = 0;
  String title = "";
  String eventSchedule = "";
  String venue = "";
  String theme = "";
  String speaker = "";
  String eventDescription = "";
  String createdAt = "";
  String updatedAt = "";

  Events(this.eventid, this.title, this.eventSchedule, this.venue, this.theme,
      this.speaker, this.eventDescription, this.createdAt, this.updatedAt);

  Events.fromJson(Map<String, dynamic> json) {
    eventid = json['id'];
    title = json['title'];
    eventSchedule = json['event_schedule'];
    venue = json['venue'];
    theme = json['theme'];
    speaker = json['speaker'];
    eventDescription = json['event_description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
