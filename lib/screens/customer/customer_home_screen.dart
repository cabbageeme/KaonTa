import 'package:flutter/material.dart';
import '/routes/app_routes.dart';
import '/routes/navigation_service.dart';

class KarinderiaHomePage extends StatelessWidget {
  const KarinderiaHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 12),
              _buildGreeting(),
              const SizedBox(height: 16),
              _buildFeaturedCard(),
              const SizedBox(height: 18),
              _buildNearbySection(),
              const SizedBox(height: 18),
              _buildPopularMenus(),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Icon(Icons.location_on, size: 18, color: Colors.black87),
            SizedBox(width: 6),
            Text('Karinderia Spotlight', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black87),
              onPressed: () => NavigationService.navigateTo(AppRoutes.notifications),
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.black87),
              onPressed: () => NavigationService.navigateTo(AppRoutes.favorites),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Hello, Clarence',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
            height: 1.1,
          ),
        ),
        SizedBox(height: 4),
        Text('Karinderia Spotlight', style: TextStyle(fontSize: 18, color: Colors.black87)),
      ],
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F9DF),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=200&q=80',
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Maria Lopez',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Located near Liero St., Maria Lopez offers a lot of varieties and their signature special Lapaz Batchoy.',
                  style: TextStyle(fontSize: 13.5, color: Colors.black87, height: 1.35),
                ),
                SizedBox(height: 10),
                Text('Proudly serving: Lapaz Batchoy', style: TextStyle(fontSize: 12.5, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbySection() {
    final items = [
      _NearbyData('MARIA\'S KARINDERYA', '0.2km', 'CLOSE', Colors.red, 'Updated 5 mins ago'),
      _NearbyData('NORA\'S KARINDERYA', '1.5km', 'OPEN', Colors.green, 'Updated 2 mins ago'),
      _NearbyData('IBARRADO\'S KARINDERYA', '0.7km', 'MAINTENANCE', Colors.orange, 'Updated 9 mins ago'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Nearby Karinderias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87)),
            Text('Browse Map', style: TextStyle(fontSize: 13, color: Colors.brown)),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: items
              .map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildNearbyCard(item),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildNearbyCard(_NearbyData data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFB6F2C3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.place, size: 16, color: Colors.brown),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  data.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.brown),
                ),
              ),
              Text(data.distance, style: const TextStyle(fontSize: 12, color: Colors.brown)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _statusDot(data.statusColor),
              const SizedBox(width: 4),
              Text('Status: ${data.status}', style: const TextStyle(fontSize: 12, color: Colors.brown)),
              const SizedBox(width: 8),
              _statusDot(Colors.green),
              const SizedBox(width: 4),
              Text('Updated', style: const TextStyle(fontSize: 12, color: Colors.brown)),
              const SizedBox(width: 4),
              Text(data.updated, style: const TextStyle(fontSize: 12, color: Colors.brown)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopularMenus() {
    final menus = [
      _MenuItem('Menudo', 'https://images.unsplash.com/photo-1604908176603-0280c68e3b30?auto=format&fit=crop&w=200&q=80'),
      _MenuItem('Bihon', 'https://images.unsplash.com/photo-1604908176603-0280c68e3b30?auto=format&fit=crop&w=200&q=80'),
      _MenuItem('Adobo', 'https://images.unsplash.com/photo-1604908176603-0280c68e3b30?auto=format&fit=crop&w=200&q=80'),
      _MenuItem('Pakbet', 'https://images.unsplash.com/photo-1604908176603-0280c68e3b30?auto=format&fit=crop&w=200&q=80'),
      _MenuItem('Lilaga', 'https://images.unsplash.com/photo-1604908176603-0280c68e3b30?auto=format&fit=crop&w=200&q=80'),
      _MenuItem('Tinola', 'https://images.unsplash.com/photo-1604908176603-0280c68e3b30?auto=format&fit=crop&w=200&q=80'),
      _MenuItem('Mongo', 'https://images.unsplash.com/photo-1604908176603-0280c68e3b30?auto=format&fit=crop&w=200&q=80'),
      _MenuItem('Pochero', 'https://images.unsplash.com/photo-1604908176603-0280c68e3b30?auto=format&fit=crop&w=200&q=80'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.circle_outlined, size: 12, color: Colors.black87),
            SizedBox(width: 8),
            Text('Popular Menus', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          shrinkWrap: true,
          children: menus
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
                      Text(m.name, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                    ],
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navIcon(icon: Icons.home, label: 'Home', isActive: true, onTap: () {}),
          _navIcon(
            icon: Icons.favorite_border,
            label: 'Favorites',
            onTap: () => NavigationService.navigateTo(AppRoutes.favorites),
          ),
          _navIcon(
            icon: Icons.person_outline,
            label: 'Profile',
            onTap: () => NavigationService.navigateTo(AppRoutes.profile),
          ),
        ],
      ),
    );
  }

  Widget _navIcon({required IconData icon, required String label, bool isActive = false, required VoidCallback onTap}) {
    final color = isActive ? Colors.black : Colors.grey[600];
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }

  Widget _statusDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _NearbyData {
  final String name;
  final String distance;
  final String status;
  final Color statusColor;
  final String updated;

  _NearbyData(this.name, this.distance, this.status, this.statusColor, this.updated);
}

class _MenuItem {
  final String name;
  final String imageUrl;
  _MenuItem(this.name, this.imageUrl);
}