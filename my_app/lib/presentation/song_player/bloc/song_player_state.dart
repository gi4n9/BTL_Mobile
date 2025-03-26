import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class SongPlayerState extends Equatable {
  const SongPlayerState();

  @override
  List<Object?> get props => [];
}

class SongPlayerLoading extends SongPlayerState {}

class SongPlayerLoaded extends SongPlayerState {
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;

  const SongPlayerLoaded({
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
  });

  @override
  List<Object?> get props => [isPlaying, currentPosition, totalDuration];
}

class SongPlayerFailure extends SongPlayerState {
  final String error;

  const SongPlayerFailure(this.error);

  @override
  List<Object?> get props => [error];
}
