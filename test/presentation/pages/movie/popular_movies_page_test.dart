import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie/popular_movie_bloc.dart';
import 'package:ditonton/presentation/pages/movie/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';


class MockPopularMovieBloc
    extends MockBloc<PopularMovieEvent, PopularMovieState>
    implements PopularMovieBloc {}

void main() {
  late MockPopularMovieBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularMovieBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    final expectedStates = [
      PopularMovieInitial(),
      PopularMovieLoading(),
    ];

    whenListen(mockBloc, Stream.fromIterable(expectedStates),
        initialState: PopularMovieInitial());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));
    await tester.pump(Duration.zero);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    final expectedStates = [
      PopularMovieInitial(),
      PopularMovieLoading(),
      PopularMovieHasData([]),
    ];

    whenListen(mockBloc, Stream.fromIterable(expectedStates),
        initialState: PopularMovieInitial());

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));
    await tester.pump(Duration.zero);

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    final expectedStates = [
      PopularMovieInitial(),
      PopularMovieLoading(),
      PopularMovieError('Failure'),
    ];

    whenListen(mockBloc, Stream.fromIterable(expectedStates),
        initialState: PopularMovieInitial());

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));
    await tester.pump(Duration.zero);

    expect(textFinder, findsOneWidget);
  });
}
