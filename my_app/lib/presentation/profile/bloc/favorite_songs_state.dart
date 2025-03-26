// lib/presentation/profile/bloc/favorite_songs_state.dart
import 'package:equatable/equatable.dart';
import 'package:my_app/domain/entities/song/song.dart';

abstract class FavoriteSongsState extends Equatable {
  const FavoriteSongsState();

  @override
  List<Object?> get props => [];
}

class FavoriteSongsLoading extends FavoriteSongsState {}

class FavoriteSongsLoaded extends FavoriteSongsState {
  final List<SongEntity> favoriteSongs;

  const FavoriteSongsLoaded(this.favoriteSongs);

  @override
  List<Object?> get props => [favoriteSongs];
}

class FavoriteSongsFailure extends FavoriteSongsState {
  final String error;

  const FavoriteSongsFailure(this.error);

  @override
  List<Object?> get props => [error];
}
