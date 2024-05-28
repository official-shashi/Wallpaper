import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:http/http.dart' as http;
import 'package:image_downloader/image_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// ignore: must_be_immutable
class FullScreen extends StatelessWidget {
  String imgUrl;
  FullScreen({
    Key? key,
    required this.imgUrl,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> downloadWallpaper(
      String wallpaperUrl, BuildContext context) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Downloading Started...")));
    try {
      var imageId = await ImageDownloader.downloadImage(wallpaperUrl);
      if (imageId == null) {
        return;
      }
      var path = await ImageDownloader.findPath(imageId);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Downloaded Successfully"),
        action: SnackBarAction(
            label: "Open",
            onPressed: () {
              OpenFile.open(path);
            }),
      ));
    } on PlatformException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error Occured - $error")));
    }
  }

  Future<void> setWallpaper(
      String filePath, int location, BuildContext context) async {
    try {
      bool result =
          await WallpaperManager.setWallpaperFromFile(filePath, location);

      if (result) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wallpaper applied successfully..!'),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to apply wallpaper.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to apply wallpaper: $e'),
        ),
      );
    }
  }

  Future<void> downloadAndSetWallpaper(
      int location, BuildContext context) async {
    try {
      var response = await http.get(Uri.parse(imgUrl));
      if (response.statusCode == 200) {
        var dir = await getTemporaryDirectory();
        File file = File('${dir.path}/wallpaper.png');
        await file.writeAsBytes(response.bodyBytes);

        // ignore: use_build_context_synchronously
        await setWallpaper(file.path, location, context);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to download image.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download image: $e'),
        ),
      );
    }
  }

  void _showWallpaperOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home Screen'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await downloadAndSetWallpaper(
                      WallpaperManager.HOME_SCREEN, context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Lock Screen'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await downloadAndSetWallpaper(
                      WallpaperManager.LOCK_SCREEN, context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone_android),
                title: const Text('Both Screens'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await downloadAndSetWallpaper(
                      WallpaperManager.BOTH_SCREEN, context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 150,
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () async {
                await downloadWallpaper(imgUrl, context);
              },
              child: const Text(
                "Download",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ),
          Container(
            width: 150,
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () {
                _showWallpaperOptions(context);
              },
              child: const Text(
                "Apply",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imgUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FullScreen(
      imgUrl:
          'https://images.pexels.com/photos/24288983/pexels-photo-24288983.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800',
    ),
  ));
}
