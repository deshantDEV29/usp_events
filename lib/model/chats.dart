class Chats {
  int id = 0;
  int senderid = 0;
  int recieverid = 0;
  String message = "";
  String createdat = "";
  String updatedat = "";

  Chats(this.id, this.senderid, this.recieverid, this.message, this.createdat,
      this.updatedat);

  Chats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderid = json['sender_id'];
    recieverid = json['reciever_id'];
    message = json['message'];
    createdat = json['created_at'];
    updatedat = json['updated_at'];
  }
}
