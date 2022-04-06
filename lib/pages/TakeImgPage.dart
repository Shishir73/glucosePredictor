import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:glucose_predictor/main.dart';

import '../main.dart';
import 'GalleryScreen.dart';

class TakeImgPage extends StatefulWidget {
  const TakeImgPage({Key? key}) : super(key: key);

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<TakeImgPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int selectedCamera = 0;
  List<File> capturedImages = [];

  initializeCamera(int selectedCamera) async {
    _controller =
        CameraController(cameras[selectedCamera], ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void initState() {
    initializeCamera(0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          const Spacer(),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (cameras.length > 1) {
                          setState(() {
                            selectedCamera = selectedCamera == 0 ? 1 : 0;
                            initializeCamera(selectedCamera);
                          });
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('No secondary camera found'),
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                      icon: const Icon(Icons.switch_camera_rounded,
                          color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await _initializeControllerFuture;
                        var xFile = await _controller.takePicture();
                        setState(() {
                          capturedImages.add(File(xFile.path));
                        });
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (capturedImages.isEmpty) return;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GalleryScreen(
                                    images: capturedImages.reversed.toList())));
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          image: capturedImages.isNotEmpty
                              ? DecorationImage(
                                  image: FileImage(capturedImages.last),
                                  fit: BoxFit.cover)
                              : null,
                        ),
                      ),
                    ),
                  ]))
        ]));
  }
}

// @override
// Widget build(BuildContext context) => const Scaffold(
//   backgroundColor: Colors.grey,
//   body: Center(
//     child: Text(
//       "Take Image",
//       style: TextStyle(fontSize: 60, color: Colors.white),
//     ),
//   ),
// );
