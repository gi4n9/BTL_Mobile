// lib/presentation/home/bloc/news_songs_state.dart
import 'package:equatable/equatable.dart';
import 'package:my_app/domain/entities/song/song.dart';

abstract class NewsSongsState extends Equatable {
  const NewsSongsState();

  @override
  List<Object?> get props => [];
}

class NewsSongsLoading extends NewsSongsState {}

class NewsSongsLoaded extends NewsSongsState {
  final List<SongEntity> songs;

  const NewsSongsLoaded(this.songs);

  @override
  List<Object?> get props => [songs];
}

class NewsSongsFailure extends NewsSongsState {
  final String error;

  const NewsSongsFailure(this.error);

  @override
  List<Object?> get props => [error];
}
