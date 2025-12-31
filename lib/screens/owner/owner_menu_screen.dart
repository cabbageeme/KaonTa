import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/dish_model.dart';
import '../../repositories/user_repository.dart';

class OwnerMenuScreen extends StatefulWidget {
  const OwnerMenuScreen({super.key});

  @override
  State<OwnerMenuScreen> createState() => _OwnerMenuScreenState();
}

class _OwnerMenuScreenState extends State<OwnerMenuScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserRepository _userRepository = UserRepository();
  bool _isStoreOpen = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStoreStatus();
  }

  Future<void> _loadStoreStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await _userRepository.getUser(user.uid);
      setState(() {
        _isStoreOpen = userData?.isStoreOpen ?? false;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleStoreStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _isStoreOpen = !_isStoreOpen;
    });

    await _userRepository.updateUser(user.uid, {'isStoreOpen': _isStoreOpen});

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Store is now ${_isStoreOpen ? "OPEN" : "CLOSED"}'),
          backgroundColor: _isStoreOpen ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text('Menu Management', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildStoreStatusToggle(),
                const Divider(height: 1),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('dishes')
                        .where('ownerId', isEqualTo: user?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.restaurant_menu, size: 64, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text('No dishes yet', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                              const SizedBox(height: 8),
                              Text('Tap + to add your first dish', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
                            ],
                          ),
                        );
                      }

                      final dishes = snapshot.data!.docs
                          .map((doc) => DishModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                          .toList();

                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: dishes.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => _buildDishCard(dishes[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDishDialog,
        backgroundColor: Colors.orange[500],
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStoreStatusToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: _isStoreOpen ? Colors.green[50] : Colors.red[50],
      child: Row(
        children: [
          Icon(
            _isStoreOpen ? Icons.store : Icons.store_mall_directory_outlined,
            color: _isStoreOpen ? Colors.green[700] : Colors.red[700],
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Store Status',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  _isStoreOpen ? 'OPEN' : 'CLOSED',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _isStoreOpen ? Colors.green[700] : Colors.red[700],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isStoreOpen,
            onChanged: (_) => _toggleStoreStatus(),
            activeColor: Colors.green[700],
          ),
        ],
      ),
    );
  }

  Widget _buildDishCard(DishModel dish) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              dish.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: const Icon(Icons.fastfood, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dish.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('₱${dish.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Switch(
                value: dish.isAvailable,
                onChanged: (value) => _toggleDishAvailability(dish.id, value),
                activeColor: Colors.green[600],
              ),
              Text(
                dish.isAvailable ? 'Available' : 'Unavailable',
                style: TextStyle(
                  fontSize: 11,
                  color: dish.isAvailable ? Colors.green[600] : Colors.grey[500],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _toggleDishAvailability(String dishId, bool isAvailable) async {
    await _firestore.collection('dishes').doc(dishId).update({
      'isAvailable': isAvailable,
      'updatedAt': DateTime.now().toIso8601String(),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAvailable ? 'Dish is now available!' : 'Dish marked as unavailable'),
          backgroundColor: isAvailable ? Colors.green : Colors.grey,
        ),
      );
    }
  }

  void _showAddDishDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Dish'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Dish Name',
                  hintText: 'e.g., Menudo',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: '50.00',
                  prefixText: '₱',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'https://...',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty || priceController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields'), backgroundColor: Colors.red),
                );
                return;
              }

              final user = FirebaseAuth.instance.currentUser;
              if (user == null) return;

              final newDish = {
                'ownerId': user.uid,
                'name': nameController.text,
                'price': double.tryParse(priceController.text) ?? 0.0,
                'imageUrl': imageController.text.isEmpty
                    ? 'https://via.placeholder.com/200'
                    : imageController.text,
                'isAvailable': false,
                'updatedAt': DateTime.now().toIso8601String(),
              };

              await _firestore.collection('dishes').add(newDish);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dish added successfully!'), backgroundColor: Colors.green),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[500]),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
