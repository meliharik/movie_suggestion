import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_suggestion/auth/login.dart';
import 'package:movie_suggestion/screens/search/movie_search.dart';
import 'package:movie_suggestion/screens/search/person_search.dart';
import 'package:movie_suggestion/screens/search/tv_serie_search.dart';
import 'package:movie_suggestion/screens/tabbar_main_tv_serie.dart';
import 'package:movie_suggestion/screens/tabs/popular_screen_movie.dart';
import 'package:movie_suggestion/screens/tabs/top_rated_screen_movie.dart';
import 'package:movie_suggestion/service/auth_service.dart';

class TabBarMainMovie extends ConsumerStatefulWidget {
  const TabBarMainMovie({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<TabBarMainMovie> {
  bool isSearching = false;
  final textFieldController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const tab = TabBar(
      tabs: <Tab>[
        Tab(
          text: 'Popular',
        ),
        Tab(
          text: 'Top Rated',
        ),
        Tab(
          text: 'My List',
        ),
      ],
    );
    const tab2 = TabBar(
      tabs: <Tab>[
        Tab(
          text: 'Movies',
        ),
        Tab(
          text: 'Tv Series',
        ),
        Tab(
          text: 'People',
        ),
      ],
    );
    if (isSearching) {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(FontAwesomeIcons.angleLeft),
              onPressed: () {
                setState(() {
                  isSearching = false;
                });
              },
            ),
            bottom: tab2,
            title: TextField(
              controller: textFieldController,
              autofocus: true,
              onSubmitted: (value) {
                setState(() {
                  searchQuery = value;
                });
                //TODO: search
                debugPrint(value);
              },
              decoration: InputDecoration(
                focusColor: Theme.of(context).appBarTheme.backgroundColor,
                fillColor: Theme.of(context).appBarTheme.backgroundColor,
                hintText: 'Search',
                border: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      textFieldController.text = '';
                    });
                  },
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              searchQuery != ''
                  ? MovieSearchScreen(query: textFieldController.text)
                  : const SizedBox(),
              searchQuery != ''
                  ? TvSerieSearchScreen(query: textFieldController.text)
                  : const SizedBox(),
              searchQuery != ''
                  ? PersonSearchScreen(query: textFieldController.text)
                  : const SizedBox(),
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                child: Text(
                  'CineCasti',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.house,
                ),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.tv,
                  color: Colors.blue,
                ),
                title: const Text('TV Shows'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TabBarMainTvSerie(),
                    ),
                  );
                },
              ),
              _cikisYap()
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('Movies'),
          bottom: tab,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                });
              },
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            PopularScreenMovie(),
            TopRatedScreenMovie(),
            Icon(Icons.directions_car, size: 350),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(
            FontAwesomeIcons.shuffle,
          ),
        ),
      ),
    );
  }

  Widget _cikisYap() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Hoop Hemşerim Nereye?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              'Çıkış yapıyorsun. Devam etmek istediğine emin misin?',
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Vazgeç gönül',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              TextButton(
                onPressed: _cikisYapFonk,
                child: Text(
                  'Çık',
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: ListTile(
        minVerticalPadding: 0,
        horizontalTitleGap: 0,
        leading: Icon(
          FontAwesomeIcons.signOutAlt,
          color: Theme.of(context).primaryColor,
        ),
        title: Text('Çıkış Yap',
            style: TextStyle(
              fontWeight: FontWeight.w400,
            )),
        trailing: Icon(
          FontAwesomeIcons.angleRight,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  void _cikisYapFonk() async {
    try {
      await AuthService().cikisYap();
      //TODO: notifications
      //await NotificationService().cancelAllNotifications();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } catch (hata) {
      debugPrint("hata");
      debugPrint(hata.hashCode.toString());
      debugPrint(hata.toString());
      var snackBar = SnackBar(content: Text('Bir hata oluştu: $hata'));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}
