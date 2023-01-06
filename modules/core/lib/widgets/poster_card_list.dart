import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:flutter/material.dart';

class PosterCardData {
  String? posterPath;
  PosterCardData(this.posterPath);
}

class PosterCardList extends StatelessWidget {
  final List<PosterCardData> items;
  final Function(int)? onTap;

  const PosterCardList({super.key, required this.items, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = items[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                if (onTap != null) {
                  onTap!(index);
                }
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: items.length,
      ),
    );
  }
}
