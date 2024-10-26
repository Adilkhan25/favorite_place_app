import 'package:favorite_place_app/models/place.dart';
import 'package:favorite_place_app/widgets/map_preview.dart';
import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({
    super.key,
    required this.place,
  });
  final Place place;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                ClipOval(
                  child: SizedBox(
                    height: 90,
                    width: 90,
                    child: MapPreview(
                        lat: place.location.lat, lng: place.location.long),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.transparent,
                    Colors.black54,
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  child: Text(
                    textAlign: TextAlign.center,
                    place.location.address,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
