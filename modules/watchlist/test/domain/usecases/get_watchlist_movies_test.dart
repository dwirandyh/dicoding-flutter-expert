import 'package:dartz/dartz.dart';
import 'package:watchlist/domain/usecases/get_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistMovies usecase;
  late MockWatchlistRepository mockWatchlistRepository;

  setUp(() {
    mockWatchlistRepository = MockWatchlistRepository();
    usecase = GetWatchlistMovies(mockWatchlistRepository);
  });

  test('should get list of movies from the repository', () async {
    // arrange
    when(mockWatchlistRepository.getWatchlist())
        .thenAnswer((_) async => Right(testWatchlistArray));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testWatchlistArray));
  });
}
