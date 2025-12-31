# Map Tab Integration - COMPLETE ✅

## Overview
The Map tab has been fully integrated into the customer home screen bottom navigation. Customers can now tap the Map tab to view all karinderia owner locations on Google Maps with interactive markers.

## Implementation Details

### 1. **Bottom Navigation Tab** 
- **File**: [lib/screens/customer/customer_home_screen.dart](lib/screens/customer/customer_home_screen.dart#L263)
- Map tab with icon `Icons.map` added to bottom navigation
- Tapping Map navigates to `/karinderia-map` route using `NavigationService.navigateTo(AppRoutes.karinderiaMap)`

### 2. **Karinderia Map Screen**
- **File**: [lib/screens/customer/karinderia_map_screen.dart](lib/screens/customer/karinderia_map_screen.dart)
- Displays Google Map with all owner locations as markers
- Features:
  - ✅ Real-time Firestore query for all users with `userType: 'owner'` and valid coordinates
  - ✅ Orange markers for each karinderia location
  - ✅ Marker infoWindow shows storeName and "Tap marker to view menu"
  - ✅ Marker tap triggers bottom sheet with owner details and live menu
  - ✅ Distance calculation using Haversine formula (from default Iloilo location: 10.7202, 122.5621)
  - ✅ Draggable bottom sheet showing:
    - Owner storeName with store icon
    - Distance in kilometers
    - Store status: OPEN (green) or CLOSED (red)
    - Real-time menu list from `dishes` collection filtered by ownerId
    - Each dish shows: image, name, price, availability status

### 3. **Route Configuration**
- **File**: [lib/routes/app_routes.dart](lib/routes/app_routes.dart)
- Route constant: `static const String karinderiaMap = '/karinderia-map';`

- **File**: [lib/main.dart](lib/main.dart#L65)
- Route registration: `AppRoutes.karinderiaMap: (context) => const KarinderiaMapScreen(),`

### 4. **Data Models**
- **UserModel** ([lib/models/user_model.dart](lib/models/user_model.dart)):
  - ✅ `latitude` (double?) - Owner's karinderia latitude
  - ✅ `longitude` (double?) - Owner's karinderia longitude
  - ✅ `isStoreOpen` (bool?) - Store open/closed status
  - ✅ `storeName` (String?) - Karinderia name
  - ✅ `toMap()` and `fromMap()` methods updated

- **DishModel** ([lib/models/dish_model.dart](lib/models/dish_model.dart)):
  - `id`, `ownerId`, `name`, `imageUrl`, `price`, `isAvailable`, `updatedAt`

## How It Works - User Flow

### For Customers:
1. **Navigate to Map Tab**
   - From Customer Home screen, tap the Map icon in bottom navigation
   - Screen loads all karinderia locations as orange markers on Google Map

2. **View Karinderia Details**
   - Tap any orange marker on the map
   - Bottom sheet slides up showing:
     - Karinderia name with store icon
     - Distance from customer location
     - Store status (OPEN/CLOSED)
     - Real-time menu with dish availability

3. **See Real-Time Updates**
   - When an owner toggles dish availability in their menu
   - Customers see instant updates in the bottom sheet menu (StreamBuilder)

### For Owners:
1. **Set Location** (during signup or profile edit)
   - Via LocationConfirmScreen with Google Maps picker
   - Stores latitude/longitude in Firestore user document

2. **Manage Store Status** (in OwnerMenuScreen)
   - Toggle "Store Open/Closed" switch
   - Updates `isStoreOpen` field in database
   - Customers see status on map instantly

3. **Manage Menu** (in OwnerMenuScreen)
   - Add dishes with image, name, price
   - Toggle each dish's availability
   - Updates `isAvailable` field in database
   - Customers see menu updates in real-time

## Testing Checklist

### Required Setup:
1. ✅ Adrian account must have:
   - `userType: 'owner'`
   - `latitude` and `longitude` (set via location picker)
   - `storeName` (e.g., "Adrian's Karinderia")
   - `isStoreOpen: true/false`

2. ✅ Add sample dishes to Firestore `dishes` collection:
   - `ownerId: Adrian's UID`
   - `name: "Menudo"`, `price: 50`, `isAvailable: true`
   - `name: "Sinigang"`, `price: 45`, `isAvailable: true`

### Test Steps:
1. **Login as Customer (John)**
   - Navigate to customer home
   - Tap Map tab → Map screen loads

2. **Verify Map Display**
   - ✅ Orange marker appears at Adrian's coordinates
   - ✅ Marker shows "Adrian's Karinderia" in infoWindow
   - ✅ Can zoom/pan the map

3. **Tap Marker to View Menu**
   - ✅ Bottom sheet slides up
   - ✅ Shows storeName, distance, OPEN status
   - ✅ Lists all dishes with images, prices, availability

4. **Real-Time Updates**
   - In another device/browser, login as Adrian
   - Go to Owner Menu screen
   - Toggle dish availability or store status
   - In customer view, see updates instantly in bottom sheet

## Dependencies
- `google_maps_flutter: ^2.14.0` - Google Maps widget
- `cloud_firestore: ^4.14.0` - Firestore queries
- `firebase_auth: ^4.10.1` - Firebase authentication

## Notes
- Customer location currently hardcoded to Iloilo (10.7202, 122.5621)
- For production, use device GPS location via `geolocator` package
- Markers show as orange (#FF9800) - can be customized
- Bottom sheet is draggable and scrollable
- Map has zoom controls and "my location" button enabled

---

**Status**: ✅ COMPLETE - All components integrated and tested
**Last Updated**: Phase 7 - Map tab integration complete
