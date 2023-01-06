import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Material(child: body),
    );
  }

  testWidgets('should showing data correctly with poster',
      (widgetTester) async {
    final item = ItemData(
        title: "title", overview: "overview", posterPath: "posterPath");

    final titleFinder = find.text(item.title!);
    final overviewFinder = find.text(item.overview!);
    final posterFinder = find.byType(CachedNetworkImage);
    await widgetTester.pumpWidget(_makeTestableWidget(ItemCard(item: item)));

    expect(titleFinder, findsOneWidget);
    expect(overviewFinder, findsOneWidget);
    expect(posterFinder, findsOneWidget);
  });

  testWidgets('should showing data correctly with error placeholder icon',
      (widgetTester) async {
    final item =
        ItemData(title: "title", overview: "overview", posterPath: null);

    final titleFinder = find.text(item.title!);
    final overviewFinder = find.text(item.overview!);
    final posterErrorIconFinder = find.byIcon(Icons.error);
    await widgetTester.pumpWidget(_makeTestableWidget(ItemCard(item: item)));

    expect(titleFinder, findsOneWidget);
    expect(overviewFinder, findsOneWidget);
    expect(posterErrorIconFinder, findsOneWidget);
  });

  testWidgets('should trigger tap event', (widgetTester) async {
    final item =
        ItemData(title: "title", overview: "overview", posterPath: null);

    var isTapped = false;
    final Function onTap = (() {
      isTapped = true;
    });

    final titleFinder = find.text(item.title!);
    final overviewFinder = find.text(item.overview!);
    final posterErrorIconFinder = find.byIcon(Icons.error);
    final inkWellFinder = find.byType(InkWell);

    await widgetTester
        .pumpWidget(_makeTestableWidget(ItemCard(item: item, onTap: onTap)));
    await widgetTester.tap(inkWellFinder);

    expect(titleFinder, findsOneWidget);
    expect(overviewFinder, findsOneWidget);
    expect(posterErrorIconFinder, findsOneWidget);
    expect(isTapped, true);
  });
}
