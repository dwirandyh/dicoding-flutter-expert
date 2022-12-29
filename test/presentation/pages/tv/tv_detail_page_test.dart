import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv_season.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([TvDetailNotifier])
void main() {
  late MockTvDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

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

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(tvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when tv is added to wathclist',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(tvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(tvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(tvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('Should show loading indicator while fetching detail',
          (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(tvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final loadingIndicatorFinder = find.byType(CircularProgressIndicator);
    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(loadingIndicatorFinder, findsOneWidget);
  });

  testWidgets('Should show error message when failed load detail',
          (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Error);
    when(mockNotifier.tv).thenReturn(tvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.message).thenReturn('Failed to load data');

    final errorMessageFinder = find.text('Failed to load data');
    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(errorMessageFinder, findsOneWidget);
  });

  testWidgets('Should show recommendation lists successful',
          (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(tvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(testTvs);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final recommendationListFinder = find.byType(ListView);
    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(recommendationListFinder, findsOneWidget);
  });
}
