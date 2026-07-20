import 'package:photo_manager/photo_manager.dart';

Map<DateTime, List<AssetEntity>> groupAssetsByDay(List<AssetEntity> assets) {
    final Map<DateTime, List<AssetEntity>> grouped = {};

    for (final asset in assets) {
      final date = asset.createDateTime;

      final key = DateTime(date.year, date.month, date.day);

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(asset);
    }

    return grouped;
  }