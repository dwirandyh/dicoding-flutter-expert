import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv.dart';
import 'package:ditonton/presentation/provider/tv/popular_tvs_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTv])
void main() {
  late MockGetPopularTv mockGetPopularTv;
  late PopularTvsNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetPopularTv = MockGetPopularTv();
    notifier = PopularTvsNotifier(getPopularTvs: mockGetPopularTv)
    ..addListener(() {
      listenerCallCount++;
    });
  });

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
    when(mockGetPopularTv.execute())
        .thenAnswer((_) async => Right(testTvs));
    // act
    notifier.fetchPopularTvs();
    // assert
    expect(notifier.state, RequestState.Loading);
  });

  test('should change tv data when data is gotten successfully', () async {
    // arrange
    when(mockGetPopularTv.execute())
        .thenAnswer((_) async => Right(testTvs));
    // act
    await notifier.fetchPopularTvs();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvs, testTvs);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccesfull', () async {
    // arrange
    when(mockGetPopularTv.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchPopularTvs();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
  });
}