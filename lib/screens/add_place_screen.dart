import 'package:favorite_place_app/models/place.dart';
import 'package:favorite_place_app/providers/place_provider.dart';
import 'package:favorite_place_app/widgets/image_capture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPlaceScreen extends ConsumerWidget {
  AddPlaceScreen({super.key});
  final TextEditingController placeTitleController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextFormField(
              controller: placeTitleController,
              decoration: const InputDecoration(label: Text('Enter the title')),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(
              height: 12,
            ),
            const ImageCapture(),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton.icon(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (placeTitleController.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please enter the title",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  } else {
                    ref
                        .read(placeProvider.notifier)
                        .addPlace(Place(title: placeTitleController.text));
                    Navigator.of(context).pop();
                  }
                  print(placeTitleController.text);
                },
                label: const Text('Add Place')),
          ],
        ),
      ),
    );
  }
}
