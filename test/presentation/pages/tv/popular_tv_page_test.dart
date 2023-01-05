import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:ditonton/presentation/pages/tv/popular_tvs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockPopularTvBloc extends MockBloc<PopularTvEvent, PopularTvState>
    implements PopularTvBloc {}

void main() {
  late MockPopularTvBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvBloc>.value(
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
      PopularTvInitial(),
      PopularTvLoading(),
    ];

    whenListen(mockBloc, Stream.fromIterable(expectedStates),
        initialState: PopularTvInitial());

    // act
    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);
    await widgetTester.pumpWidget(_makeTestableWidget(PopularTvsPage()));
    await widgetTester.pump(Duration.zero);

    // assert
    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (widgetTester) async {
    // arrange
    final expectedStates = [PopularTvLoading(), PopularTvHasData([])];

    whenListen(mockBloc, Stream.fromIterable(expectedStates),
        initialState: PopularTvInitial());

    // act
    final listViewfinder = find.byType(ListView);
    await widgetTester.pumpWidget(_makeTestableWidget(PopularTvsPage()));
    await widgetTester.pump(Duration.zero);
    // assert
    expect(listViewfinder, findsOneWidget);
  });
  //
  testWidgets('Page should display text when error', (widgetTester) async {
    // arrange
    final expectedStates = [PopularTvLoading(), PopularTvError('Failure')];
    whenListen(mockBloc, Stream.fromIterable(expectedStates),
        initialState: PopularTvInitial());

    // act
    final errorTextFinder = find.byKey(Key("error_message"));
    await widgetTester.pumpWidget(_makeTestableWidget(PopularTvsPage()));
    await widgetTester.pump(Duration.zero);

    // asset
    expect(errorTextFinder, findsOneWidget);
  });
}
