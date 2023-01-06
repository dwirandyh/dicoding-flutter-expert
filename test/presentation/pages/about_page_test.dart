import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Material(child: body),
    );
  }

  testWidgets('should showing app icon and back icon', (widgetTester) async {
    final imageFinder = find.byType(Image);
    final backIconFinder = find.byIcon(Icons.arrow_back);
    await widgetTester.pumpWidget(makeTestableWidget(AboutPage()));

    expect(imageFinder, findsOneWidget);
    expect(backIconFinder, findsOneWidget);
  });
}
