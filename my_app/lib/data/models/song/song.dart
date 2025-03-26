import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/domain/entities/song/song.dart';

class SongModel {
  String? title;
  String? artist;
  num? duration;
  Timestamp? releaseDate;
  bool? isFavorite;
  String? songId;
  String? songUrl;
  String? imageUrl;

  SongModel({
    required this.title,
    required this.artist,
    required this.duration,
    required this.releaseDate,
    required this.isFavorite,
    required this.songId,
    this.songUrl,
    this.imageUrl,
  });

  SongModel.fromJson(Map<String, dynamic> json) {
    title = json['title']?.toString();
    artist = json['artist']?.toString();
    duration = json['duration'] as num?;
    releaseDate = json['releaseDate'] as Timestamp?;
    isFavorite = json['isFavorite'] as bool? ?? false;
    songId = json['songId']?.toString();
    songUrl = json['songUrl']?.toString();
    imageUrl = json['imageUrl']?.toString();
  }
}

extension SongModelX on SongModel {
  SongEntity toEntity() {
    return SongEntity(
      title: title ?? '',
      artist: artist ?? '',
      duration: duration ?? 0,
      releaseDate: releaseDate ?? Timestamp.now(),
      isFavorite: isFavorite ?? false,
      songId: songId ?? '',
      songUrl: songUrl,
      imageUrl: imageUrl,
    );
  }
}
