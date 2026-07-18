import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class ImageView extends StatefulWidget {
  final AssetEntity asset;

  const ImageView({
    super.key,
    required this.asset,
  });

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool showUI = true;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.asset.isFavorite;
  }

  Future<void> _toggleFavorite() async {
    await PhotoManager.plugin.favoriteAsset(
      widget.asset.id,
      !isFavorite,
    );

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<void> _share() async {
    final file = await widget.asset.originFile;

    if (file == null) return;

    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(file.path),
        ],
      ),
    );
  }

  Future<void> _delete() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Image"),
        content: const Text(
          "This image will be permanently deleted.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          )
        ],
      ),
    );

    if (result != true) return;

    await PhotoManager.editor.deleteWithIds([
      widget.asset.id,
    ]);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = widget.asset.createDateTime;

    final formattedDate =
        DateFormat("dd MMMM yyyy").format(date);

    final formattedTime =
        DateFormat("hh:mm a").format(date);

    return FutureBuilder<File?>(
      future: widget.asset.file,
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final file = snapshot.data!;

        return Scaffold(
          backgroundColor: Colors.black,

          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AnimatedOpacity(
              opacity: showUI ? 1 : 0,
              duration: const Duration(milliseconds: 250),
              child: AppBar(
                backgroundColor: Colors.black.withOpacity(.35),
                elevation: 0,
                leading: const BackButton(
                  color: Colors.white,
                ),
                titleSpacing: 0,

                title: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formattedTime,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                actions: [

                  IconButton(
                    onPressed: _toggleFavorite,
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: const Color(0xffC76A3A),
                    ),
                  ),

                  PopupMenuButton(
                    color: Colors.grey.shade900,
                    iconColor: Colors.white,
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 0,
                        child: Text("Details"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          body: GestureDetector(
            onTap: () {
              setState(() {
                showUI = !showUI;
              });
            },

            child: PhotoView(
              imageProvider: FileImage(file),
              backgroundDecoration:
                  const BoxDecoration(
                color: Colors.black,
              ),
            ),
          ),
                    bottomNavigationBar: AnimatedOpacity(
            opacity: showUI ? 1 : 0,
            duration: const Duration(milliseconds: 250),
            child: SafeArea(
              child: Container(
                color: Colors.black.withOpacity(.9),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                  children: [

                    _BottomAction(
                      icon: Icons.delete_outline,
                      label: "Delete",
                      onTap: _delete,
                    ),

                    _BottomAction(
                      icon: Icons.share_outlined,
                      label: "Share",
                      onTap: _share,
                    ),

                    _BottomAction(
                      icon: Icons.info_outline,
                      label: "Info",
                      onTap: () {
                        _showDetails(file);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDetails(File file) async {
    final size =
        (await file.length() / (1024 * 1024))
            .toStringAsFixed(2);

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff181818),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Text(
                  "Image Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                _InfoTile(
                  icon: Icons.calendar_today,
                  title: "Created",
                  value: DateFormat(
                    "dd MMM yyyy  hh:mm a",
                  ).format(
                    widget.asset.createDateTime,
                  ),
                ),

                _InfoTile(
                  icon: Icons.photo_size_select_large,
                  title: "Resolution",
                  value:
                      "${widget.asset.width} × ${widget.asset.height}",
                ),

                _InfoTile(
                  icon: Icons.storage,
                  title: "Size",
                  value: "$size MB",
                ),

                _InfoTile(
                  icon: Icons.folder,
                  title: "Path",
                  value: file.path,
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Icon(
              icon,
              color: const Color(0xffC76A3A),
            ),

            const SizedBox(height: 5),

            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Icon(
            icon,
            color: const Color(0xffC76A3A),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}