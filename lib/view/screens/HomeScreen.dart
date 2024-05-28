import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/controller/ApiProvider.dart';
import 'package:wallpaper/model/photos_modal.dart';
import 'package:wallpaper/view/screens/full_screen.dart';
import 'package:wallpaper/view/widgets/CategoryBlock.dart';
import 'package:wallpaper/view/widgets/CustomAppBar.dart';
import 'package:wallpaper/view/widgets/SearchBar.dart';

import '../../model/category_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<PhotosModel> trendingList = [];

  late List<CategoryModel> catModList = [];
  bool isLoading = true;

  // ignore: non_constant_identifier_names
  GetCatDetails() async {
    catModList = await ApiProvider.getCategoriesList();
    setState(() {
      isLoading = false;
    });
  }

  // ignore: non_constant_identifier_names
  GetTrendingWallpaper() async {
    trendingList = await ApiProvider.getTrendingWallpaper();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    GetTrendingWallpaper();
    GetCatDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const CustomAppBar(),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SearchBar()),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: catModList.length,
                          itemBuilder: (context, index) => CategoryBlock(
                            categoryImgSrc: catModList[index].catImgUrl,
                            categoryName: catModList[index].catName,
                          ),
                        ),
                      ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 550,
                  child: GridView.builder(
                      itemCount: trendingList.length,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 350,
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                      itemBuilder: (context, index) => GridTile(
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreen(
                                        imgUrl: trendingList[index].imgSrc),
                                  )),
                              child: Hero(
                                tag: trendingList[index].imgSrc,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                        fit: BoxFit.cover,
                                        trendingList[index].imgSrc),
                                  ),
                                ),
                              ),
                            ),
                          )),
                ),
              ]),
            ),
    );
  }
}
