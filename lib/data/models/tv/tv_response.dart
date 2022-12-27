import 'dart:convert';
import 'package:ditonton/data/models/tv/tv_model.dart';

class TvResponse {
    TvResponse({
        required this.page,
        required this.tvList,
        required this.totalPages,
        required this.totalResults,
    });

    final int page;
    final List<TvModel> tvList;
    final int totalPages;
    final int totalResults;

    factory TvResponse.fromRawJson(String str) => TvResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TvResponse.fromJson(Map<String, dynamic> json) => TvResponse(
        page: json["page"],
        tvList: List<TvModel>.from(json["results"].map((x) => TvModel.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "tvList": List<dynamic>.from(tvList.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };
}
