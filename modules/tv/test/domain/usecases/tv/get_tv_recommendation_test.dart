import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/tv/get_tv_recommendation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvRecommendation usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvRecommendation(mockTvRepository);
  });

  final tvs = <Tv>[];
  final id = 1;

  test('should get list of tv from repository', () async {
    // arrange
    when(mockTvRepository.getTvRecommendations(id))
        .thenAnswer((_) async => Right(tvs));
    // act
    final result = await usecase.execute(id);
    // assert
    expect(result, Right<Failure, List<Tv>>(tvs));
  });
}
