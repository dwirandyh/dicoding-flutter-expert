import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:flutter/material.dart';

class ItemData {
  final String? title;
  final String? overview;
  final String? posterPath;

  ItemData(
      {required this.title, required this.overview, required this.posterPath});
}

class ItemCard extends StatelessWidget {
  final ItemData item;
  final Function? onTap;

  const ItemCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16 + 80 + 16,
                  bottom: 8,
                  right: 8,
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading6,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item.overview ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 16,
                bottom: 16,
              ),
              child: _buildThumbnail(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (item.posterPath != null) {
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: CachedNetworkImage(
          imageUrl: '$baseImageUrl${item.posterPath}',
          width: 80,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
            color: Colors.grey,
            height: 120,
            width: 80,
            child: const Icon(Icons.error)),
      );
    }
  }
}
