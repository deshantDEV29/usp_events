class EventsTitle {
  String title = "";
  String eventSchedule = "";

  EventsTitle(this.title, this.eventSchedule);

  EventsTitle.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    eventSchedule = json["event_schedule"];
  }
}
