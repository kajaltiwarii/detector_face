import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/material.dart';
import 'camera_view.dart';

class FaceDetectorPage extends StatefulWidget {
  const FaceDetectorPage({Key? key}) : super(key: key);

  @override
  State<FaceDetectorPage> createState() => _FaceDetectorPageState();
}

class _FaceDetectorPageState extends State<FaceDetectorPage> {

  ///create face detector object

  final FaceDetector _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
      )
  );
  String? _text;

  @override
  void dispose(){
    _faceDetector.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Face Detector',
      text: _text,
      onImage: (inputImage) {
        processImage(inputImage);
      },
      initialDirection: CameraLensDirection.front,);
  }
  Future<void> processImage(InputImage inputImage) async {
    setState(() {
      _text = '';
    });
    final faces = await _faceDetector.processImage(inputImage);
    String text = 'Faces found: ${faces.length}\n\n';
    for (final face in faces) {
      text += 'face: ${face.boundingBox}\n\n';
    }
    _text = text;
    if (mounted) {
      setState(() {});
    }
  }
}

