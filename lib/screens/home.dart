import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpaper/screens/photos_controller.dart';
import 'package:wallpaper/utils/colors.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();

  PhotosController photoController = Get.put(PhotosController());
  @override
  void initState() {
    super.initState();
    photoController.getTrendingPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.secondary,
          title: Text(
            "Pexels",
            style: GoogleFonts.bebasNeue(fontSize: 30, letterSpacing: 1.5),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            children: [
              //Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(26, 0, 0, 0),
                    border: Border.all(
                      color: Colors.black38,
                    ),
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                            hintText: "Search Wallpapers",
                            isDense: true,
                            errorBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            border: InputBorder.none),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          photoController
                              .getSearchPhotos(_searchController.text);
                        },
                        icon: const Icon(Icons.search_rounded))
                  ],
                ),
              ),

              const SizedBox(
                height: 30,
              ),
              // gridview
              Expanded(
                child: Obx(
                  () => GridView.builder(
                    itemCount: photoController.photos.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            mainAxisExtent: 300),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.defaultDialog(
                              title: "Download Wallpaper",
                              middleText:
                                  "Do you want to download this wallpaper in your local storage?",
                              titlePadding: const EdgeInsets.only(top: 20),
                              contentPadding: const EdgeInsets.all(20),
                              confirm: TextButton(
                                  onPressed: () {
                                    _saveImage(context,
                                        photoController.photos.value[index]);
                                    Get.back();
                                  },
                                  child: const Text("Download")),
                              cancel: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("No")));
                        },
                        child: Container(
                          child: photoController.photos.isNotEmpty
                              ? Image.network(
                                  photoController.photos.value[index],
                                  fit: BoxFit.fill)
                              : Container(),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveImage(BuildContext context, String url) async {
    String? message;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      // Download image
      final http.Response response = await http.get(Uri.parse(url));

      // Get temporary directory
      final dir = await getTemporaryDirectory();

      // Create an image name
      final rng = Random(40000);
      final imageName = rng.nextInt(9999);
      var filename = '${dir.path}/$imageName.png';

      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        message = 'Image saved to disk';
      }
    } catch (e) {
      message = 'An error occurred while saving the image';
    }

    if (message != null) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
