import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;

  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.5063, -66.9145),
    zoom: 12,
  );
  final Set<Marker> _markers = {
    Marker(
        markerId: MarkerId("Abraham"),
        position: LatLng(10.5063, -66.9145),
        infoWindow: InfoWindow(title: "Casa de Abraham"))
  };

  void addMarker(LatLng latLong) async {
    TextEditingController textEditController = TextEditingController();

    String? title = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Añade un nombre'),
          content: TextField(
            controller: textEditController,
            decoration: InputDecoration(hintText: "Descripción del punto..."),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text('Cancelar')),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(textEditController.text),
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (title != null && title.isNotEmpty) {
      setState(() {
        _markers.add(
          Marker(
              markerId: MarkerId(latLong.toString()),
              position: latLong,
              infoWindow: InfoWindow(
                title: title,
              )),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa Guapardo'),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        onMapCreated: (controller) {
          _controller = controller;
        },
        mapType: MapType.normal,
        markers: _markers,
        onTap: (latLong) => addMarker(latLong),
      ),
    );
  }
}
