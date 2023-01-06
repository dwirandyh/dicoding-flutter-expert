import 'package:bloc_test/bloc_test.dart';
import 'package:tv/domain/entities/genre.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/entities/tv_season.dart';
import 'package:tv/presentation/bloc/tv/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv/tv_recommendation_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist/watchlist_status_bloc.dart';
import 'package:tv/presentation/pages/tv/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

class MockTvRecommendationBloc
    extends MockBloc<TvRecommendationEvent, TvRecommendationState>
    implements TvRecommendationBloc {}

class MockWatchlistStatus
    extends MockBloc<WatchlistStatusEvent, WatchlistStatusState>
    implements WatchlistStatusBloc {}

void main() {
  late MockTvDetailBloc mockTvDetailBloc;
  late MockTvRecommendationBloc mockTvRecommendationBloc;
  late MockWatchlistStatus mockWatchlistStatus;

  setUp(() {
    mockTvDetailBloc = MockTvDetailBloc();
    mockTvRecommendationBloc = MockTvRecommendationBloc();
    mockWatchlistStatus = MockWatchlistStatus();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvDetailBloc>.value(value: mockTvDetailBloc),
        BlocProvider<TvRecommendationBloc>.value(
            value: mockTvRecommendationBloc),
        BlocProvider<WatchlistStatusBloc>.value(value: mockWatchlistStatus),
      ],
      child: MaterialApp(home: body),
    );
  }

  final tvDetail = TvDetail(
    backdropPath: 'dummy backdrop',
    firstAirDate: DateTime(2017, 9, 7, 17, 30),
    id: 12,
    name: "dummy name",
    genres: const [Genre(id: 1, name: "name")],
    originCountry: const ["dummy country"],
    originalLanguage: "dummy language",
    originalName: "dummy originalName",
    overview: "dummy overview",
    popularity: 4.8,
    posterPath: "dummy posterPath",
    voteAverage: 5,
    voteCount: 20,
    adult: false,
    episodeRunTime: const [],
    homepage: "homepage",
    inProduction: true,
    languages: const ["indonesia"],
    lastAirDate: DateTime(2017, 9, 7, 17, 30),
    nextEpisodeToAir: "nextEpisodeToAir",
    numberOfEpisodes: 1,
    numberOfSeasons: 1,
    seasons: [
      Season(
          airDate: DateTime(2017, 9, 7, 17, 30),
          episodeCount: 1,
          id: 1,
          name: "name",
          overview: "overview",
          posterPath: "posterPath",
          seasonNumber: 1)
    ],
    status: "status",
    tagline: "tagline",
    type: "type",
  );

  final testTv = Tv(
      firstAirDate: DateTime(2017, 9, 7, 17, 30),
      genreIds: const [1, 2],
      id: 12,
      name: "dummy name",
      originCountry: const ["dummy country"],
      originalLanguage: "dummy language",
      originalName: "dummy originalName",
      overview: "dummy overview",
      popularity: 4.8,
      posterPath: "dummy posterPath",
      voteAverage: 5,
      voteCount: 20,
      backdropPath: 'dummy backdrop');

  final testTvs = [testTv];

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    whenListen(
      mockTvDetailBloc,
      Stream.fromIterable([
        TvDetailHasData(tvDetail),
      ]),
      initialState: TvDetailLoading(),
    );

    whenListen(
      mockTvRecommendationBloc,
      Stream.fromIterable([
        TvRecommendationHasData(testTvs),
      ]),
      initialState: TvRecommendationLoading(),
    );

    whenListen(
      mockWatchlistStatus,
      Stream.fromIterable([
        WatchlistStatusState(isExists: false, isSuccess: true),
      ]),
      initialState: WatchlistStatusState(
          isExists: false, isSuccess: true, additionalMessage: ""),
    );

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
    await tester.pump(Duration.zero);

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv is added to wathclist',
      (WidgetTester tester) async {
    whenListen(
      mockTvDetailBloc,
      Stream.fromIterable([
        TvDetailHasData(tvDetail),
      ]),
      initialState: TvDetailLoading(),
    );

    whenListen(
      mockTvRecommendationBloc,
      Stream.fromIterable([
        TvRecommendationHasData(testTvs),
      ]),
      initialState: TvRecommendationLoading(),
    );

    whenListen(
      mockWatchlistStatus,
      Stream.fromIterable([
        WatchlistStatusState(isExists: true, isSuccess: true),
      ]),
      initialState: WatchlistStatusState(
          isExists: true, isSuccess: true, additionalMessage: ""),
    );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
    await tester.pump(Duration.zero);

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Should show loading indicator when fetching detail',
      (WidgetTester tester) async {
    whenListen(
      mockTvDetailBloc,
      Stream.fromIterable([TvDetailLoading()]),
      initialState: TvDetailLoading(),
    );

    final loadingIndicatorFinder = find.byType(CircularProgressIndicator);
    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
    await tester.pump(Duration.zero);

    expect(loadingIndicatorFinder, findsOneWidget);
  });

  testWidgets('Should show error message when failed load detail',
      (WidgetTester tester) async {
    whenListen(
      mockTvDetailBloc,
      Stream.fromIterable([
        const TvDetailError("Failed to load data"),
      ]),
      initialState: TvDetailLoading(),
    );

    final errorMessageFinder = find.text('Failed to load data');
    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
    await tester.pump(Duration.zero);

    expect(errorMessageFinder, findsOneWidget);
  });

  testWidgets('Should show recommendation lists successful',
      (WidgetTester tester) async {
    whenListen(
      mockTvDetailBloc,
      Stream.fromIterable([
        TvDetailHasData(tvDetail),
      ]),
      initialState: TvDetailLoading(),
    );

    whenListen(
      mockTvRecommendationBloc,
      Stream.fromIterable([
        TvRecommendationHasData(testTvs),
      ]),
      initialState: TvRecommendationLoading(),
    );

    whenListen(
      mockWatchlistStatus,
      Stream.fromIterable([
        WatchlistStatusState(isExists: true, isSuccess: true),
      ]),
      initialState: WatchlistStatusState(isExists: true, isSuccess: true),
    );

    final recommendationListFinder =
        find.byKey(const Key('tv-detail-recommendation-listview'));
    await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
    await tester.pump(Duration.zero);

    expect(recommendationListFinder, findsOneWidget);
  });
}
