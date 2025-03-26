import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_app/domain/entities/song/song.dart';
import 'package:my_app/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:my_app/presentation/song_player/bloc/song_player_state.dart';

class SongPlayer extends StatefulWidget {
  final SongEntity song;

  const SongPlayer({super.key, required this.song});

  @override
  State<SongPlayer> createState() => _SongPlayerState();
}

class _SongPlayerState extends State<SongPlayer> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final songPlayerCubit = SongPlayerCubit();

    // Convert num to double explicitly
    double duration = widget.song.duration.toDouble();

    // Calculate total duration in seconds, considering both minutes and remaining seconds
    int totalDurationSeconds = _calculateTotalSeconds(duration);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      songPlayerCubit.loadSong(widget.song.songUrl!, totalDurationSeconds);
    });

    return BlocProvider(
      create: (context) => songPlayerCubit,
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: const Text(
                'Now playing',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: widget.song.imageUrl != null &&
                              widget.song.imageUrl!.isNotEmpty
                          ? Image.asset(
                              widget.song.imageUrl!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image,
                                    size: 200);
                              },
                            )
                          : const Icon(Icons.music_note, size: 200),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.song.title,
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Text(
                    widget.song.artist,
                    style: const TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<SongPlayerCubit, SongPlayerState>(
                    builder: (context, state) {
                      if (state is SongPlayerLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is SongPlayerFailure) {
                        return Center(
                          child: Text(
                            'Error: ${state.error}',
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16),
                          ),
                        );
                      }
                      if (state is SongPlayerLoaded) {
                        double sliderValue =
                            state.currentPosition.inSeconds.toDouble();

                        String currentPosition =
                            _formatDuration(state.currentPosition);
                        String totalDuration = _formatTotalDuration(duration);

                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Slider(
                                    value: sliderValue.clamp(
                                        0.0, totalDurationSeconds.toDouble()),
                                    min: 0.0,
                                    max: totalDurationSeconds.toDouble(),
                                    onChanged: (value) {
                                      context.read<SongPlayerCubit>().seek(
                                          Duration(seconds: value.toInt()));
                                    },
                                    inactiveColor: Colors.grey,
                                    activeColor: Colors.grey,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.favorite_border,
                                      color: Colors.white),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  currentPosition,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  totalDuration,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: FloatingActionButton(
                                onPressed: () {
                                  context
                                      .read<SongPlayerCubit>()
                                      .playOrPauseSong();
                                },
                                backgroundColor: Colors.green,
                                child: Icon(
                                  state.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return const Center(child: Text('No state available'));
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Calculate total seconds from a duration that might include minutes and seconds
  int _calculateTotalSeconds(double duration) {
    // Split the duration into minutes and seconds
    int minutes = duration.toInt();
    int seconds = ((duration - minutes) * 100).toInt();
    return (minutes * 60) + seconds;
  }

  // Format duration for current position (from Duration)
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  // Format total duration from song's duration property
  String _formatTotalDuration(double duration) {
    int minutes = duration.toInt();
    int seconds = ((duration - minutes) * 100).toInt();

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }
}
