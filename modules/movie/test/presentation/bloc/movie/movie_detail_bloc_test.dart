import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:movie/domain/usecases/movie/get_movie_detail.dart';
import 'package:movie/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MovieDetailBloc movieRecommendationBloc;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    movieRecommendationBloc =
        MovieDetailBloc(getMovieDetail: mockGetMovieDetail);
  });

  final id = 0;

  blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, HasData] when data is gotten successful',
      build: () {
        when(mockGetMovieDetail.execute(id))
            .thenAnswer((_) async => Right(testMovieDetail));
        return movieRecommendationBloc;
      },
      act: (bloc) => bloc.add(OnFetchMovieDetail(id)),
      expect: () => [MovieDetailLoading(), MovieDetailHasData(testMovieDetail)],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(id));
      });

  blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(id)).thenAnswer(
            (_) async => const Left(ServerFailure('Server failure')));
        return movieRecommendationBloc;
      },
      act: (bloc) => bloc.add(OnFetchMovieDetail(id)),
      expect: () => [MovieDetailLoading(), MovieDetailError('Server failure')],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(id));
      });
}
