import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_recommendation_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_status_bloc.dart';
import 'package:ditonton/presentation/pages/movie/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MockMovieRecommendationBloc
    extends MockBloc<MovieRecommendationEvent, MovieRecommendationState>
    implements MovieRecommendationBloc {}

class MockWatchlistStatus
    extends MockBloc<WatchlistStatusEvent, WatchlistStatusState>
    implements WatchlistStatusBloc {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieRecommendationBloc mockMovieRecommendationBloc;
  late MockWatchlistStatus mockWatchlistStatus;

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockMovieRecommendationBloc = MockMovieRecommendationBloc();
    mockWatchlistStatus = MockWatchlistStatus();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>.value(value: mockMovieDetailBloc),
        BlocProvider<MovieRecommendationBloc>.value(
            value: mockMovieRecommendationBloc),
        BlocProvider<WatchlistStatusBloc>.value(value: mockWatchlistStatus),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    whenListen(
      mockMovieDetailBloc,
      Stream.fromIterable([
        MovieDetailHasData(testMovieDetail),
      ]),
      initialState: MovieDetailLoading(),
    );

    whenListen(
      mockMovieRecommendationBloc,
      Stream.fromIterable([
        MovieRecommendationHasData([]),
      ]),
      initialState: MovieRecommendationLoading(),
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

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.pump(Duration.zero);

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    whenListen(
      mockMovieDetailBloc,
      Stream.fromIterable([
        MovieDetailHasData(testMovieDetail),
      ]),
      initialState: MovieDetailLoading(),
    );

    whenListen(
      mockMovieRecommendationBloc,
      Stream.fromIterable([
        MovieRecommendationHasData([]),
      ]),
      initialState: MovieRecommendationLoading(),
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

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.pump(Duration.zero);

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Should show loading indicator while fetching detail',
      (WidgetTester tester) async {
    whenListen(
      mockMovieDetailBloc,
      Stream.fromIterable([MovieDetailLoading()]),
      initialState: MovieDetailLoading(),
    );

    final loadingIndicatorFinder = find.byType(CircularProgressIndicator);
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(loadingIndicatorFinder, findsOneWidget);
  });

  testWidgets('Should show error message when failed load detail',
      (WidgetTester tester) async {
    whenListen(
      mockMovieDetailBloc,
      Stream.fromIterable([
        MovieDetailError("Failed to load data"),
      ]),
      initialState: MovieDetailLoading(),
    );

    final errorMessageFinder = find.text('Failed to load data');
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.pump(Duration.zero);

    expect(errorMessageFinder, findsOneWidget);
  });

  testWidgets('Should show recommendation lists successful',
      (WidgetTester tester) async {
    whenListen(
      mockMovieDetailBloc,
      Stream.fromIterable([
        MovieDetailHasData(testMovieDetail),
      ]),
      initialState: MovieDetailLoading(),
    );

    whenListen(
      mockMovieRecommendationBloc,
      Stream.fromIterable([
        MovieRecommendationHasData(testMovieList),
      ]),
      initialState: MovieRecommendationLoading(),
    );

    whenListen(
      mockWatchlistStatus,
      Stream.fromIterable([
        WatchlistStatusState(isExists: true, isSuccess: true),
      ]),
      initialState: WatchlistStatusState(isExists: true, isSuccess: true),
    );

    final recommendationListFinder = find.byType(ListView);
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.pump(Duration.zero);

    expect(recommendationListFinder, findsOneWidget);
  });
}
