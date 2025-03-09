import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final List<Map<String, dynamic>> filmStudios = [
    {"name": "Universal Studios Hollywood", "location": LatLng(34.1381, -118.3534)},
    {"name": "Warner Bros. Studios", "location": LatLng(34.1486, -118.3372)},
    {"name": "Paramount Pictures", "location": LatLng(34.0837, -118.3200)},
    {"name": "Pinewood Studios", "location": LatLng(51.6905, -0.5347)},
    {"name": "Netflix Studios", "location": LatLng(34.0522, -118.2437)},
  ];

  Set<Marker> _createMarkers() {
    print("Creating markers...");
    return filmStudios.map((studio) {
      print("Adding marker for ${studio['name']}");
      return Marker(
        markerId: MarkerId(studio['name']),
        position: studio['location'],
        infoWindow: InfoWindow(title: studio['name']),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    print("Building MapScreen...");
    return Scaffold(
      appBar: AppBar(
        title: Text('Film Studios Map'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          print("Map created");
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(34.0522, -118.2437),
          zoom: 10,
        ),
        markers: _createMarkers(),
      ),
    );
  }
}
