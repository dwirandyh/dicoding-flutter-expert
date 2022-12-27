import 'dart:convert';

class TvCompanyNetworkModel {
  TvCompanyNetworkModel({
    required this.id,
    required this.name,
    required this.logoPath,
    required this.originCountry,
  });

  final int id;
  final String name;
  final String? logoPath;
  final String originCountry;

  factory TvCompanyNetworkModel.fromRawJson(String str) => TvCompanyNetworkModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TvCompanyNetworkModel.fromJson(Map<String, dynamic> json) => TvCompanyNetworkModel(
    id: json["id"],
    name: json["name"],
    logoPath: json["logo_path"] == null ? null : json["logo_path"],
    originCountry: json["origin_country"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "logo_path": logoPath == null ? null : logoPath,
    "origin_country": originCountry,
  };
}