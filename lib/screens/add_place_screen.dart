import 'package:favorite_place_app/models/place.dart';
import 'package:favorite_place_app/providers/place_provider.dart';
import 'package:favorite_place_app/widgets/image_capture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final TextEditingController placeTitleController = TextEditingController();
  File? pickedImage;

  @override
  void dispose() {
    placeTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 12),
            ImageCapture(
              onPicImage: (image) {
                setState(() {
                  pickedImage = image;
                });
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () {
                if (placeTitleController.text.isEmpty || pickedImage == null) {
                  Fluttertoast.showToast(
                    msg: "Please fill all required fields",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                } else {
                  ref.read(placeProvider.notifier).addPlace(
                        Place(
                            title: placeTitleController.text,
                            image: pickedImage!),
                      );
                  Navigator.of(context).pop();
                }
                print(placeTitleController.text);
              },
              label: const Text('Add Place'),
            ),
          ],
        ),
      ),
    );
  }
}
