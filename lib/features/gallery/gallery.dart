import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery/features/gallery/components/asset_thumbnail.dart';
import 'package:gallery/features/gallery/components/gallery_viewer.dart';
import 'package:gallery/shared/widgets/appbar.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<AssetEntity> assets = [];
  bool _isDeleting = false;
  final Set<AssetEntity> selectedAssets = {};
  bool selectionMode = false;

  Future<void> _fetchAssets() async {
    final result = await PhotoManager.getAssetListRange(start: 0, end: 1000000);
    if (!mounted) return;
    setState(() {
      assets = result;
    });
  }

  void _toggleSelection(AssetEntity asset) {
    setState(() {
      if (selectedAssets.contains(asset)) {
        selectedAssets.remove(asset);

        if (selectedAssets.isEmpty) {
          selectionMode = false;
        }
      } else {
        selectedAssets.add(asset);
      }
    });
  }

  void _startSelection(AssetEntity asset) {
    setState(() {
      selectionMode = true;
      selectedAssets.add(asset);
    });
  }

void _openAsset(int index) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => GalleryViewer(
        assets: assets,
        initialIndex: index,
      ),
    ),
  );
}

  void _onGalleryChanged(MethodCall call) {
    _fetchAssets();
  }

  @override
  void initState() {
    super.initState();

    _fetchAssets();

    PhotoManager.addChangeCallback(_onGalleryChanged);
    PhotoManager.startChangeNotify();
  }

  @override
  void dispose() {
    PhotoManager.removeChangeCallback(_onGalleryChanged);
    PhotoManager.stopChangeNotify();

    super.dispose();
  }

  Future<void> _deleteSelected() async {
    if (_isDeleting || selectedAssets.isEmpty) return;

    final ids = selectedAssets.map((e) => e.id).toList();

    setState(() {
      _isDeleting = true;
    });

    try {
      final deletedIds = await PhotoManager.editor.deleteWithIds(ids);

      if (!mounted) return;

      if (deletedIds.isNotEmpty) {
        setState(() {
          assets.removeWhere((asset) => deletedIds.contains(asset.id));
          selectedAssets.clear();
          selectionMode = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }


Future<void> shareAssets(List<AssetEntity> assets) async {
  final files = <XFile>[];

  for (final asset in assets) {
    final file = await asset.originFile;
    if (file != null) {
      files.add(XFile(file.path));
    }
  }

  if (files.isEmpty) return;

  await SharePlus.instance.share(
    ShareParams(files: files),
  );
}

  Future<void> _moveSelected() async {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: GalleryAppBar(
          selectionMode: selectionMode,
          selectedCount: selectedAssets.length,

          onCloseSelection: () {
            setState(() {
              selectionMode = false;
              selectedAssets.clear();
            });
          },

          isDeleting: _isDeleting,
          onDelete: _deleteSelected,
          onShare: () => shareAssets(selectedAssets.toList()),
          onMove: _moveSelected,
        ),
      ),

      body: GestureDetector(
        // onPanStart:
        // onPanUpdate:
        // onPanEnd:
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: assets.length,
          itemBuilder: (_, index) {
            final asset = assets[index];

            return AssetThumbnail(
              key: ValueKey(asset.id),
              asset: asset,
              isSelected: selectedAssets.contains(asset),
              
              onTap: () {
                if (selectionMode) {
                  _toggleSelection(asset);
                } else {
                  _openAsset(index);
                }
              },

              onLongPress: () {
                _startSelection(asset);
              },
            );
          },
        ),
      ),
    );
  }
}
