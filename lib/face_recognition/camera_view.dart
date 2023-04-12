import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class CameraView extends StatefulWidget {
  final String title;
  final String? text;
  final Function(InputImage inputImage) onImage;
  final CameraLensDirection initialDirection;

  const CameraView({
    Key? key,
    required this.title,
    required this.text,
    required this.onImage,
    required this.initialDirection,
  }) : super(key: key);


  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  File? _image;
  String? _path;
  ImagePicker? _imagePicker;

  @override
  void initState() {
    super.initState();
    _imagePicker=ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),foregroundColor: Colors.black,
      ),
      body: galleryOrCameraButton(),
    );
  }

  Widget galleryOrCameraButton()=>ListView(
    shrinkWrap: true,
    children: [
      _image!=null? SizedBox(
        height: 400,
        width: 400,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(_image!),
            // if(widget.customPaint!=null)widget.customPaint!
          ],
        ),
      ): const Icon(
        Icons.image,
        size: 250,
      ),
      const SizedBox(height: 70,),
      // const Divider(color: Colors.blue, thickness: 3),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: const EdgeInsets.all(20),
              child: GestureDetector(
                  onTap: ()=> _getImage(ImageSource.gallery),
                  child: const Icon(Icons.image, size: 40,))
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                  onTap: ()=> _getImage(ImageSource.camera),
                  child: const Icon(Icons.camera, size: 40,))),
        ],
      ),
      if(_image!= null)
        Padding(padding: const EdgeInsets.all(16), child: Text(
            '${_path ==null ? '': 'image path: $_path'}\n\n${widget.text ?? ''}'
        ),)
    ],
  );

  Future _getImage(ImageSource source) async {
    setState(() {
      _image = null;
      _path = null;
    });
    final pickedFile = await _imagePicker?.pickImage(source: source);
    if (pickedFile != null) {
      _processPickedFile(pickedFile);
    }
    setState(() {});
  }

  Future _processPickedFile(XFile? pickedFile) async {
    final path = pickedFile?.path;
    if (path == null) {
      return;
    }
    setState(() {
      _image = File(path);
    });
    _path = path;
    final inputImage = InputImage.fromFilePath(path);
    widget.onImage(inputImage);
  }


}
