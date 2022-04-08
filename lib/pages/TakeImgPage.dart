import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:glucose_predictor/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../main.dart';
import 'ConfirmScreen.dart';

class TakeImgPage extends StatefulWidget {
  const TakeImgPage({Key? key}) : super(key: key);

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<TakeImgPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int selectedCamera = 0;
  final ImagePicker _picker = ImagePicker();
  late XFile capturedImage;
  File? _galleryImage;

  initializeCamera(int selectedCamera) async {
    _controller =
        CameraController(cameras[selectedCamera], ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void initState() {
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future openGallery() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _galleryImage = image as File?;
    });
  }

  void takePhoto() async {
    XFile takePic = await _controller.takePicture();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => ConfirmScreen(takePic.path)));
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(3.0, 90.0, 3.0, 8.0),
          child: Center(
            child: SizedBox(
              height: 460,
              width: 400,
              child: CameraPreview(_controller),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 2.0, 3.0, 3.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white60,
                shadowColor: Colors.white12,
                elevation: 100,
                minimumSize: const Size(5, 5),
              ),
              onPressed: openGallery,
              child: const Icon(
                Icons.photo,
                size: 54,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 75, height: 10),
            MaterialButton(
              shape: const CircleBorder(),
              color: Colors.white,
              padding: const EdgeInsets.all(0.5),
              onPressed: () {
                takePhoto();
                setState(() {});
              },
              child: const Icon(
                Icons.camera,
                size: 52,
                color: Colors.grey,
              ),
            ),
          ]),
        )
      ]);
    }
  }
}
