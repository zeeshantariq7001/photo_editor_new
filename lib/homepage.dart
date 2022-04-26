import 'dart:io';
import 'dart:typed_data';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photofilters/photofilters.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

File _image;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textt = TextEditingController();
  Offset offset = Offset.zero;

  String textvalue = '';
  _HomePageState({this.textvalue});
  ScreenshotController screenshotController = ScreenshotController();

  Color primarycolor = Colors.transparent;
  final picker = ImagePicker();
  List<Color> colorsG = [];
  _imagePickerFromGallery() async {
    try {
      final pick = await picker.pickImage(source: ImageSource.gallery);
      if (pick != null) {
        setState(() {
          _image = File(pick.path);
        });
      }
    } catch (e) {}
  }

  _imagePickerFromCamera() async {
    try {
      final pick = await picker.pickImage(source: ImageSource.camera);
      if (pick != null) {
        setState(() {
          _image = File(pick.path);
        });
      }
    } catch (e) {}
  }

  cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxHeight: 700,
        maxWidth: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.red,
            toolbarTitle: "Baaghi Cropper",
            statusBarColor: Colors.amber,
            backgroundColor: Colors.white));
    this.setState(() {
      _image = cropped;
    });
  }

  File image;
  var _permissionStatus;
  List<dynamic> listImagePath = List<dynamic>();
  Future _futureGetPath;

  @override
  void initState() {
    super.initState();
    _listenForPermissionStatus();

    _futureGetPath = _getPath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              share();
            },
            icon: Icon(
              Icons.share,
              color: Colors.white,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: () async {
              save();
            },
            icon: Icon(
              Icons.save,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
        title: Text("Photo Lab"),
        centerTitle: true,
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        children: [
          SpeedDialChild(
            onTap: () {
              _imagePickerFromCamera();
              ;
            },
            child: Icon(Icons.camera),
          ),
          SpeedDialChild(
            onTap: () {
              _imagePickerFromGallery();
            },
            child: Icon(Icons.photo),
          ),
        ],
      ),
      body: Container(
        color: Colors.amber.withOpacity(0.3),
        child: ListView(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image != null
                  ? Screenshot(
                      controller: screenshotController,
                      child: Stack(children: [
                        Container(
                          height: 60.h,
                          width: 60.w,
                          child: ShaderMask(
                            shaderCallback: (bounds) =>
                                LinearGradient(colors: colorsG).createShader(
                                    Rect.fromLTWH(
                                        0, 0, bounds.width, bounds.height)),
                            child: Image.file(_image),
                          ),
                        ),
                        textcontainer()
                      ]),
                    )
                  : Center(
                      child: Text(
                        "Choose an image from gallery",
                        style: GoogleFonts.actor(
                          textStyle: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),

              _image != null
                  ? Column(
                      children: [
                        Text("Choose Filters..."),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              containerG(Colors.teal, Colors.brown,
                                  Colors.amber, Colors.red),
                              containerG(Colors.red, Colors.green, Colors.grey,
                                  Colors.purple),
                              containerG(
                                  Colors.amber.withOpacity(0.7),
                                  Colors.indigo.withOpacity(0.7),
                                  Colors.pink.withOpacity(0.7),
                                  Colors.black),
                              containerG(Colors.indigo, Colors.red,
                                  Colors.brown, Colors.white),
                              containerG(Colors.blue, Colors.green,
                                  Colors.amber, Colors.lightBlue),
                              containerG(Colors.green, Colors.lime,
                                  Colors.orangeAccent, Colors.deepPurple),
                              containerG(Colors.grey, Colors.grey,
                                  Colors.deepOrange, Colors.blueAccent),
                              containerG(
                                  Colors.orange,
                                  Colors.greenAccent,
                                  Colors.red.withOpacity(0.8),
                                  Colors.amberAccent.withOpacity(0.8)),
                              containerG(
                                  Colors.tealAccent,
                                  Colors.teal,
                                  Colors.cyanAccent,
                                  Colors.pink.withOpacity(0.8)),
                            ],
                          ),
                        ),
                        Divider(),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              containerF(
                                Colors.teal,
                              ),
                              containerF(
                                Colors.red,
                              ),
                              containerF(
                                Colors.amber,
                              ),
                              containerF(
                                Colors.indigo,
                              ),
                              containerF(
                                Colors.blue,
                              ),
                              containerF(
                                Colors.green,
                              ),
                              containerF(
                                Colors.grey,
                              ),
                              containerF(
                                Colors.orange,
                              ),
                              containerF(
                                Colors.tealAccent,
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Row(
                          children: [
                            dialogue(context),
                            InkWell(
                              onTap: () {
                                cropImage();
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 3),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: Icon(Icons.crop),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : SizedBox(),

              // _image != null
              //     ? ElevatedButton(
              //         onPressed: () {
              //           transparentclr();
              //         },
              //         child: Text("Reset Filter"))
              //     : Container()
            ],
          ),
        ]),
      ),
    );
  }

  Padding dialogue(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return SimpleDialog(
                      title: Text("Text"),
                      children: [
                        TextFormField(
                          controller: textt,
                          decoration:
                              InputDecoration(labelText: "Enter Text..."),
                          onChanged: (value) {
                            setState(() {
                              textvalue = value;
                            });
                          },
                        )
                      ],
                    );
                  });
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(50)),
              child: Center(child: Text("Text")),
            ),
          ),
        ],
      ),
    );
  }

  Padding containerG(Color clr, Color a, Color b, Color c) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [a, b, c]),
            color: clr,
            borderRadius: BorderRadius.circular(40)),
        child: InkWell(
          onTap: () {
            setState(() {
              colorsG = [a, b, c];
            });
          },
        ),
      ),
    );
  }

  Padding containerF(Color clr) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 30,
        width: 30,
        decoration:
            BoxDecoration(color: clr, borderRadius: BorderRadius.circular(40)),
        child: InkWell(
          onTap: () {
            setState(() {
              colorsG = [clr, clr, clr];
            });
          },
        ),
      ),
    );
  }

  Container textcontainer() {
    return Container(
      child: Positioned(
        left: offset.dx,
        top: offset.dy,
        child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                offset = Offset(
                    offset.dx + details.delta.dx, offset.dy + details.delta.dy);
              });
            },
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text("${textvalue == null ? "" : textvalue}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white.withOpacity(0.8))),
                ),
              ),
            )),
      ),
    );
  }

  void share() async {
    await screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((Uint8List image) async {
      if (_image != null) {
        final directory = await getApplicationDocumentsDirectory();
        String d = DateTime.now().microsecondsSinceEpoch.toString();

        final imagePath = await File('${directory.path}/image$d.png').create();
        await imagePath.writeAsBytes(image);

        /// Share Plugin
        await Share.shareFiles([imagePath.path]);
      }
    });
  }

  void save() async {
    await screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((Uint8List image) async {
      if (image != null) {
        List<Directory> directory = await getExternalStorageDirectories();
        String d = DateTime.now().microsecondsSinceEpoch.toString();

        final imagePath =
            await File('/storage/emulated/0/Download/$d.jpg').create();
        await imagePath
            .writeAsBytes(image)
            .whenComplete(
                () => Fluttertoast.showToast(msg: "Image saved successfully!"))
            .catchError((e) {
          print(e.toString());
        });
        print(imagePath);
      }
    });
  }

  void _listenForPermissionStatus() async {
    final status = await Permission.storage.request().isGranted;
    setState(() => _permissionStatus = status);
  }

  Future<String> _getPath() {
    return ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
  }

  _fetchFiles(Directory dir) {
    List<dynamic> listImage = List<dynamic>();
    dir.list().forEach((element) {
      RegExp regExp =
          new RegExp("\.(gif|jpe?g|tiff?|png|webp|bmp)", caseSensitive: false);
      if (regExp.hasMatch('$element')) listImage.add(element);
      setState(() {
        listImagePath = listImage;
      });
    });
  }
}
