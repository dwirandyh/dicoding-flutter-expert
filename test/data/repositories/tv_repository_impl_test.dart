import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv/tv_company_network_model.dart';
import 'package:ditonton/data/models/tv/tv_created_by_model.dart';
import 'package:ditonton/data/models/tv/tv_detail_model.dart';
import 'package:ditonton/data/models/tv/tv_model.dart';
import 'package:ditonton/data/models/tv/tv_production_country_model.dart';
import 'package:ditonton/data/models/tv/tv_spoken_language_model.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv_season.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_repository_impl_test.mocks.dart';


@GenerateMocks([TvRemoteDataSource])
void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;

  final testTvModel = TvModel(
      backdropPath: 'dummy backdrop',
      firstAirDate: DateTime(2017, 9, 7, 17, 30),
      genreIds: [1,2],
      id: 12,
      name: "dummy name",
      originCountry: ["dummy country"],
      originalLanguage: "dummy language",
      originalName: "dummy originalName",
      overview: "dummy overview",
      popularity: 4.8,
      posterPath: "dummy posterPath",
      voteAverage: 5,
      voteCount: 20
  );

  final testTv = Tv(
      firstAirDate: DateTime(2017, 9, 7, 17, 30),
      genreIds: [1,2],
      id: 12,
      name: "dummy name",
      originCountry: ["dummy country"],
      originalLanguage: "dummy language",
      originalName: "dummy originalName",
      overview: "dummy overview",
      popularity: 4.8,
      posterPath: "dummy posterPath",
      voteAverage: 5,
      voteCount: 20,
      backdropPath: 'dummy backdrop'
  );

  final testTvModels = <TvModel>[testTvModel];
  final testTvs = <Tv>[testTv];

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    repository = TvRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('Now Playing TV', () {
    test('should return remote data when the call to remote datasource is successful', () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTv()).thenAnswer((_) async => testTvModels);
      // act
      final result = await repository.getNowPlayingTv();
      // assert
      final resultList = result.getOrElse(() => []);
      verify(mockRemoteDataSource.getNowPlayingTv());
      expect(resultList, testTvs);
    });

    test('should return server error when the call to remote server failed', () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTv())
          .thenThrow(ServerException());
      // act
      final result = await repository.getNowPlayingTv();
      // assert
      verify(mockRemoteDataSource.getNowPlayingTv());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return conenction failure when the device has no internet', () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTv())
          .thenThrow(SocketException(''));
      // act
      final result = await repository.getNowPlayingTv();
      // assert
      verify(mockRemoteDataSource.getNowPlayingTv());
      expect(result, equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Recommendation TV', () {
    final tvId = 0;

    test('should return remote data when the call to remote datasource is successful', () async {
      // arrange
      when(mockRemoteDataSource.getTvRecommendations(tvId)).thenAnswer((_) async => testTvModels);
      // act
      final result = await repository.getTvRecommendations(tvId);
      // assert
      final resultList = result.getOrElse(() => []);
      verify(mockRemoteDataSource.getTvRecommendations(tvId));
      expect(resultList, testTvs);
    });

    test('should return server error when the call to remote server failed', () async {
      // arrange
      when(mockRemoteDataSource.getTvRecommendations(tvId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvRecommendations(tvId);
      // assert
      verify(mockRemoteDataSource.getTvRecommendations(tvId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when the device has no internet', () async {
      // arrange
      when(mockRemoteDataSource.getTvRecommendations(tvId))
          .thenThrow(SocketException(''));
      // act
      final result = await repository.getTvRecommendations(tvId);
      // assert
      verify(mockRemoteDataSource.getTvRecommendations(tvId));
      expect(result, equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Popular TV', () {
    test('should return remote data when the call to remote datasource is successful', () async {
      // arrange
      when(mockRemoteDataSource.getPopularTv()).thenAnswer((_) async => testTvModels);
      // act
      final result = await repository.getPopularTv();
      // assert
      final resultList = result.getOrElse(() => []);
      verify(mockRemoteDataSource.getPopularTv());
      expect(resultList, testTvs);
    });

    test('should return server error when the call to remote server failed', () async {
      // arrange
      when(mockRemoteDataSource.getPopularTv())
          .thenThrow(ServerException());
      // act
      final result = await repository.getPopularTv();
      // assert
      verify(mockRemoteDataSource.getPopularTv());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return conenction failure when the device has no internet', () async {
      // arrange
      when(mockRemoteDataSource.getPopularTv())
          .thenThrow(SocketException(''));
      // act
      final result = await repository.getPopularTv();
      // assert
      verify(mockRemoteDataSource.getPopularTv());
      expect(result, equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Top Rated TV', () {
    test('should return remote data when the call to remote datasource is successful', () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTv()).thenAnswer((_) async => testTvModels);
      // act
      final result = await repository.getTopRatedTv();
      // assert
      final resultList = result.getOrElse(() => []);
      verify(mockRemoteDataSource.getTopRatedTv());
      expect(resultList, testTvs);
    });

    test('should return server error when the call to remote server failed', () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTv())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTv();
      // assert
      verify(mockRemoteDataSource.getTopRatedTv());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return conenction failure when the device has no internet', () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTv())
          .thenThrow(SocketException(''));
      // act
      final result = await repository.getTopRatedTv();
      // assert
      verify(mockRemoteDataSource.getTopRatedTv());
      expect(result, equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Search TV', () {
    final query = "q";
    test('should return remote data when the call to remote datasource is successful', () async {
      // arrange
      when(mockRemoteDataSource.searchTv(query)).thenAnswer((_) async => testTvModels);
      // act
      final result = await repository.searchTv(query);
      // assert
      final resultList = result.getOrElse(() => []);
      verify(mockRemoteDataSource.searchTv(query));
      expect(resultList, testTvs);
    });

    test('should return server error when the call to remote server failed', () async {
      // arrange
      when(mockRemoteDataSource.searchTv(query))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchTv(query);
      // assert
      verify(mockRemoteDataSource.searchTv(query));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when the device has no internet', () async {
      // arrange
      when(mockRemoteDataSource.searchTv(query))
          .thenThrow(SocketException(''));
      // act
      final result = await repository.searchTv(query);
      // assert
      verify(mockRemoteDataSource.searchTv(query));
      expect(result, equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get TV Detail', () {
    final tvId = 1;
    final tvDetailModel = TvDetailModel(
        backdropPath: 'dummy backdrop',
        firstAirDate: DateTime(2017, 9, 7, 17, 30),
        id: 12,
        name: "dummy name",
        originCountry: ["dummy country"],
        originalLanguage: "dummy language",
        originalName: "dummy originalName",
        overview: "dummy overview",
        popularity: 4.8,
        posterPath: "dummy posterPath",
        voteAverage: 5,
        voteCount: 20,
        adult: false,
        createdBy: [TvCreatedByModel(id: 1, creditId: "1", name: "name", gender: 1, profilePath: "profilePath")],
        episodeRunTime: [],
        genres: [GenreModel(id: 1, name: "name")],
        homepage: "homepage",
        inProduction: true,
        languages: ["indonesia"],
        lastAirDate: DateTime(2017, 9, 7, 17, 30),
        lastEpisodeToAir: LastEpisodeToAir(airDate: DateTime(2017, 9, 7, 17, 30), episodeNumber: 1, id: 1, name: 'name', overview: 'overview', productionCode: '123', runtime: null, seasonNumber: 1, showId: 1, stillPath: 'path', voteAverage: 1, voteCount: 1),
        nextEpisodeToAir: "nextEpisodeToAir",
        networks: [TvCompanyNetworkModel(id: 1, name: "name", logoPath: "logoPath", originCountry: "originCountry")],
        numberOfEpisodes: 1,
        numberOfSeasons: 1,
        productionCompanies: [TvCompanyNetworkModel(id: 1, name: "name", logoPath: "logoPath", originCountry: "originCountry")],
        productionCountries: [ProductionCountryModel(iso31661: "iso31661", name: "name")],
        seasons: [TvSeasonModel(airDate: DateTime(2017, 9, 7, 17, 30), episodeCount: 1, id: 1, name: "name", overview: "overview", posterPath: "posterPath", seasonNumber: 1)],
        spokenLanguages: [SpokenLanguage(englishName: "englishName", iso6391: "iso6391", name: "name")],
        status: "status",
        tagline: "tagline",
        type: "type",
    );

    final tvDetail = TvDetail(
      backdropPath: 'dummy backdrop',
      firstAirDate: DateTime(2017, 9, 7, 17, 30),
      id: 12,
      name: "dummy name",
      genres: [Genre(id: 1, name: "name")],
      originCountry: ["dummy country"],
      originalLanguage: "dummy language",
      originalName: "dummy originalName",
      overview: "dummy overview",
      popularity: 4.8,
      posterPath: "dummy posterPath",
      voteAverage: 5,
      voteCount: 20,
      adult: false,
      episodeRunTime: [],
      homepage: "homepage",
      inProduction: true,
      languages: ["indonesia"],
      lastAirDate: DateTime(2017, 9, 7, 17, 30),
      nextEpisodeToAir: "nextEpisodeToAir",
      numberOfEpisodes: 1,
      numberOfSeasons: 1,
      seasons: [Season(airDate: DateTime(2017, 9, 7, 17, 30), episodeCount: 1, id: 1, name: "name", overview: "overview", posterPath: "posterPath", seasonNumber: 1)],
      status: "status",
      tagline: "tagline",
      type: "type",
    );



    test('should return remote data when the call to remote datasource is successful', () async {
      // arrange
      when(mockRemoteDataSource.getTvDetail(tvId))
          .thenAnswer((_) async => tvDetailModel);
      // act
      final result = await repository.getTvDetail(tvId);
      // assert
      verify(mockRemoteDataSource.getTvDetail(tvId));
      expect(result, equals(Right<Failure, TvDetail>(tvDetail)));
    });

    test('should return server error when the call to remote server failed', () async {
      // arrange
      when(mockRemoteDataSource.getTvDetail(tvId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvDetail(tvId);
      // assert
      verify(mockRemoteDataSource.getTvDetail(tvId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when the device has no internet', () async {
      // arrange
      when(mockRemoteDataSource.getTvDetail(tvId))
          .thenThrow(SocketException(''));
      // act
      final result = await repository.getTvDetail(tvId);
      // assert
      verify(mockRemoteDataSource.getTvDetail(tvId));
      expect(result, equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });
}





















