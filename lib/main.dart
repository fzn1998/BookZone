import 'package:bookzone/views/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:bookzone/pages/formal/search_book_page_formal.dart';
import 'package:bookzone/util/consts.dart';
import 'package:bookzone/theme/theme_config.dart';
import 'package:bookzone/view_models/app_provider.dart';

import 'package:bookzone/views/splash/splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pages/formal/stamp_collection_page_formal.dart';
import 'pages/universal/collection_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, Widget child) {
        return MaterialApp(
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: Constants.appName,
          theme: themeData(appProvider.theme),
          darkTheme: themeData(ThemeConfig.darkTheme),
          home: Splash(),
          routes: {
            '/search_formal': (BuildContext context) => new SearchBookPageNew(),
            '/collection': (BuildContext context) => new CollectionPage(),
            '/stamp_collection_formal': (BuildContext context) =>
                new StampCollectionFormalPage(),
            '/settings': (BuildContext context) => new Profile(),
          },
        );
      },
    );
  }

  // Apply font to our app's theme
  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSansProTextTheme(
        theme.textTheme,
      ),
    );
  }
}
