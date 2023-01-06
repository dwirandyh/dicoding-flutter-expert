import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/tv/search_tv.dart';
import 'package:tv/presentation/bloc/tv/search_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import 'search_tv_bloc_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late MockSearchTv mockSearchTv;
  late SearchTvBloc searchTvBloc;

  setUp(() {
    mockSearchTv = MockSearchTv();
    searchTvBloc = SearchTvBloc(searchTv: mockSearchTv);
  });

  const query = "query";
  final testTv = Tv(
      firstAirDate: DateTime(2017, 9, 7, 17, 30),
      genreIds: const [1, 2],
      id: 12,
      name: "dummy name",
      originCountry: const ["dummy country"],
      originalLanguage: "dummy language",
      originalName: "dummy originalName",
      overview: "dummy overview",
      popularity: 4.8,
      posterPath: "dummy posterPath",
      voteAverage: 5,
      voteCount: 20,
      backdropPath: 'dummy backdrop');
  final testTvs = [testTv];

  blocTest<SearchTvBloc, SearchTvState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockSearchTv.execute(query))
            .thenAnswer((_) async => Right(testTvs));
        return searchTvBloc;
      },
      act: (bloc) => bloc.add(const OnSearchTvQueryChanged(query)),
      expect: () => [SearchTvLoading(), SearchTvHasData(testTvs)],
      verify: (bloc) {
        verify(mockSearchTv.execute(query));
      });

  blocTest<SearchTvBloc, SearchTvState>(
      'Should emit [Loading, Error] when data is unsuccesfull',
      build: () {
        when(mockSearchTv.execute(query))
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return searchTvBloc;
      },
      act: (bloc) => bloc.add(const OnSearchTvQueryChanged(query)),
      expect: () => [SearchTvLoading(), const SearchTvError('Server Failure')],
      verify: (bloc) {
        verify(mockSearchTv.execute(query));
      });
}
