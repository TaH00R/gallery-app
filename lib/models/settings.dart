enum SortBy {
  newest,
  oldest,
  name,
  size,
}

enum GridSize {
  small,
  medium,
  large,
}

class GallerySettings {
  final SortBy sortBy;
  final GridSize gridSize;
  final bool showVideos;
  final bool showHidden;

  const GallerySettings({
    this.sortBy = SortBy.newest,
    this.gridSize = GridSize.medium,
    this.showVideos = true,
    this.showHidden = false,
  });

  GallerySettings copyWith({
    SortBy? sortBy,
    GridSize? gridSize,
    bool? showVideos,
    bool? showHidden,
  }) {
    return GallerySettings(
      sortBy: sortBy ?? this.sortBy,
      gridSize: gridSize ?? this.gridSize,
      showVideos: showVideos ?? this.showVideos,
      showHidden: showHidden ?? this.showHidden,
    );
  }
}