import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/tv/search_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SearchTv(mockTvRepository);
  });

  const query = "query";
  final tvs = <Tv>[];

  test('should get list of tv from repository', () async {
    // arrange
    when(mockTvRepository.searchTv(query)).thenAnswer((_) async => Right(tvs));
    // act
    final result = await usecase.execute(query);
    // assert
    expect(result, Right<Failure, List<Tv>>(tvs));
  });
}
