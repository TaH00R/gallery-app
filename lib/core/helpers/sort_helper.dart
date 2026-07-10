import 'package:photo_manager/photo_manager.dart';

class SortHelper {
  SortHelper._();

  static void newestFirst(List<AssetEntity> media) {
    media.sort(
      (a, b) => b.createDateTime.compareTo(a.createDateTime),
    );
  }

  static void oldestFirst(List<AssetEntity> media) {
    media.sort(
      (a, b) => a.createDateTime.compareTo(b.createDateTime),
    );
  }
}