import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gallery/core/constants/colors.dart';
import 'package:gallery/features/gallery/gallery_provider.dart';
import 'package:gallery/features/gallery/utils/asset_grouping.dart';
import 'package:gallery/features/gallery/utils/date_formatting.dart';
import 'package:gallery/features/gallery/widgets/asset_thumbnail.dart';
import 'package:gallery/features/gallery/widgets/gallery_viewer.dart';
import 'package:gallery/shared/widgets/appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class Gallery extends StatefulWidget {
  final AssetPathEntity? album;
  const Gallery({super.key, this.album});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final provider = context.read<GalleryProvider>();
    provider.fetchAssets();
    provider.startListening();
  });
}

  @override
void dispose() {
  super.dispose();
}

void _openAsset(int index) {
  final provider = context.read<GalleryProvider>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GalleryViewer(assets: provider.assets, initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
  final provider = context.watch<GalleryProvider>();
  
    final groupedAssets = groupAssetsByDay(provider.assets);
    final days = groupedAssets.entries.toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: GalleryAppBar(
          title: widget.album?.name ?? "GALLERY",
          selectionMode: provider.selectionMode,
          selectedCount: provider.selectedAssets.length,

          onCloseSelection: provider.clearSelection,

          isDeleting: provider.isDeleting,
          onDelete: provider.deleteSelected,
          onShare: () => provider.shareSelected(),
          onFavorite: provider.toggleFavoriteSelected,
          isFavorite:
              provider.selectedAssets.isNotEmpty &&
              provider.selectedAssets.every((e) => e.isFavorite),
        ),
      ),

      body: GestureDetector(
        // onPanStart:
        // onPanUpdate:
        // onPanEnd:
        child: DraggableScrollbar.semicircle(
          backgroundColor: AppColors.primary,
          heightScrollThumb: 48.0,
          controller: provider.scrollController,
          child: ListView(
            scrollCacheExtent: ScrollCacheExtent.pixels(1000),
            controller: provider.scrollController,
            children: [
              //Padding for the filter chips
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: provider.toggleSort,
                        icon: Icon(
                          provider.sortMode == SortMode.newest
                              ? Icons.arrow_circle_down_outlined
                              : Icons.arrow_circle_up_outlined,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      _chip(icon: Icons.apps, text: "All", index: 0),
                      const SizedBox(width: 8),
                      _chip(icon: Icons.image_outlined, text: "IMG", index: 1),
                      const SizedBox(width: 8),
                      _chip(
                        icon: Icons.videocam_outlined,
                        text: "VID",
                        index: 2,
                      ),
                      const SizedBox(width: 8),
                      _chip(icon: Icons.favorite_border, text: "FAV", index: 3),
                    ],
                  ),
                ),
              ),

              ...days.map((entry) {
                final date = entry.key;
                final dayAssets = entry.value;

                //Padding and container for each day with a grid of assets
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 4.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Color(0xFFE7D8C8)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 18,
                          offset: Offset(0, 8),
                          color: Colors.black.withOpacity(.05),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding for the date and item count
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.grass_outlined,
                                size: 20,
                                color: Colors.orange.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                formatDate(date),
                                style: GoogleFonts.saira(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),

                              const Spacer(),

                              Text(
                                "${dayAssets.length} items",
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Grid of assets for the day
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                            bottom: 5.0,
                          ),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),

                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),

                            itemCount: dayAssets.length,

                            itemBuilder: (_, index) {
                              final asset = dayAssets[index];

                              return AssetThumbnail(
                                key: ValueKey(asset.id),
                                asset: asset,
                                isSelected: provider.selectedAssets.contains(asset),

                                onTap: () {
                                  if (provider.selectionMode) {
                                    provider.toggleSelection(asset);
                                  } else {
                                    _openAsset(
                                      provider.assets.indexWhere(
                                        (a) => a.id == asset.id,
                                      ),
                                    );
                                  }
                                },

                                onLongPress: () {
                                  provider.startSelection(asset);
                                },
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip({
    required IconData icon,
    required String text,
    required int index,
  }) {
    final provider = context.watch<GalleryProvider>();
    final selected = provider.selectedFilter == GalleryFilter.values[index];
    return GestureDetector(
      onTap: () {
        provider.setFilter(GalleryFilter.values[index]);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withValues(alpha: .06),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? Colors.white : Colors.black87,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
