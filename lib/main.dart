import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:mangago/hidden_drawer.dart';
import 'package:mangago/provider/current_reading_provider.dart';
import 'package:mangago/provider/favorite_provider.dart';
import 'package:mangago/provider/finished_manga_provider.dart';
import 'package:mangago/provider/watch_later.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WatchLaterProvider>(
          create: (context) => WatchLaterProvider(),
        ),
        ChangeNotifierProvider<FavoriteProvider>(
          create: (context) => FavoriteProvider(),
        ),
        ChangeNotifierProvider<FinishedProvider>(
          create: (context) => FinishedProvider(),
        ),
        ChangeNotifierProvider<CurrentReadingProvider>(
          create: (context) => CurrentReadingProvider(),
        ),
      ],
      child: const MangaGo(),
    ),
  );
}

class MangaGo extends StatelessWidget {
  const MangaGo({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 780),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'mangago',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              colorScheme: const ColorScheme(
                brightness: Brightness.light,
                primary: Color(0xfffff0e0),
                onPrimary: Colors.black,
                secondary: Color(0xffca8dfd),
                onSecondary: Colors.white,
                error: Colors.redAccent,
                onError: Colors.white,
                background: Color(0xfff0ceff),
                onBackground: Colors.white,
                surface: Colors.grey,
                onSurface: Colors.white,
                shadow: Colors.blue,
              ),
            ),
            home: child,
          );
        },
        child: const HiddenDrawer());
  }
}
