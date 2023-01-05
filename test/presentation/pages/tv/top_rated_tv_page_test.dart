import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tvs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockTopRatedTvBloc extends MockBloc<TopRatedTvEvent, TopRatedTvState>
    implements TopRatedTvBloc {}

void main() {
  late MockTopRatedTvBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (widgetTester) async {
    // arrange
    final expectedStates = [
      TopRatedTvInitial(),
      TopRatedTvLoading(),
    ];

    whenListen(mockBloc, Stream.fromIterable(expectedStates),
        initialState: TopRatedTvInitial());

    // act
    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);
    await widgetTester.pumpWidget(_makeTestableWidget(TopRatedTvsPage()));
    await widgetTester.pump(Duration.zero);

    // assert
    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (widgetTester) async {
    // arrange
    final expectedStates = [TopRatedTvLoading(), TopRatedTvHasData([])];

    whenListen(mockBloc, Stream.fromIterable(expectedStates),
        initialState: TopRatedTvInitial());

    // act
    final listViewfinder = find.byType(ListView);
    await widgetTester.pumpWidget(_makeTestableWidget(TopRatedTvsPage()));
    await widgetTester.pump(Duration.zero);
    // assert
    expect(listViewfinder, findsOneWidget);
  });
  //
  testWidgets('Page should display text when error', (widgetTester) async {
    // arrange
    final expectedStates = [TopRatedTvLoading(), TopRatedTvError('Failure')];
    whenListen(mockBloc, Stream.fromIterable(expectedStates),
        initialState: TopRatedTvInitial());

    // act
    final errorTextFinder = find.byKey(Key("error_message"));
    await widgetTester.pumpWidget(_makeTestableWidget(TopRatedTvsPage()));
    await widgetTester.pump(Duration.zero);

    // asset
    expect(errorTextFinder, findsOneWidget);
  });
}
