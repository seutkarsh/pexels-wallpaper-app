import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Color.fromARGB(26, 0, 0, 0),
          border: Border.all(
            color: Colors.black38,
          ),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
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
          IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded))
        ],
      ),
    );
  }
}
