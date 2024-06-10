import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImageClass extends StatefulWidget {
  const PickImageClass({super.key});

  @override
  _PickImageClassState createState() => _PickImageClassState();
}

class _PickImageClassState extends State<PickImageClass> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _pickedImage;

  Future<void> _pickImageFromGallery() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = image != null ? XFile(image.path) : null;
    });
  }

  Future<void> _captureImageFromCamera() async {
    final image = await _imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _pickedImage = image != null ? XFile(image.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختيار صورة الوصل',style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
        ),),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_pickedImage != null)
              Image.file(
                File(_pickedImage!.path),
                height: 200,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImageFromGallery,
              child: const Text('اختيار صورة من المعرض'),
            ),
            ElevatedButton(
              onPressed: _captureImageFromCamera,
              child: const Text('التقاط صورة باستخدام الكاميرا'),
            ),
          ],
        ),
      ),
    );
  }
}