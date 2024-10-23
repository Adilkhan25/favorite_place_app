import 'package:favorite_place_app/main.dart';
import 'package:favorite_place_app/widgets/add_place_widget.dart';
import 'package:favorite_place_app/widgets/place_widget.dart';
import 'package:flutter/material.dart';

class PlaceListScreen extends StatelessWidget {
  const PlaceListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.onSecondary,
        title: const Text('Your Places'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddPlaceWidget(),
                  ),
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: const PlaceWidget(),
    );
  }
}
