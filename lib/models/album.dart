class Album {
  final String id;
  final String name;
  final String? coverPath;
  final List<int> mediaIds;

  const Album({
    required this.id,
    required this.name,
    this.coverPath,
    this.mediaIds = const [],
  });

  int get count => mediaIds.length;

  Album copyWith({
    String? id,
    String? name,
    String? coverPath,
    List<int>? mediaIds,
  }) {
    return Album(
      id: id ?? this.id,
      name: name ?? this.name,
      coverPath: coverPath ?? this.coverPath,
      mediaIds: mediaIds ?? this.mediaIds,
    );
  }
}