import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv_season.dart';
import 'package:ditonton/domain/entities/watchlist.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendation.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'tv_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendation,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late TvDetailNotifier provider;
  late MockGetTvDetail mockGetTvDetail;
  late GetTvRecommendation mockGetTvRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendation();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    provider = TvDetailNotifier(
        getTvDetail: mockGetTvDetail,
        getTvRecommendations: mockGetTvRecommendations,
        getWatchListStatus: mockGetWatchlistStatus,
        saveWatchlist: mockSaveWatchlist,
        removeWatchlist: mockRemoveWatchlist
    )..addListener(() {
      listenerCallCount += 1;
    });
  });

  final tId = 1;

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
  final tv = Tv(
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
  final tvs = <Tv>[tv];

  void _arrangeUsecase() {
    when(mockGetTvDetail.execute(tId))
        .thenAnswer((_) async => Right(tvDetail));
    when(mockGetTvRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tvs));
  }

  group('Get Movie Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvDetail(tId);
      // assert
      verify(mockGetTvDetail.execute(tId));
      verify(mockGetTvRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchTvDetail(tId);
      // assert
      expect(provider.tvState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change movie when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.tvState, RequestState.Loaded);
      expect(provider.tv, tvDetail);
      expect(listenerCallCount, 3);
    });

    test('should change recommendation movies when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.tvState, RequestState.Loaded);
      expect(provider.tv, tvDetail);
    });
  });

  group('Get Movie Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvDetail(tId);
      // assert
      verify(mockGetTvRecommendations.execute(tId));
      expect(provider.tvRecommendations, tvs);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Loaded);
      expect(provider.tvRecommendations, tvs);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(tvDetail));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      final testWatchlist = Watchlist(
          id: tvDetail.id,
          title: tvDetail.originalName,
          posterPath: tvDetail.posterPath,
          overview: tvDetail.overview,
          type: WatchListType.tv
      );
      when(mockSaveWatchlist.execute(testWatchlist))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatus.execute(testWatchlist.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(tvDetail);
      // assert
      verify(mockSaveWatchlist.execute(testWatchlist));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      final testWatchlist = Watchlist(
          id: tvDetail.id,
          title: tvDetail.originalName,
          posterPath: tvDetail.posterPath,
          overview: tvDetail.overview,
          type: WatchListType.tv
      );
      when(mockRemoveWatchlist.execute(testWatchlist))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatus.execute(tvDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(tvDetail);
      // assert
      verify(mockRemoveWatchlist.execute(testWatchlist));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      final testWatchlist = Watchlist(
          id: tvDetail.id,
          title: tvDetail.originalName,
          posterPath: tvDetail.posterPath,
          overview: tvDetail.overview,
          type: WatchListType.tv
      );
      when(mockSaveWatchlist.execute(testWatchlist))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(tvDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(tvDetail);
      // assert
      verify(mockGetWatchlistStatus.execute(tvDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      final testWatchlist = Watchlist(
          id: tvDetail.id,
          title: tvDetail.originalName,
          posterPath: tvDetail.posterPath,
          overview: tvDetail.overview,
          type: WatchListType.tv
      );
      when(mockSaveWatchlist.execute(testWatchlist))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(tvDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addWatchlist(tvDetail);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tvs));
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.tvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
