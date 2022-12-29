import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv.dart';
import 'package:ditonton/presentation/provider/tv/search_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_tv_notifier_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late MockSearchTv mockSearchTv;
  late SearchTvNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTv = MockSearchTv();
    notifier = SearchTvNotifier(searchTv: mockSearchTv)
    ..addListener(() {
      listenerCallCount++;
    });
  });

  final query = "query";
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

  test('should change state to loading when usecase is called', () {
    // arrange
    when(mockSearchTv.execute(query))
        .thenAnswer((_) async => Right(testTvs));
    // act
    notifier.fetchTvSearch(query);
    // assert
    expect(notifier.state, RequestState.Loading);
  });

  test('should change tv data when data is gotten successfully', () async {
    // arrange
    when(mockSearchTv.execute(query))
        .thenAnswer((_) async => Right(testTvs));
    // act
    await notifier.fetchTvSearch(query);
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.searchResult, testTvs);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccesfull', () async {
    // arrange
    when(mockSearchTv.execute(query))
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchTvSearch(query);
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
  });
}