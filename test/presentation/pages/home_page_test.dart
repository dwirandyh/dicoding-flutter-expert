import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/presentation/bloc/movie/now_playing_movie_bloc.dart';
import 'package:movie/presentation/bloc/movie/popular_movie_bloc.dart';
import 'package:movie/presentation/bloc/movie/top_rated_movie_bloc.dart';
import 'package:movie/presentation/pages/movie/home_movie_page.dart';

class MockNowPlayingMovieBloc
    extends MockBloc<NowPlayingMovieEvent, NowPlayingMovieState>
    implements NowPlayingMovieBloc {}

class MockPopularMovieBloc
    extends MockBloc<PopularMovieEvent, PopularMovieState>
    implements PopularMovieBloc {}

class MockTopRatedMovieBloc
    extends MockBloc<TopRatedMovieEvent, TopRatedMovieState>
    implements TopRatedMovieBloc {}

void main() {
  late MockNowPlayingMovieBloc mockNowPlayingMovieBloc;
  late MockPopularMovieBloc mockPopularMovieBloc;
  late MockTopRatedMovieBloc mockTopRatedMovieBloc;

  setUp(() {
    mockNowPlayingMovieBloc = MockNowPlayingMovieBloc();
    mockPopularMovieBloc = MockPopularMovieBloc();
    mockTopRatedMovieBloc = MockTopRatedMovieBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingMovieBloc>.value(value: mockNowPlayingMovieBloc),
        BlocProvider<PopularMovieBloc>.value(value: mockPopularMovieBloc),
        BlocProvider<TopRatedMovieBloc>.value(value: mockTopRatedMovieBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('should show movie home page and search button ',
      (widgetTester) async {
    whenListen(mockNowPlayingMovieBloc,
        Stream.fromIterable([NowPlayingMovieLoading()]),
        initialState: NowPlayingMovieLoading());
    whenListen(
        mockPopularMovieBloc, Stream.fromIterable([PopularMovieLoading()]),
        initialState: PopularMovieLoading());
    whenListen(
        mockTopRatedMovieBloc, Stream.fromIterable([TopRatedMovieLoading()]),
        initialState: TopRatedMovieLoading());

    final searchButtonFinder = find.byKey(Key('home.button.search-button'));
    final movieHomePageFinder = find.byType(HomeMoviePage);
    await widgetTester.pumpWidget(makeTestableWidget(HomePage()));

    expect(movieHomePageFinder, findsOneWidget);
    expect(searchButtonFinder, findsOneWidget);
  });
}
