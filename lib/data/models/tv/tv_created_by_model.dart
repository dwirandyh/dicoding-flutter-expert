import 'dart:convert';

class TvCreatedByModel {
  TvCreatedByModel({
    required this.id,
    required this.creditId,
    required this.name,
    required this.gender,
    required this.profilePath,
  });

  final int id;
  final String creditId;
  final String name;
  final int gender;
  final String profilePath;

  factory TvCreatedByModel.fromRawJson(String str) => TvCreatedByModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TvCreatedByModel.fromJson(Map<String, dynamic> json) => TvCreatedByModel(
    id: json["id"],
    creditId: json["credit_id"],
    name: json["name"],
    gender: json["gender"],
    profilePath: json["profile_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "credit_id": creditId,
    "name": name,
    "gender": gender,
    "profile_path": profilePath,
  };
}