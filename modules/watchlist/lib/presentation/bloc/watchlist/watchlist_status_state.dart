part of 'watchlist_status_bloc.dart';

class WatchlistStatusState extends Equatable {
  final bool isExists;
  final bool isSuccess;
  final String? additionalMessage;

  const WatchlistStatusState({
    required this.isExists,
    required this.isSuccess,
    this.additionalMessage,
  });

  @override
  List<Object?> get props => [isExists, isSuccess, additionalMessage];
}
