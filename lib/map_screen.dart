import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  List<LatLng> tappedPoints = [];
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  void _onMapTapped(LatLng point) {
    setState(() {
      if (tappedPoints.length == 2) {
        tappedPoints.clear();
        markers.clear();
        polylines.clear();
      } else {
        tappedPoints.add(point);

        markers.add(
          Marker(
            markerId: MarkerId(point.toString()),
            position: point,
            infoWindow: InfoWindow(
              title: tappedPoints.length == 1 ? 'Start Point' : 'End Point',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(tappedPoints.length == 1
                ? BitmapDescriptor.hueGreen
                : BitmapDescriptor.hueRed),
          ),
        );

        if (tappedPoints.length == 2) {
          polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              points: tappedPoints,
              color: Colors.purple,
              width: 5,
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Maps Polyline"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: GoogleMap(
        onMapCreated: (controller) => mapController = controller,
        onTap: _onMapTapped,
        initialCameraPosition: CameraPosition(
          target: LatLng(14.5995, 120.9842),
          zoom: 10,
        ),
        markers: markers,
        polylines: polylines,
      ),
    );
  }
}
