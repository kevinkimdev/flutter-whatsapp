import 'dart:convert';

class Message {
  String content;
  DateTime timestamp;
  bool isYou;
  bool isRead;

  Message({
    this.content,
    this.timestamp,
    this.isYou,
    this.isRead,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return new Message(
      content: json["content"],
      timestamp: DateTime.parse(json["timestamp"]),
      isYou: json["isYou"],
      isRead: json["isRead"],
    );
  }
}

Chat chatFromJson(String str) {
  final jsonData = json.decode(str);
  return Chat.fromJson(jsonData);
}

Chat chatFromJsonFull(String str) {
  final jsonData = json.decode(str);
  return Chat.fromJsonFull(jsonData);
}

class Chat {
  int id;
  String name;
  String avatarUrl;
  Message lastMessage;
  List<Message> messages;

  Chat({
    this.id,
    this.name,
    this.avatarUrl,
    this.lastMessage,
    this.messages,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return new Chat(
      id: json["id"],
      name: json["name"],
      avatarUrl: json["avatarPath"],
      lastMessage: Message.fromJson(json["lastMessage"]),
    );
  }

  factory Chat.fromJsonFull(Map<String, dynamic> json) {
    List<Message> messages = new List<Message>();
    messages = json["messages"].map<Message>((i) => Message.fromJson(i)).toList();
    print(messages);

    return new Chat(
      id: json["id"],
      name: json["name"],
      avatarUrl: json["avatarPath"],
      messages: messages,
    );
  }
}
