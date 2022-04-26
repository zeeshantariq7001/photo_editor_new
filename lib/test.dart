import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class TestClass extends StatefulWidget {
  @override
  State<TestClass> createState() => _TestClassState();
}

class _TestClassState extends State<TestClass> {
  VideoPlayerController _controller;
  @override
  Widget build(BuildContext context) {
    VideoPlayerController _videocontroller;
    File _video;
    final pickerr = ImagePicker();
    _videopicker() async {
      final video = await pickerr
          .pickVideo(source: ImageSource.gallery)
          .whenComplete(() => Fluttertoast.showToast(msg: "Video Selected"));
      setState(() {
        _video = File(video.path);
        VideoPlayerController _videocontroller =
            VideoPlayerController.file(_video)
              ..initialize().then((_) {
                setState(() {});
              });
        _videocontroller.play();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Test Screen"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _video != null
              ? _videocontroller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videocontroller.value.aspectRatio,
                      child: VideoPlayer(_videocontroller),
                    )
                  : Container()
              : ElevatedButton(
                  onPressed: () {
                    _videopicker();
                  },
                  child: Text("pick video"))
        ],
      ),
    );
  }
}
