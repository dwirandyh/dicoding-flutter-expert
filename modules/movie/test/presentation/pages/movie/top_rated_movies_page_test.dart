import 'package:bloc_test/bloc_test.dart';
import 'package:movie/presentation/bloc/movie/top_rated_movie_bloc.dart';
import 'package:movie/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockTopRatedMovieBloc
    extends MockBloc<TopRatedMovieEvent, TopRatedMovieState>
    implements TopRatedMovieBloc {}

void main() {
  late MockTopRatedMovieBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMovieBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    final expectedStates = [
      TopRatedMovieInitial(),
      TopRatedMovieLoading(),
    ];

    whenListen(mockBloc, Stream.fromIterable(expectedStates),
        initialState: TopRatedMovieInitial());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));
    await tester.pump(Duration.zero);

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    final expectedStates = [
      TopRatedMovieInitial(),
      TopRatedMovieLoading(),
      TopRatedMovieHasData(const []),
    ];

    whenListen(mockBloc, Stream.fromIterable(expectedStates),
        initialState: TopRatedMovieInitial());

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));
    await tester.pump(Duration.zero);

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    final expectedStates = [
      TopRatedMovieInitial(),
      TopRatedMovieLoading(),
      TopRatedMovieError('failed')
    ];

    whenListen(mockBloc, Stream.fromIterable(expectedStates),
        initialState: TopRatedMovieInitial());

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));
    await tester.pump(Duration.zero);

    expect(textFinder, findsOneWidget);
  });
}
