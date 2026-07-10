import 'package:photo_manager/photo_manager.dart';

class VideoService {
  VideoService._();

  static Duration getDuration(
    AssetEntity video,
  ) {
    return Duration(seconds: video.duration);
  }
}