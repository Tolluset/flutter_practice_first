import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HomePageState(),
        child: MaterialApp(
          title: 'Namer App tutorial',
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime)),
          home: const MainPage(),
        ));
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (selectedIndex) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const FavoritePage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(children: [
          SafeArea(
            child: NavigationRail(
              extended: constraints.maxWidth >= 600,
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(
                    icon: Icon(Icons.favorite), label: Text('Favorites')),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ]),
      );
    });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<HomePageState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      BigCard(pair: pair),
      const SizedBox(height: 16),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
              onPressed: () {
                appState.toggleFavorite();
              },
              icon: Icon(icon),
              label: const Text('Favorite')),
          const SizedBox(width: 24),
          ElevatedButton(
              onPressed: () {
                appState.getNext();
              },
              child: const Text('Next')),
        ],
      )
    ])));
  }
}

class HomePageState extends ChangeNotifier {
  var current = WordPair.random();

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }

    notifyListeners();
  }

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<HomePageState>();
    var favorites = appState.favorites;

    if (favorites.isEmpty) {
      return const Center(child: Text('No favorites yet'));
    }

    return ListView(children: [
      Padding(
          padding: const EdgeInsets.all(20),
          child: Text('${favorites.length} favorites')),
      ...favorites
          .map((f) => ListTile(
              leading: const Icon(Icons.favorite), title: Text(f.asLowerCase)))
          .toList(),
    ]);
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary);

    return Card(
        color: theme.colorScheme.primary,
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              pair.asLowerCase,
              style: style,
              semanticsLabel: "${pair.first} ${pair.second}",
            )));
  }
}
