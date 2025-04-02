import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uutisydin_flutter/components/news_card.dart';
import 'package:uutisydin_flutter/models.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uutisydin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF607D8B)),
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});
  final String title = 'Uutisydin';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopButton = false;
  String _sortingMethod = 'newest'; // 'newest' or 'most_articles'

  List<NewsFeed> allFeeds = [];
  List<NewsFeed> feeds = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
    });

    _scrollController.addListener(() {
      if (_scrollController.offset >= 300 && !_showScrollToTopButton) {
        setState(() => _showScrollToTopButton = true);
      } else if (_scrollController.offset < 300 && _showScrollToTopButton) {
        setState(() => _showScrollToTopButton = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchFeed() async {
    const url = 'https://juicy-monkey.github.io/uutisydin_node/data.json';
    // const url = 'http://localhost:8080/api/feeds';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        debugPrint('STATUS: 200');
        final jsonData = jsonDecode(response.body);
        final timestamp = jsonData['timestamp'] as String;
        debugPrint('TIMESTAMP: $timestamp');

        final feedsJson = jsonData['feeds'] as List;
        final parsedFeeds =
            feedsJson.map((feed) {
              final relatedNewsJson = feed['relatedNews'] as List;

              final relatedNews =
                  relatedNewsJson.map((newsJson) {
                    return NewsItem(
                      publisherId: newsJson['publisherId'] ?? '',
                      publisher: newsJson['publisher'] ?? '',
                      publisherUrl: newsJson['publisherUrl'] ?? '',
                      title: newsJson['title'] ?? '',
                      content: newsJson['content'] ?? '',
                      date: newsJson['date'] ?? '',
                      categories: (newsJson['categories'] as List).join(', '),
                      link: newsJson['link'] ?? '',
                    );
                  }).toList();

              final mainCategories =
                  (feed['mainCategories'] as List?)
                      ?.map((c) => c.toString())
                      .toList() ??
                  [];

              return NewsFeed(
                mainTitle: feed['mainTitle'] ?? '',
                imageUrl: feed['imageUrl'] ?? '',
                mainCategories: mainCategories,
                relatedNews: relatedNews,
              );
            }).toList();

        setState(() {
          allFeeds = parsedFeeds;
          feeds = parsedFeeds;
        });
        sortFeeds();
      } else {
        throw Exception('Failed to load news feed, status code ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching news: $e');
    }
  }

  void filterFeeds(String query) {
    final lowerQuery = query.toLowerCase();

    setState(() {
      feeds =
          allFeeds.where((feed) {
            // Match main title
            if (feed.mainTitle.toLowerCase().contains(lowerQuery)) return true;

            // Match any related news item fields
            return feed.relatedNews.any(
              (news) =>
                  news.title.toLowerCase().contains(lowerQuery) ||
                  news.content.toLowerCase().contains(lowerQuery) ||
                  news.publisher.toLowerCase().contains(lowerQuery) ||
                  news.categories.toLowerCase().contains(lowerQuery),
            );
          }).toList();
    });
  }

  void sortFeeds() {
    setState(() {
      if (_sortingMethod == 'newest') {
        feeds.sort(
          (a, b) =>
              b.relatedNews.first.date.compareTo(a.relatedNews.first.date),
        );
      } else if (_sortingMethod == 'most_articles') {
        feeds.sort(
          (a, b) => b.relatedNews.length.compareTo(a.relatedNews.length),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 3.0,
        shadowColor: Theme.of(context).colorScheme.onSecondary,
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Hae...',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    filterFeeds(value);
                  },
                )
                : Image.asset(
                  'assets/uutisydin/uutisydin_text.png',
                  height: 25,
                ),
        actions: [
          if (!_isSearching)
          PopupMenuButton<String>(
            icon: Icon(Icons.sort),
            tooltip: 'Järjestä',
            onSelected: (String value) {
              setState(() {
                _sortingMethod = value;
                sortFeeds();
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(value: 'newest', child: Text('Uusimmat')),
                PopupMenuItem<String>(
                  value: 'most_articles',
                  child: Text('Eniten julkaisuja'),
                ),
              ];
            },
          ),

          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            tooltip: 'Hae',
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  feeds = allFeeds;
                }
              });
            },
          ),

          const SizedBox(width: 4.0),
        ],
      ),
      floatingActionButton:
          _showScrollToTopButton
              ? FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                },
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              )
              : null,

      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: fetchFeed,
        child:
            feeds.isEmpty
                ? const Center()
                : ListView(
                  controller: _scrollController,
                  children: [
                    ...feeds.map(
                      (feed) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                        child: NewsCard(feed: feed),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (!_isSearching)
                      Column(
                        children: const [
                          SizedBox(height: 20),
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 40,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Nyt olet kärryillä viimeisen 48 tunnin ajalta!",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 100),
                        ],
                      ),
                  ],
                ),
      ),
    );
  }
}
