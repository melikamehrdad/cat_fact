import 'dart:convert';

List<Cat> catFromJson(String str) => List<Cat>.from(json.decode(str).map((x) => Cat.fromJson(x)));

String catToJson(List<Cat> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cat {
  final String id;
  final String user;
  final String text;
  final String image;
  final int v;
  final DateTime updatedAt;
  final String type;
  final DateTime createdAt;
  final bool deleted;

  Cat({
    required this.id,
    required this.user,
    required this.text,
    required this.image,
    required this.v,
    required this.updatedAt,
    required this.type,
    required this.createdAt,
    required this.deleted,
  });

  factory Cat.fromJson(Map<String, dynamic> json) => Cat(
    id: json["_id"],
    user: json["user"],
    text: json["text"],
    image: json["image"],
    v: json["__v"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    type: json["type"],
    createdAt: DateTime.parse(json["createdAt"]),
    deleted: json["deleted"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "text": text,
    "image": image,
    "__v": v,
    "updatedAt": updatedAt.toIso8601String(),
    "type": type,
    "createdAt": createdAt.toIso8601String(),
    "deleted": deleted,
  };
}


class Status {
  final bool verified;
  final int sentCount;

  Status({
    required this.verified,
    required this.sentCount,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    verified: json["verified"],
    sentCount: json["sentCount"],
  );

  Map<String, dynamic> toJson() => {
    "verified": verified,
    "sentCount": sentCount,
  };
}

