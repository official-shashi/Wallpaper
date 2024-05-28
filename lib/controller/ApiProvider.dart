// ignore_for_file: file_names

import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import '../model/photos_modal.dart';
import '../model/category_model.dart';

class ApiProvider {
  static List<PhotosModel> trendingWallpapers = [];
  static Future<List<PhotosModel>> getTrendingWallpaper() async {
    await http.get(Uri.parse("https://api.pexels.com/v1/curated?per_page=80"),
        headers: {
          "Authorization":
              "WPxWdAqQYiohFEOUMhGM7akzgCGoto0FtUXuMbVyIeSdLcDA9HFbXUCE"
          // ignore: avoid_print
        }).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData["photos"];
      for (var element in photos) {
        trendingWallpapers.add(PhotosModel.fromApiToApp(element));
      }
    });
    return trendingWallpapers;
  }

  static List<PhotosModel> searchWallpapers = [];
  static Future<List<PhotosModel>> getSearchWallpaper(String query) async {
    await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&per_page=80&page=1"),
        headers: {
          "Authorization":
              "WPxWdAqQYiohFEOUMhGM7akzgCGoto0FtUXuMbVyIeSdLcDA9HFbXUCE"
          // ignore: avoid_print
        }).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData["photos"];
      searchWallpapers.clear();
      for (var element in photos) {
        searchWallpapers.add(PhotosModel.fromApiToApp(element));
      }
    });
    return searchWallpapers;
  }

  static Future<List<CategoryModel>> getCategoriesList() async {
    List<String> categoryName = [
      "Animals",
      "Brand",
      "Bikes",
      "Cars",
      "City",
      "Couple",
      "Designer",
      "Flowers",
      "Nature",
      "Street",
    ];
    List<CategoryModel> categoryModelList = [];
    for (String catName in categoryName) {
      final _random = Random();
      List<PhotosModel> photos = await getSearchWallpaper(catName);
      PhotosModel photoModel = photos[_random.nextInt(photos.length)];
      categoryModelList
          .add(CategoryModel(catImgUrl: photoModel.imgSrc, catName: catName));
    }
    return categoryModelList;
  }
}
