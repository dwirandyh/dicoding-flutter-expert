import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/tv/popular_tvs_page.dart';
import 'package:ditonton/presentation/provider/tv/popular_tvs_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'popular_tv_page_test.mocks.dart';

@GenerateMocks([PopularTvsNotifier])
void main() {
  late MockPopularTvsNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockPopularTvsNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<PopularTvsNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading', (widgetTester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loading);

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await widgetTester.pumpWidget(_makeTestableWidget(PopularTvsPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (widgetTester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvs).thenReturn(<Tv>[]);

    final listViewfinder = find.byType(ListView);

    await widgetTester.pumpWidget(_makeTestableWidget(PopularTvsPage()));

    expect(listViewfinder, findsOneWidget);
  });

  testWidgets('Page should display text when error', (widgetTester) async {
    when(mockNotifier.state).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('server error');

    final errorTextFinder = find.byKey(Key("error_message"));

    await widgetTester.pumpWidget(_makeTestableWidget(PopularTvsPage()));

    expect(errorTextFinder, findsOneWidget);
  });
}












