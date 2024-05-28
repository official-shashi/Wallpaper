// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:wallpaper/view/widgets/CategoryBlock.dart';
import 'package:wallpaper/view/widgets/CustomAppBar.dart';
import 'package:wallpaper/view/widgets/SearchBar.dart';

import '../../controller/ApiProvider.dart';
import '../../model/photos_modal.dart';
import 'full_screen.dart';

class SearchScreen extends StatefulWidget {
  String query;
  SearchScreen({
    Key? key,
    required this.query,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<PhotosModel> searchResult = [];
  late TextEditingController _searchController;

  // ignore: non_constant_identifier_names
  GetTrendingWallpaper() async {
    searchResult = await ApiProvider.getSearchWallpaper(widget.query);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    GetTrendingWallpaper();
    _searchController = TextEditingController(text: widget.query);
  }

  void _search(BuildContext context) async {
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(query: query),
        ),
      );
      _searchController.text = query;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          InkWell(
            onTap: () {
              _search(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(66, 192, 192, 192),
                border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (value) {
                        _search(context);
                      },
                      decoration: const InputDecoration(
                        hintText: "Search Wallpaper",
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // const Icon(Icons.search)
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 630,
            child: GridView.builder(
                itemCount: searchResult.length,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 350,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (context, index) => InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FullScreen(imgUrl: searchResult[index].imgSrc),
                          )),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                              fit: BoxFit.cover, searchResult[index].imgSrc),
                        ),
                      ),
                    )),
          )
        ]),
      ),
    );
  }
}
