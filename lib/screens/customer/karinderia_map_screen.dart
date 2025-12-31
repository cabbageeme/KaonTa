import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' show cos, sqrt, asin;
import '../../models/user_model.dart';
import '../../models/dish_model.dart';

class KarinderiaMapScreen extends StatefulWidget {
  const KarinderiaMapScreen({super.key});

  @override
  State<KarinderiaMapScreen> createState() => _KarinderiaMapScreenState();
}

class _KarinderiaMapScreenState extends State<KarinderiaMapScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Set<Marker> _markers = {};
  bool _isLoading = true;
  Map<String, UserModel> _owners = {};

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
            c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  @override
  void initState() {
    super.initState();
    _loadKarinderiaLocations();
  }

  Future<void> _loadKarinderiaLocations() async {
    try {
      // Fetch all owner users with location data
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('userType', isEqualTo: 'owner')
          .get();

      Set<Marker> markers = {};
      Map<String, UserModel> owners = {};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final latitude = data['latitude'] as double?;
        final longitude = data['longitude'] as double?;
        final userModel = UserModel.fromMap(data);

        if (latitude != null && longitude != null) {
          owners[doc.id] = userModel;
          
          markers.add(
            Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: userModel.storeName ?? 'Karinderia',
                snippet: 'Tap marker to view menu',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
              onTap: () => _showKarinderiaDetails(doc.id),
            ),
          );
        }
      }

      setState(() {
        _markers = markers;
        _owners = owners;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading locations: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showKarinderiaDetails(String ownerId) {
    final owner = _owners[ownerId];
    if (owner == null) return;

    final distance = _calculateDistance(
      10.7202, 122.5621, // Customer location (Iloilo default)
      owner.latitude!, owner.longitude!,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('dishes')
                .where('ownerId', isEqualTo: ownerId)
                .snapshots(),
            builder: (context, snapshot) {
              final dishes = snapshot.hasData
                  ? snapshot.data!.docs
                      .map((doc) => DishModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                      .toList()
                  : <DishModel>[];

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.orange[200],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.store, color: Colors.white, size: 30),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    owner.storeName ?? 'Karinderia',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 16, color: Colors.orange[600]),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${distance.toStringAsFixed(2)} km away',
                                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: owner.isStoreOpen == true ? Colors.green : Colors.red,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          owner.isStoreOpen == true ? 'OPEN' : 'CLOSED',
                                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.restaurant_menu, size: 20),
                        SizedBox(width: 8),
                        Text('Available Menu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: dishes.isEmpty
                        ? Center(
                            child: Text('No menu available', style: TextStyle(color: Colors.grey[600])),
                          )
                        : ListView.separated(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: dishes.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final dish = dishes[index];
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: dish.isAvailable ? Colors.white : Colors.grey[100],
                                  border: Border.all(color: Colors.grey[200]!),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        dish.imageUrl,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          width: 50,
                                          height: 50,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.fastfood, size: 24),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(dish.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                          Text('₱${dish.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: dish.isAvailable ? Colors.green[100] : Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        dish.isAvailable ? 'Available' : 'Out of stock',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: dish.isAvailable ? Colors.green[700] : Colors.grey[700],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text('Karinderia Locations', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _markers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No Karinderias Found',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _markers.first.position,
                    zoom: 13,
                  ),
                  markers: _markers,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                ),
    );
  }
}
