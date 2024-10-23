import 'package:favorite_place_app/models/place.dart';
import 'package:favorite_place_app/providers/place_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPlaceWidget extends ConsumerWidget {
  AddPlaceWidget({super.key});
  final TextEditingController placeTitleController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new place'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
        child: Column(
          children: [
            TextFormField(
              controller: placeTitleController,
              decoration:
                  const InputDecoration(label: Text('Enter the place title')),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Add Place')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
