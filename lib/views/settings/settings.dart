import 'package:bookzone/pages/formal/stamp_collection_page_formal.dart';
import 'package:flutter/material.dart';
import 'package:bookzone/theme/theme_config.dart';
import 'package:bookzone/util/router.dart';
import 'package:bookzone/view_models/app_provider.dart';
import 'package:bookzone/views/downloads/downloads.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List items;

  @override
  void initState() {
    super.initState();
    items = [
      {
        'icon': Feather.heart,
        'title': 'Favorites',
        'function': () => _pushPage(StampCollectionFormalPage()),
      },
      {
        'icon': Feather.download,
        'title': 'Downloads',
        'function': () => _pushPage(Downloads()),
      },
      {
        'icon': Feather.moon,
        'title': 'Dark Mode',
        'function': () => _pushPage(Downloads()),
      },
      {
        'icon': Feather.info,
        'title': 'About',
        'function': () => showAbout(),
      },
      {
        'icon': Icons.privacy_tip,
        'title': 'Privacy Policy',
        'function': () => showPrivacyPolicy(),
      },
      {
        'icon': Feather.file_text,
        'title': 'Licenses',
        'function': () => _pushPageDialog(LicensePage()),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Remove Dark Switch if Device has Dark mode enabled
    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
      items.removeWhere((item) => item['title'] == 'Dark Mode');
    }
    const textStyle = const TextStyle(
        fontSize: 25.0, fontFamily: 'Butler', fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Settings',
          style: textStyle,
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 10),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          if (items[index]['title'] == 'Dark Mode') {
            return buildThemeSwitch(items[index]);
          }

          return ListTile(
            onTap: items[index]['function'],
            leading: Icon(
              items[index]['icon'],
            ),
            title: Text(
              items[index]['title'],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }

  Widget buildThemeSwitch(Map item) {
    return SwitchListTile(
      secondary: Icon(
        item['icon'],
      ),
      title: Text(
        item['title'],
      ),
      value: Provider.of<AppProvider>(context).theme == ThemeConfig.lightTheme
          ? false
          : true,
      onChanged: (v) {
        if (v) {
          Provider.of<AppProvider>(context, listen: false)
              .setTheme(ThemeConfig.darkTheme, 'dark');
        } else {
          Provider.of<AppProvider>(context, listen: false)
              .setTheme(ThemeConfig.lightTheme, 'light');
        }
      },
    );
  }

  _pushPage(Widget page) {
    MyRouter.pushPage(context, page);
  }

  _pushPageDialog(Widget page) {
    MyRouter.pushPageDialog(context, page);
  }

  showAbout() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'About',
          ),
          content: Text(
              'BookZone provides a very powerful file indexing and search service allowing you to find a book among millions of books located on web servers. Our database is updated daily by our robots that crawl through free access internet resources.\nBookZone hosts no content, we provide only access to already available books in a same way Google and other search engines do.\nThe main goal of BookZone is to provide users with a user-friendly interface making searches easier with lightning speed. We do our best to establish a new standard for sites and lead the whole community of netizens into a new era.'),
          actions: <Widget>[
            TextButton(
              style:
                  TextButton.styleFrom(primary: Theme.of(context).accentColor),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
              ),
            ),
          ],
        );
      },
    );
  }

  showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Privacy Policy',
          ),
          content: Text(
              'BookZone Android App is committed to user privacy and/or our policy below and describes our principles in maintaining user trust and confidence and protecting your private data.\nWe adhere to valid legal processes and may provide information if required by law to protect the rights of our company, and in certain instances, to protect the personal safety of our users and the public on the whole.\nThe third party applications using our APIs are reponsible for their own privacy terms and FilePursuit must not be held reponsible for their actions.\n\nPrivacy Policy Changes\nWe have all rights to change, alter or modify our privacy policy at any time without prior notice. We will immediately post changes on this page and let you get acquainted with them.'),
          actions: <Widget>[
            TextButton(
              style:
                  TextButton.styleFrom(primary: Theme.of(context).accentColor),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
              ),
            ),
          ],
        );
      },
    );
  }
}
