import 'package:favorite_place_app/models/place.dart';
import 'package:favorite_place_app/screens/map_screen.dart';
import 'package:favorite_place_app/widgets/map_preview.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchLocation extends StatefulWidget {
  const FetchLocation({super.key, required this.onFetchLocation});
  final void Function(PlaceLocation location) onFetchLocation;
  @override
  State<FetchLocation> createState() {
    return _FetchLocationState();
  }
}

class _FetchLocationState extends State<FetchLocation> {
  bool isLocationFetching = false;
  PlaceLocation? pickedLocation;

  void fetchCurrentLocation() async {
    try {
      final location = Location();
      bool isServiceEnable;
      PermissionStatus hasPermission;
      LocationData locationData;
      isServiceEnable = await location.serviceEnabled();
      if (!isServiceEnable) {
        isServiceEnable = await location.requestService();
        if (!isServiceEnable) return;
      }
      hasPermission = await location.hasPermission();
      if (hasPermission == PermissionStatus.denied) {
        hasPermission = await location.requestPermission();
        if (hasPermission != PermissionStatus.granted) return;
      }
      setState(() {
        isLocationFetching = true;
      });
      locationData = await location.getLocation();
      final lat = locationData.latitude;
      final long = locationData.longitude;
      if (lat == null || long == null) return;
      final response = await http.get(Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$long&format=json'));

      final data = jsonDecode(response.body);

      setState(() {
        isLocationFetching = false;
        pickedLocation =
            PlaceLocation(lat: lat, long: long, address: data['display_name']);
        widget.onFetchLocation(pickedLocation!);
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              'Oops! something went to wrong while fetching the location, please try again.',
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        preview,
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              onPressed: fetchCurrentLocation,
              label: const Text('Fetch current location'),
            ),
            TextButton.icon(
              icon: const Icon(Icons.navigation),
              onPressed: () async {
                final selectLocation = await Navigator.of(context)
                    .push<PlaceLocation>(
                        MaterialPageRoute(builder: (ctx) => const MapScreen()));
                print(' lat ${selectLocation!.lat} and lon ${selectLocation.long}');
                setState(() {
                  pickedLocation = selectLocation;

                  widget.onFetchLocation(pickedLocation!);
                });
              },
              label: const Text('Choose location manually'),
            ),
          ],
        )
      ],
    );
  }

  Widget get preview {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 170,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
      ),
      child: isLocationFetching == true
          ? const CircularProgressIndicator()
          : pickedLocation == null
              ? Text(
                  'No location choosen yet',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                )
              : MapPreview(lat: pickedLocation!.lat, lng: pickedLocation!.long),
    );
  }
}
