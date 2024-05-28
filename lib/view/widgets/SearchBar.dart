import 'package:flutter/material.dart';
import 'package:wallpaper/view/screens/SearchScreen.dart';

class SearchBar extends StatefulWidget {
  SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();

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
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _search(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
            const Icon(Icons.search)
          ],
        ),
      ),
    );
  }
}
