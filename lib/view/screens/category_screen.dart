import 'package:flutter/material.dart';
import 'package:wallpaper/controller/ApiProvider.dart';

import 'package:wallpaper/view/widgets/CustomAppBar.dart';

import '../../model/photos_modal.dart';
import 'full_screen.dart';

// ignore: must_be_immutable
class CategoryScreen extends StatefulWidget {
  String catName;
  String catImgUrl;
  CategoryScreen({
    Key? key,
    required this.catName,
    required this.catImgUrl,
  }) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late List<PhotosModel> categoryResults = [];
  bool isLoading = true;
  // ignore: non_constant_identifier_names
  GetCatRelWall() async {
    categoryResults = await ApiProvider.getSearchWallpaper(widget.catName);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    GetCatRelWall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const CustomAppBar(),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(
            children: [
              Image.network(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  widget.catImgUrl),
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                color: Colors.black38,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Center(
                  child: Text(widget.catName,
                      style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 580,
            child: GridView.builder(
                itemCount: categoryResults.length,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  imgUrl: categoryResults[index].imgSrc),
                            )),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                                fit: BoxFit.cover,
                                categoryResults[index].imgSrc),
                          ),
                        ),
                      ),
                    )),
          )
        ]),
      ),
    );
  }
}
