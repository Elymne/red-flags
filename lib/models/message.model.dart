class Message {
  final String id;
  final String value;

  Message({required this.id, required this.value});

  Map<String, dynamic> toJson() {
    return {'id': id, 'value': value};
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(id: json['id'] as String, value: json['value'] as String);
  }

  Message copyWith({String? id, String? value}) {
    return Message(id: id ?? this.id, value: value ?? this.value);
  }
}
