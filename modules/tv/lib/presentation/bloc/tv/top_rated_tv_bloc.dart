import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTv getTopRatedTv;

  TopRatedTvBloc({required this.getTopRatedTv}) : super(TopRatedTvInitial()) {
    on<OnFetchTopRatedTv>(_onFetchTopRatedTv);
  }

  Future<void> _onFetchTopRatedTv(
      OnFetchTopRatedTv event, Emitter<TopRatedTvState> emit) async {
    emit(TopRatedTvLoading());

    final result = await getTopRatedTv.execute();

    result.fold((failure) {
      emit(TopRatedTvError(failure.message));
    }, (tvs) {
      emit(TopRatedTvHasData(tvs));
    });
  }
}
