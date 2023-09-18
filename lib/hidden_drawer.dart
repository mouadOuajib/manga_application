import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:mangago/screens/Tags_screen.dart';
import 'package:mangago/screens/home_screen.dart';
import 'package:mangago/screens/hot_mangas.dart';
import 'package:mangago/screens/search_screen.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];
  final textStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey);
  final selectedTextStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black);
  @override
  void initState() {
    _pages = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: "Home",
              baseStyle: textStyle,
              selectedStyle: selectedTextStyle),
          const HomeScreen()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: "search",
              baseStyle: textStyle,
              selectedStyle: selectedTextStyle),
          const SearchScreen()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: "Favorite",
              baseStyle: textStyle,
              selectedStyle: selectedTextStyle),
          FavoriteMangaPage()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: "Tags",
              baseStyle: textStyle,
              selectedStyle: selectedTextStyle),
          const TagsScreen()),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context).colorScheme;
    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.white,
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 30,
      elevationAppBar: 0,
    );
  }
}
