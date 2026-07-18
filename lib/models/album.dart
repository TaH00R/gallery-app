import 'package:photo_manager/photo_manager.dart';

class Album {
  final AssetPathEntity entity;
  final AssetEntity? cover;
  final int count;

  const Album({
    required this.entity,
    required this.cover,
    required this.count,
  });

  String get id => entity.id;
  String get name => entity.name;
}