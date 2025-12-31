import 'package:flutter/material.dart';
import 'package:kaontaproject/routes/app_routes.dart';

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

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  bool _isOpen = true;
  final List<String> _menuItems = [
    'Menu', 'Orders', 'Stats', 'Settings',
    'Menudo', 'Bihon', 'Adobo', 'Pakbet',
    'Lilaga', 'Tinola', 'Mongo', 'Pochero',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildFeaturedCard(),
              const SizedBox(height: 24),
              _buildTodayMenuHeader(),
              const SizedBox(height: 16),
              _buildMenuGrid(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello, Adrian',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              "Maria Lopez's Karinderia",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.ownerProfile);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person, color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2AD),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNetworkImage(
            imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=300&q=80',
            height: 140,
            width: double.infinity,
            fit: BoxFit.cover,
            borderRadius: 12,
          ),
          const SizedBox(height: 12),
          Text(
            "Maria Lopez's Karinderia",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatusButton(
                  text: 'Open',
                  isActive: _isOpen,
                  color: Colors.green,
                  onTap: () {
                    setState(() {
                      _isOpen = true;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatusButton(
                  text: 'Close',
                  isActive: !_isOpen,
                  color: Colors.grey,
                  onTap: () {
                    setState(() {
                      _isOpen = false;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Changes saved!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black54,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              ),
              child: const Text('Save Changes', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton({
    required String text,
    required bool isActive,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: isActive ? color : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isActive ? Colors.white : Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodayMenuHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Today's Menu",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.edit, size: 20),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildMenuGrid() {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.85,
      children: _menuItems.map((item) => _buildMenuCard(item)).toList(),
    );
  }

  Widget _buildMenuCard(String itemName) {
    final menuImages = {
      'Menu': Icons.restaurant_menu,
      'Orders': Icons.receipt_long,
      'Stats': Icons.bar_chart,
      'Settings': Icons.settings,
      'Menudo': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=200&q=80',
      'Bihon': 'https://images.unsplash.com/photo-1585032226651-759b8d3761c4?auto=format&fit=crop&w=200&q=80',
      'Adobo': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=200&q=80',
      'Pakbet': 'https://images.unsplash.com/photo-1609501676725-7186f017a4b4?auto=format&fit=crop&w=200&q=80',
      'Lilaga': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=200&q=80',
      'Tinola': 'https://images.unsplash.com/photo-1585032226651-759b8d3761c4?auto=format&fit=crop&w=200&q=80',
      'Mongo': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=200&q=80',
      'Pochero': 'https://images.unsplash.com/photo-1609501676725-7186f017a4b4?auto=format&fit=crop&w=200&q=80',
    };

    return GestureDetector(
      onTap: () {
        if (itemName == 'Menu') {
          Navigator.pushNamed(context, '/owner-menu');
        }
      },
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (menuImages[itemName] is IconData)
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  menuImages[itemName] as IconData,
                  size: 32,
                  color: Colors.orange[700],
                ),
              )
            else
              _buildNetworkImage(
                imageUrl: menuImages[itemName] as String? ?? 'https://images.unsplash.com/photo-1604908176603-0280c68e3b30?auto=format&fit=crop&w=200&q=80',
                height: 65,
                width: 65,
                fit: BoxFit.cover,
                borderRadius: 8,
              ),
          const SizedBox(height: 4),
          Text(
            itemName,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      )
    );
  }
}