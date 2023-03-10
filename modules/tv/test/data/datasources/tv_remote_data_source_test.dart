import 'dart:convert';
import 'dart:io';

import 'package:core/common/api_config.dart';
import 'package:core/common/exception.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/data/models/tv/tv_detail_model.dart';
import 'package:tv/data/models/tv/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('Get Now Playing Tv', () {
    const jsonFile = "dummy_data/tv_on_the_air.json";
    final tvList = TvResponse.fromJson(json.decode(readJson(jsonFile))).tvList;

    final uri = Uri.parse('$baseUrl/tv/on_the_air?$apiKey');

    test('should return list tv when response code is 200', () async {
      // arrange
      when(mockHttpClient.get(uri)).thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_on_the_air.json'), 200, headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
          }));
      // act
      final result = await dataSource.getNowPlayingTv();
      // assert
      expect(result, tvList);
    });

    test('should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(uri))
          .thenAnswer((_) async => http.Response('server exception', 404));
      // act
      final call = dataSource.getNowPlayingTv();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('Get Popular Tv', () {
    const jsonFile = "dummy_data/tv_popular.json";
    final tvList = TvResponse.fromJson(json.decode(readJson(jsonFile))).tvList;

    final uri = Uri.parse('$baseUrl/tv/popular?$apiKey');

    test('should return list tv when response code is 200', () async {
      // arrange
      when(mockHttpClient.get(uri)).thenAnswer((_) async => http.Response(
              readJson(jsonFile), 200, headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
          }));
      // act
      final result = await dataSource.getPopularTv();
      // assert
      expect(result, tvList);
    });

    test('should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(uri))
          .thenAnswer((_) async => http.Response('server exception', 404));
      // act
      final call = dataSource.getPopularTv();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('Get Top Rated Tv', () {
    const jsonFile = "dummy_data/tv_top_rated.json";
    final tvList = TvResponse.fromJson(json.decode(readJson(jsonFile))).tvList;

    final uri = Uri.parse('$baseUrl/tv/top_rated?$apiKey');

    test('should return list tv when response code is 200', () async {
      // arrange
      when(mockHttpClient.get(uri)).thenAnswer((_) async => http.Response(
              readJson(jsonFile), 200, headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
          }));
      // act
      final result = await dataSource.getTopRatedTv();
      // assert
      expect(result, tvList);
    });

    test('should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(uri))
          .thenAnswer((_) async => http.Response('server exception', 404));
      // act
      final call = dataSource.getTopRatedTv();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('Get Top Rated Tv', () {
    const jsonFile = "dummy_data/tv_search.json";
    final tvList = TvResponse.fromJson(json.decode(readJson(jsonFile))).tvList;

    const query = "dummy";
    final uri = Uri.parse('$baseUrl/search/tv?$apiKey&query=$query');

    test('should return list tv when response code is 200', () async {
      // arrange
      when(mockHttpClient.get(uri)).thenAnswer((_) async => http.Response(
              readJson(jsonFile), 200, headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
          }));
      // act
      final result = await dataSource.searchTv(query);
      // assert
      expect(result, tvList);
    });

    test('should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(uri))
          .thenAnswer((_) async => http.Response('server exception', 404));
      // act
      final call = dataSource.searchTv(query);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('Get Recommendation Tv', () {
    const jsonFile = "dummy_data/tv_recommendation.json";
    final tvList = TvResponse.fromJson(json.decode(readJson(jsonFile))).tvList;

    const id = 1;
    final uri = Uri.parse('$baseUrl/tv/$id/recommendations?$apiKey');

    test('should return list tv when response code is 200', () async {
      // arrange
      when(mockHttpClient.get(uri)).thenAnswer((_) async => http.Response(
              readJson(jsonFile), 200, headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
          }));
      // act
      final result = await dataSource.getTvRecommendations(id);
      // assert
      expect(result, tvList);
    });

    test('should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(uri))
          .thenAnswer((_) async => http.Response('server exception', 404));
      // act
      final call = dataSource.getTvRecommendations(id);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('Get Tv Detail', () {
    const jsonFile = "dummy_data/tv_detail.json";
    final tvDetail = TvDetailModel.fromJson(json.decode(readJson(jsonFile)));

    const id = 1;
    final uri = Uri.parse('$baseUrl/tv/$id?$apiKey');

    test('should return tv detail when response code is 200', () async {
      // arrange
      when(mockHttpClient.get(uri)).thenAnswer((_) async => http.Response(
              readJson(jsonFile), 200, headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
          }));
      // act
      final result = await dataSource.getTvDetail(id);
      // assert
      expect(result, tvDetail);
    });

    test('should throw ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(uri))
          .thenAnswer((_) async => http.Response('server exception', 404));
      // act
      final call = dataSource.getTvDetail(id);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
