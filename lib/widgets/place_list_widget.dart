import 'package:favorite_place_app/providers/place_provider.dart';
import 'package:favorite_place_app/screens/place_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceListWidget extends ConsumerWidget {
  const PlaceListWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(placeProvider);
    return places.isEmpty
        ? Center(
            child: Text(
              'No place added yet',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          )
        : ListView.builder(
            itemCount: places.length,
            itemBuilder: (ctx, index) =>
                //  Card(
                //     margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                //     elevation: 2,
                //     child:
                ListTile(
              minTileHeight: 10,
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                radius: 26,
                backgroundImage: FileImage(places[index].image),
              ),
              title: Text(
                places[index].title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => PlaceDetailsScreen(place: places[index]),
                  ),
                );
              },
            ),
            //    ),
          );
  }
}
