// lib/presentation/home/bloc/play_list_state.dart
import 'package:equatable/equatable.dart';
import 'package:my_app/domain/entities/song/song.dart';

abstract class PlayListState extends Equatable {
  const PlayListState();

  @override
  List<Object?> get props => [];
}

class PlayListLoading extends PlayListState {}

class PlayListLoaded extends PlayListState {
  final List<SongEntity> songs;

  const PlayListLoaded(this.songs);

  @override
  List<Object?> get props => [songs];
}

class PlayListFailure extends PlayListState {
  final String error;

  const PlayListFailure(this.error);

  @override
  List<Object?> get props => [error];
}
