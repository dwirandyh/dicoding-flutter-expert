import 'dart:convert';

import 'package:core/common/api_config.dart';
import 'package:core/common/exception.dart';
import 'package:tv/data/models/tv/tv_detail_model.dart';
import 'package:tv/data/models/tv/tv_model.dart';
import 'package:tv/data/models/tv/tv_response.dart';
import 'package:http/http.dart' as http;

abstract class TvRemoteDataSource {
  Future<List<TvModel>> getNowPlayingTv();
  Future<List<TvModel>> getPopularTv();
  Future<List<TvModel>> getTopRatedTv();
  Future<TvDetailModel> getTvDetail(int id);
  Future<List<TvModel>> getTvRecommendations(int id);
  Future<List<TvModel>> searchTv(String query);
}

class TvRemoteDataSourceImpl implements TvRemoteDataSource {
  final http.Client client;

  TvRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvModel>> getNowPlayingTv() async {
    final response =
        await client.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey'));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getPopularTv() async {
    final response = await client.get(Uri.parse('$baseUrl/tv/popular?$apiKey'));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTopRatedTv() async {
    final response =
        await client.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey'));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTvRecommendations(int id) async {
    final response =
        await client.get(Uri.parse('$baseUrl/tv/$id/recommendations?$apiKey'));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> searchTv(String query) async {
    final response =
        await client.get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$query'));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailModel> getTvDetail(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/tv/$id?$apiKey'));

    if (response.statusCode == 200) {
      return TvDetailModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
