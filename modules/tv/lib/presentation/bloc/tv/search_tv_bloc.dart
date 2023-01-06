import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/tv/search_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_tv_event.dart';
part 'search_tv_state.dart';

class SearchTvBloc extends Bloc<SearchTvEvent, SearchTvState> {
  final SearchTv searchTv;

  SearchTvBloc({required this.searchTv}) : super(SearchTvEmpty()) {
    on<OnSearchTvInitState>(_onSearchTvInitState);
    on<OnSearchTvQueryChanged>(_onQueryChanged);
  }

  Future<void> _onQueryChanged(
      OnSearchTvQueryChanged event, Emitter<SearchTvState> emit) async {
    final query = event.query;

    emit(SearchTvLoading());

    final result = await searchTv.execute(query);

    result.fold((failure) {
      emit(SearchTvError(failure.message));
    }, (data) {
      emit(SearchTvHasData(data));
    });
  }

  Future<void> _onSearchTvInitState(
      OnSearchTvInitState event, Emitter<SearchTvState> emit) async {
    emit(const SearchTvHasData([]));
  }
}
