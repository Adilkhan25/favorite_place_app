import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageCapture extends StatefulWidget {
  const ImageCapture({super.key, required this.onPicImage});
  final void Function(File image) onPicImage;
  @override
  State<ImageCapture> createState() {
    return _ImageCaptureState();
  }
}

class _ImageCaptureState extends State<ImageCapture> {
  File? _picture;
  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedImage == null) return;
    setState(() {
      _picture = File(pickedImage.path);
    });
    widget.onPicImage(_picture!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: _takePicture,
      label: const Text('Take the picture'),
      icon: const Icon(Icons.camera_enhance),
    );
    if (_picture != null) {
      content = InkWell(
        onTap: _takePicture,
        child: Image.file(
          _picture!,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      );
    }
    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
      ),
      child: content,
    );
  }
}
