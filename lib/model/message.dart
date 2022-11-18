import 'dart:core';

class Message {
  final String message;
  final bool isUser;
  final int? timestamp;

  Message({required this.message, this.timestamp, this.isUser = false});

  Message.fromJson(Map<String, dynamic> json)
      : message = json['message'],
        timestamp = json['timestamp'] ?? 0,
        isUser = json['isUser'] ?? false;

  Map<String, dynamic> toJson() => {'message': message, 'timestamp': timestamp ?? 0};

  @override
  int get hashCode => Object.hash(message, timestamp ?? 0);

  @override
  bool operator ==(Object other) => super.hashCode == other.hashCode;
}
