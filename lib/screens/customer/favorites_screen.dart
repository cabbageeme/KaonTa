import 'package:flutter/material.dart';

Widget _buildNetworkImage({
  required String imageUrl,
  required double width,
  required double height,
  required BoxFit fit,
  double borderRadius = 0,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        );
      },
    ),
  );
}

class EnhancedFavoritesScreen extends StatelessWidget {
  const EnhancedFavoritesScreen({super.key});

  static const List<Karinderia> _favoriteKarinderias = [
    Karinderia(
      name: 'Maria Lopez',
      description:
          'Located near Liero St., Maria Lopez offers a lot of varieties and their signature special Lapaz Batchoy.',
      distance: '0.2km',
      imageUrl:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=200&q=80',
    ),
    Karinderia(
      name: 'Ibarado',
      description:
          'Located near Liero St., Maria Lopez offers a lot of varieties and their signature special Lapaz Batchoy.',
      distance: '0.7km',
      imageUrl:
          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=200&q=80',
    ),
    Karinderia(
      name: 'Nora',
      description:
          'Located near Liero St., Maria Lopez offers a lot of varieties and their signature special Lapaz Batchoy.',
      distance: '1.5km',
      imageUrl:
          'https://images.unsplash.com/photo-1521017432531-fbd92d768814?auto=format&fit=crop&w=200&q=80',
    ),
  ];

  static const List<FavoriteMenu> _favoriteMenus = [
    FavoriteMenu('Menudo',
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=200&q=80'),
    FavoriteMenu('Bihon',
        'https://images.unsplash.com/photo-1585032226651-759b8d3761c4?auto=format&fit=crop&w=200&q=80'),
    FavoriteMenu('Adobo',
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=200&q=80'),
    FavoriteMenu('Pakbet',
        'https://images.unsplash.com/photo-1609501676725-7186f017a4b4?auto=format&fit=crop&w=200&q=80'),
    FavoriteMenu('Lilaga',
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=200&q=80'),
    FavoriteMenu('Tinola',
        'https://images.unsplash.com/photo-1585032226651-759b8d3761c4?auto=format&fit=crop&w=200&q=80'),
    FavoriteMenu('Mongo',
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=200&q=80'),
    FavoriteMenu('Pochero',
        'https://images.unsplash.com/photo-1609501676725-7186f017a4b4?auto=format&fit=crop&w=200&q=80'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text('Favorites',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Favorite Karinderias'),
            const SizedBox(height: 12),
            ..._favoriteKarinderias.map(_buildKarinderiaCard),
            const SizedBox(height: 24),
            _buildSectionTitle('Favorite Menus'),
            const SizedBox(height: 12),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              shrinkWrap: true,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.9,
              children: _favoriteMenus
                  .map((m) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildNetworkImage(
                            imageUrl: m.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            borderRadius: 12,
                          ),
                          const SizedBox(height: 4),
                          Flexible(
                            child: Text(
                              m.name,
                              style: const TextStyle(fontSize: 11, color: Colors.black87),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const Icon(Icons.edit, size: 18, color: Colors.black87),
      ],
    );
  }

  Widget _buildKarinderiaCard(Karinderia k) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2AD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildNetworkImage(
            imageUrl: k.imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            borderRadius: 14,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(k.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700, height: 1)),
                const SizedBox(height: 4),
                Text(k.description,
                    style: const TextStyle(fontSize: 13, height: 1.3)),
                const SizedBox(height: 6),
                Text(k.distance,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Karinderia {
  final String name;
  final String description;
  final String distance;
  final String imageUrl;

  const Karinderia({
    required this.name,
    required this.description,
    required this.distance,
    required this.imageUrl,
  });
}

class FavoriteMenu {
  final String name;
  final String imageUrl;

  const FavoriteMenu(this.name, this.imageUrl);
}