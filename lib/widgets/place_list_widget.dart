import 'package:favorite_place_app/providers/place_provider.dart';
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              //   leading: Image.network(place.imageUrl, width: 100, fit: BoxFit.cover),
              title: Text(
                places[index].title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              // subtitle: Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(place.location),
              //     SizedBox(height: 4),
              //     Row(
              //       children: [
              //         Icon(Icons.star, color: Colors.orange, size: 16),
              //         Text('${place.rating}', style: TextStyle(fontSize: 14)),
              //       ],
              //     ),
              //   ],
              // ),
              // trailing: Icon(Icons.arrow_forward_ios),

              onTap: () {
                // Navigate to a detailed screen
              },
            ),
            //    ),
          );
  }
}
