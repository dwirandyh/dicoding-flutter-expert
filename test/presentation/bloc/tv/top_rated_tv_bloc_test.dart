import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../provider/tv/tv_list_notifier_test.mocks.dart';

void main() {
  late MockGetTopRatedTv mockGetTopRatedTv;
  late TopRatedTvBloc nowPlayingTvBloc;

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
    nowPlayingTvBloc = TopRatedTvBloc(getTopRatedTv: mockGetTopRatedTv);
  });

  final testTv = Tv(
      firstAirDate: DateTime(2017, 9, 7, 17, 30),
      genreIds: [1, 2],
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
      backdropPath: 'dummy backdrop');
  final testTvs = [testTv];

  blocTest<TopRatedTvBloc, TopRatedTvState>(
      'Should emit [Loading, HasData] when data is gotten successful',
      build: () {
        when(mockGetTopRatedTv.execute())
            .thenAnswer((_) async => Right(testTvs));
        return nowPlayingTvBloc;
      },
      act: (bloc) => bloc.add(OnFetchTopRatedTv()),
      expect: () => [TopRatedTvLoading(), TopRatedTvHasData(testTvs)],
      verify: (bloc) {
        verify(mockGetTopRatedTv.execute());
      });

  blocTest<TopRatedTvBloc, TopRatedTvState>(
      'Should emit [Loading, Error] when data is unsuccessful',
      build: () {
        when(mockGetTopRatedTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server failure')));
        return nowPlayingTvBloc;
      },
      act: (bloc) => bloc.add(OnFetchTopRatedTv()),
      expect: () => [TopRatedTvLoading(), TopRatedTvError('Server failure')],
      verify: (bloc) {
        verify(mockGetTopRatedTv.execute());
      });
}
