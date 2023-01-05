import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetNowPlayingTv(mockTvRepository);
  });

  final tvs = <Tv>[];

  test('should get list of tv from repository', () async {
    // arrange
    when(mockTvRepository.getNowPlayingTv())
        .thenAnswer((_) async => Right(tvs));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right<Failure, List<Tv>>(tvs));
  });
}
