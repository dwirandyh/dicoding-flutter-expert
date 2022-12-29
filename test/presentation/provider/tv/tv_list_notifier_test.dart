
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_playing_tv_notifier_test.mocks.dart';
import 'popular_tv_notifier_test.mocks.dart';
import 'top_rated_tv_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTv, GetPopularTv, GetTopRatedTv])
void main() {
    late TvListNotifier provider;
    late MockGetNowPlayingTv mockGetNowPlayingTv;
    late MockGetPopularTv mockGetPopularTv;
    late MockGetTopRatedTv mockGetTopRatedTv;
    late int listenerCallCount;

    setUp(() {
      listenerCallCount = 0;
      mockGetNowPlayingTv = MockGetNowPlayingTv();
      mockGetPopularTv = MockGetPopularTv();
      mockGetTopRatedTv = MockGetTopRatedTv();
      provider = TvListNotifier(
          getNowPlayingTv: mockGetNowPlayingTv,
          getPopularTv: mockGetPopularTv,
          getTopRatedTv: mockGetTopRatedTv
      )..addListener(() {
        listenerCallCount += 1;
      });
    });

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
    final testTvs = [testTv];

    group('now playing movies', () {
      test('initialState should be Empty', () {
        expect(provider.nowPlayingState, equals(RequestState.Empty));
      });

      test('should get data from the usecase', () async {
        // arrange
        when(mockGetNowPlayingTv.execute())
            .thenAnswer((_) async => Right(testTvs));
        // act
        provider.fetchNowPlayingTvs();
        // assert
        verify(mockGetNowPlayingTv.execute());
      });

      test('should change state to Loading when usecase is called', () {
        // arrange
        when(mockGetNowPlayingTv.execute())
            .thenAnswer((_) async => Right(testTvs));
        // act
        provider.fetchNowPlayingTvs();
        // assert
        expect(provider.nowPlayingState, RequestState.Loading);
      });

      test('should change movies when data is gotten successfully', () async {
        // arrange
        when(mockGetNowPlayingTv.execute())
            .thenAnswer((_) async => Right(testTvs));
        // act
        await provider.fetchNowPlayingTvs();
        // assert
        expect(provider.nowPlayingState, RequestState.Loaded);
        expect(provider.nowPlayingTvs, testTvs);
        expect(listenerCallCount, 2);
      });

      test('should return error when data is unsuccessful', () async {
        // arrange
        when(mockGetNowPlayingTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        // act
        await provider.fetchNowPlayingTvs();
        // assert
        expect(provider.nowPlayingState, RequestState.Error);
        expect(provider.message, 'Server Failure');
        expect(listenerCallCount, 2);
      });
    });

    group('popular movies', () {
      test('should change state to loading when usecase is called', () async {
        // arrange
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Right(testTvs));
        // act
        provider.fetchPopularTvs();
        // assert
        expect(provider.popularTvState, RequestState.Loading);
        // verify(provider.setState(RequestState.Loading));
      });

      test('should change movies data when data is gotten successfully',
              () async {
            // arrange
            when(mockGetPopularTv.execute())
                .thenAnswer((_) async => Right(testTvs));
            // act
            await provider.fetchPopularTvs();
            // assert
            expect(provider.popularTvState, RequestState.Loaded);
            expect(provider.popularTvs, testTvs);
            expect(listenerCallCount, 2);
          });

      test('should return error when data is unsuccessful', () async {
        // arrange
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        // act
        await provider.fetchPopularTvs();
        // assert
        expect(provider.popularTvState, RequestState.Error);
        expect(provider.message, 'Server Failure');
        expect(listenerCallCount, 2);
      });
    });

    group('top rated movies', () {
      test('should change state to loading when usecase is called', () async {
        // arrange
        when(mockGetTopRatedTv.execute())
            .thenAnswer((_) async => Right(testTvs));
        // act
        provider.fetchTopRatedTvs();
        // assert
        expect(provider.topRatedTvsState, RequestState.Loading);
      });

      test('should change movies data when data is gotten successfully',
              () async {
            // arrange
            when(mockGetTopRatedTv.execute())
                .thenAnswer((_) async => Right(testTvs));
            // act
            await provider.fetchTopRatedTvs();
            // assert
            expect(provider.topRatedTvsState, RequestState.Loaded);
            expect(provider.topRatedTvs, testTvs);
            expect(listenerCallCount, 2);
          });

      test('should return error when data is unsuccessful', () async {
        // arrange
        when(mockGetTopRatedTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        // act
        await provider.fetchTopRatedTvs();
        // assert
        expect(provider.topRatedTvsState, RequestState.Error);
        expect(provider.message, 'Server Failure');
        expect(listenerCallCount, 2);
      });
    });
}