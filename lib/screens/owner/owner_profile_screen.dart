import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text('Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(),
              const SizedBox(height: 32),
              _buildSectionTitle('Karinderia Details'),
              const SizedBox(height: 16),
              _buildInfoTile(
                label: 'Karinderia Name',
                value: "Maria Lopez's Karinderia",
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _buildInfoTile(
                label: 'Current Location',
                value: 'Jalandoni 7th St. Jaro Iloilo City, Philippines',
                onTap: _showLocationEditModal,
                actionIcon: Icons.edit,
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Account'),
              const SizedBox(height: 16),
              _buildMenuOption(
                icon: Icons.edit,
                label: 'Edit Profile',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _buildMenuOption(
                icon: Icons.lock,
                label: 'Change Password',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _buildMenuOption(
                icon: Icons.notifications,
                label: 'Notifications',
                onTap: () {},
              ),
              const SizedBox(height: 32),
              _buildSignOutButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2AD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: _buildNetworkImage(
              imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=200&q=80',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              borderRadius: 40,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Adrian Santos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Karinderia Owner',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 6),
                Text(
                  'adrian@karinderia.com',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildInfoTile({
    required String label,
    required String value,
    required VoidCallback onTap,
    IconData? actionIcon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (actionIcon != null)
              Icon(actionIcon, size: 18, color: Colors.grey[400])
            else
              Icon(Icons.chevron_right, size: 20, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.black54),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
            Icon(Icons.chevron_right, size: 20, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildSignOutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSignOut,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[400],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'Sign Out',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void _showLocationEditModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const LocationEditSheet(),
    );
  }

  void _handleSignOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              // Sign out from Firebase
              await FirebaseAuth.instance.signOut();
              // Navigate to splash screen
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/splash', (route) => false);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
            child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class LocationEditSheet extends StatefulWidget {
  const LocationEditSheet({super.key});

  @override
  State<LocationEditSheet> createState() => _LocationEditSheetState();
}

class _LocationEditSheetState extends State<LocationEditSheet> {
  late TextEditingController _searchController;
  final List<String> _suggestions = [
    'Jalandoni 7th St. Jaro Iloilo City, Philippines',
    'Jaro Plaza, Iloilo City, Philippines',
    'Lopez Jaena St. Jaro, Iloilo City',
    'Jaro Cathedral, Iloilo City, Philippines',
    'SM City Iloilo, Mandurriao, Iloilo City',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: 'Jalandoni 7th St. Jaro Iloilo City, Philippines',
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Edit Karinderia Location',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Enter your address...',
              prefixIcon: Icon(Icons.location_on, color: Colors.orange[500]),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Recent Locations',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.location_on_outlined, color: Colors.orange[500]),
                title: Text(_suggestions[index], style: const TextStyle(fontSize: 13)),
                onTap: () {
                  _searchController.text = _suggestions[index];
                  Navigator.pop(context);
                  _showConfirmDialog(_suggestions[index]);
                },
              );
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showConfirmDialog(_searchController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[500],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Update Location', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showConfirmDialog(String location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Location'),
        content: Text('Update your karinderia location to:\n\n$location?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Location updated successfully!'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[500]),
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
