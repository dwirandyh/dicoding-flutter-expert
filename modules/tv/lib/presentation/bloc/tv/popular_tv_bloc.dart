import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/tv/get_popular_tv.dart';
import 'package:equatable/equatable.dart';

part 'popular_tv_event.dart';
part 'popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTv getPopularTv;

  PopularTvBloc({required this.getPopularTv}) : super(PopularTvInitial()) {
    on<OnFetchPopularTv>(_onFetchPopularTv);
  }

  Future<void> _onFetchPopularTv(
      OnFetchPopularTv event, Emitter<PopularTvState> emit) async {
    emit(PopularTvLoading());

    final result = await getPopularTv.execute();

    result.fold((failure) {
      emit(PopularTvError(failure.message));
    }, (tvs) {
      emit(PopularTvHasData(tvs));
    });
  }
}
