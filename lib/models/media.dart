enum MediaType {
  image,
  video,
}

class Media {
  final int id;
  final String path;
  final String name;
  final DateTime dateCreated;
  final int size;
  final MediaType type;
  final Duration? duration;
  final String? thumbnailPath;
  final bool isFavorite;

  const Media({
    required this.id,
    required this.path,
    required this.name,
    required this.dateCreated,
    required this.size,
    required this.type,
    this.duration,
    this.thumbnailPath,
    this.isFavorite = false,
  });

  Media copyWith({
    int? id,
    String? path,
    String? name,
    DateTime? dateCreated,
    int? size,
    MediaType? type,
    Duration? duration,
    String? thumbnailPath,
    bool? isFavorite,
  }) {
    return Media(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      dateCreated: dateCreated ?? this.dateCreated,
      size: size ?? this.size,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}