import 'package:flutter/material.dart';

void main() {
  runApp(const EnhancedFavoritesApp());
}

class EnhancedFavoritesApp extends StatelessWidget {
  const EnhancedFavoritesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favorites',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const EnhancedFavoritesScreen(),
    );
  }
}

class EnhancedFavoritesScreen extends StatefulWidget {
  const EnhancedFavoritesScreen({super.key});

  @override
  State<EnhancedFavoritesScreen> createState() => _EnhancedFavoritesScreenState();
}

class _EnhancedFavoritesScreenState extends State<EnhancedFavoritesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Karinderia> _favoriteKarinderias = [
    Karinderia(
      name: 'Maria Lopez',
      description: 'Located near Liero St., Maria Lopez offers a lot of varieties and their signature special Lapaz Batchoy.',
      distance: '0.2km',
      isOpen: true,
      rating: 4.8,
      image: '🍜',
    ),
    Karinderia(
      name: 'Ibarado',
      description: 'Located near Liero St., Maria Lopez offers a lot of varieties and their signature special Lapaz Batchoy.',
      distance: '0.7km',
      isOpen: false,
      rating: 4.5,
      image: '🍛',
    ),
    Karinderia(
      name: 'Nora',
      description: 'Located near Liero St., Maria Lopez offers a lot of varieties and their signature special Lapaz Batchoy.',
      distance: '1.5km',
      isOpen: true,
      rating: 4.9,
      image: '🍲',
    ),
  ];

  final List<FavoriteMenu> _favoriteMenus = [
    FavoriteMenu(
      name: 'Menudo',
      karinderia: 'Maria Lopez',
      price: '₱65',
      image: '🥘',
    ),
    FavoriteMenu(
      name: 'Bihon',
      karinderia: 'Maria Lopez',
      price: '₱55',
      image: '🍝',
    ),
    FavoriteMenu(
      name: 'Adobo',
      karinderia: 'Ibarado',
      price: '₱70',
      image: '🍗',
    ),
    FavoriteMenu(
      name: 'Pakbet',
      karinderia: 'Ibarado',
      price: '₱60',
      image: '🥬',
    ),
    FavoriteMenu(
      name: 'Lilaga',
      karinderia: 'Nora',
      price: '₱75',
      image: '🍖',
    ),
    FavoriteMenu(
      name: 'Tinola',
      karinderia: 'Nora',
      price: '₱65',
      image: '🐔',
    ),
    FavoriteMenu(
      name: 'Mongo',
      karinderia: 'Maria Lopez',
      price: '₱50',
      image: '🥣',
    ),
    FavoriteMenu(
      name: 'Pochero',
      karinderia: 'Nora',
      price: '₱80',
      image: '🍅',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.orange,
          tabs: const [
            Tab(text: 'Karinderias'),
            Tab(text: 'Menus'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Karinderias Tab
          _buildKarinderiasTab(),
          
          // Menus Tab
          _buildMenusTab(),
        ],
      ),
    );
  }

  Widget _buildKarinderiasTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Quick Stats
          _buildStatsCard(),
          const SizedBox(height: 20),
          
          // Karinderias List
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _favoriteKarinderias.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _buildEnhancedKarinderiaCard(_favoriteKarinderias[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    final openCount = _favoriteKarinderias.where((k) => k.isOpen).length;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[100]!),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Favorite Karinderias',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange[800],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$openCount/${_favoriteKarinderias.length} currently open',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.restaurant_menu,
              color: Colors.orange[600],
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedKarinderiaCard(Karinderia karinderia) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to karinderia details
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          karinderia.image,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            karinderia.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 12,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 2),
                              Text(
                                karinderia.distance,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.star,
                                size: 12,
                                color: Colors.orange[500],
                              ),
                              const SizedBox(width: 2),
                              Text(
                                karinderia.rating.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: karinderia.isOpen 
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: karinderia.isOpen ? Colors.green : Colors.red,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        karinderia.isOpen ? 'OPEN' : 'CLOSED',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: karinderia.isOpen ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  karinderia.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildActionButton(
                          icon: Icons.directions,
                          label: 'Directions',
                          onTap: () {},
                        ),
                        const SizedBox(width: 12),
                        _buildActionButton(
                          icon: Icons.call,
                          label: 'Call',
                          onTap: () {},
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        _removeKarinderia(karinderia);
                      },
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: Colors.orange[500],
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenusTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Menu Stats
          _buildMenuStatsCard(),
          const SizedBox(height: 20),
          
          // Menus Grid
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: _favoriteMenus.length,
            itemBuilder: (context, index) {
              return _buildEnhancedMenuCard(_favoriteMenus[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuStatsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[100]!),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Favorite Menus',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange[800],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_favoriteMenus.length} saved items',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.lunch_dining,
              color: Colors.orange[600],
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedMenuCard(FavoriteMenu menu) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to menu details
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          menu.image,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _removeMenu(menu);
                      },
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 18,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  menu.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  menu.karinderia,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      menu.price,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[600],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange[500],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _removeKarinderia(Karinderia karinderia) {
    setState(() {
      _favoriteKarinderias.remove(karinderia);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed ${karinderia.name} from favorites'),
        backgroundColor: Colors.orange[500],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _removeMenu(FavoriteMenu menu) {
    setState(() {
      _favoriteMenus.remove(menu);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed ${menu.name} from favorites'),
        backgroundColor: Colors.orange[500],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class Karinderia {
  final String name;
  final String description;
  final String distance;
  final bool isOpen;
  final double rating;
  final String image;

  const Karinderia({
    required this.name,
    required this.description,
    required this.distance,
    required this.isOpen,
    this.rating = 4.0,
    this.image = '🍜',
  });
}

class FavoriteMenu {
  final String name;
  final String karinderia;
  final String price;
  final String image;

  const FavoriteMenu({
    required this.name,
    required this.karinderia,
    this.price = '₱60',
    this.image = '🍽️',
  });
}