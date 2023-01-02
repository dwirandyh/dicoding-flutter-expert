import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv/now_playing_tv_bloc.dart';
import 'package:ditonton/presentation/pages/tv/now_playing_tvs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNowPlayingTvBloc
    extends MockBloc<NowPlayingTvEvent, NowPlayingTvState>
    implements NowPlayingTvBloc {}

void main() {
  late MockNowPlayingTvBloc mockBloc;

  setUp(() {
    mockBloc = MockNowPlayingTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<NowPlayingTvBloc>(
      create: (_) => mockBloc,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (widgetTester) async {
    // arrange
    final expectedStates = [
      NowPlayingTvInitial(),
      NowPlayingTvLoading(),
    ];

    whenListen(mockBloc, Stream.fromIterable(expectedStates),
        initialState: NowPlayingTvInitial());

    // act
    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);
    await widgetTester.pumpWidget(_makeTestableWidget(NowPlayingTvsPage()));
    await widgetTester.pump(Duration.zero);

    // assert
    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (widgetTester) async {
    // arrange
    final expectedStates = [NowPlayingTvLoading(), NowPlayingTvHasData([])];

    whenListen(mockBloc, Stream.fromIterable(expectedStates),
        initialState: NowPlayingTvInitial());

    // act
    final listViewfinder = find.byType(ListView);
    await widgetTester.pumpWidget(_makeTestableWidget(NowPlayingTvsPage()));
    await widgetTester.pump(Duration.zero);
    // assert
    expect(listViewfinder, findsOneWidget);
  });
  //
  testWidgets('Page should display text when error', (widgetTester) async {
    // arrange
    final expectedStates = [
      NowPlayingTvLoading(),
      NowPlayingTvError('Failure')
    ];
    whenListen(mockBloc, Stream.fromIterable(expectedStates),
        initialState: NowPlayingTvInitial());

    // act
    final errorTextFinder = find.byKey(Key("error_message"));
    await widgetTester.pumpWidget(_makeTestableWidget(NowPlayingTvsPage()));
    await widgetTester.pump(Duration.zero);

    // asset
    expect(errorTextFinder, findsOneWidget);
  });
}
