import 'package:flutter/material.dart';

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
        'https://images.unsplash.com/photo-1604908176603-0280c68e3b30?auto=format&fit=crop&w=200&q=80'),
    FavoriteMenu('Bihon',
        'https://images.unsplash.com/photo-1604908176603-0280c68e3b30?auto=format&fit=crop&w=200&q=80'),
    FavoriteMenu('Adobo',
        'https://images.unsplash.com/photo-1604908176603-0280c68e3b30?auto=format&fit=crop&w=200&q=80'),
    FavoriteMenu('Pakbet',
        'https://images.unsplash.com/photo-1604908176603-0280c68e3b30?auto=format&fit=crop&w=200&q=80'),
    FavoriteMenu('Lilaga',
        'https://images.unsplash.com/photo-1604908176603-0280c68e3b30?auto=format&fit=crop&w=200&q=80'),
    FavoriteMenu('Tinola',
        'https://images.unsplash.com/photo-1604908176603-0280c68e3b30?auto=format&fit=crop&w=200&q=80'),
    FavoriteMenu('Mongo',
        'https://images.unsplash.com/photo-1604908176603-0280c68e3b30?auto=format&fit=crop&w=200&q=80'),
    FavoriteMenu('Pochero',
        'https://images.unsplash.com/photo-1604908176603-0280c68e3b30?auto=format&fit=crop&w=200&q=80'),
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
              children: _favoriteMenus
                  .map((m) => Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              m.imageUrl,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(m.name,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black87)),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              k.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
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