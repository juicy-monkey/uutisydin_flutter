import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:uutisydin_flutter/components/footer.dart';
import 'package:uutisydin_flutter/components/news_card.dart';
import 'package:uutisydin_flutter/models.dart';
import 'package:uutisydin_flutter/pages/info.dart';
import 'package:uutisydin_flutter/utils/colors.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.seed,
          dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
        ),
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

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
  String? _errorMessage;

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
    setState(() {
      _errorMessage = null;
    });

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
        debugPrint('Error fetching news, status code: ${response.statusCode}');
        setState(() {
          _errorMessage = 'Uutisten lataaminen epäonnistui.';
        });
        Fluttertoast.showToast(
          msg: 'Response status code ${response.statusCode}',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          gravity: ToastGravity.BOTTOM,
          webShowClose: true,
          webPosition: 'center',
        );
      }
    } catch (e) {
      debugPrint('Error fetching news: $e');
      setState(() {
        _errorMessage = 'Uutisten lataaminen epäonnistui.';
      });
      Fluttertoast.showToast(
        msg: '$e',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
        gravity: ToastGravity.BOTTOM,
        webShowClose: true,
        webPosition: 'center',
      );
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        shadowColor: AppColors.lightShadow,
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
                : Tooltip(
                  message: 'Tietoa',
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Info()),
                      );
                    },
                    child: Image.asset(
                      'assets/uutisydin/uutisydin_text.png',
                      height: 30,
                    ),
                  ),
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
                  PopupMenuItem<String>(
                    value: 'newest',
                    child: Row(
                      children: [
                        if (_sortingMethod == 'newest')
                          Icon(Icons.check, size: 18)
                        else
                          SizedBox(width: 18),
                        SizedBox(width: 8),
                        Text('Uusimmat'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'most_articles',
                    child: Row(
                      children: [
                        if (_sortingMethod == 'most_articles')
                          Icon(Icons.check, size: 18)
                        else
                          SizedBox(width: 18),
                        SizedBox(width: 8),
                        Text('Eniten julkaisuja'),
                      ],
                    ),
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
                backgroundColor: Theme.of(context).colorScheme.surface,
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                },
                child: const Icon(Icons.arrow_upward),
              )
              : null,

      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: fetchFeed,
        color: AppColors.logoBlue,
        child:
            feeds.isEmpty
                ? Center(
                  child:
                      _errorMessage != null
                          ? Column(
                            children: [
                              SizedBox(height: 30),
                              Text(_errorMessage!),
                              TextButton(
                                onPressed: fetchFeed,
                                child: Text(
                                  'Yritä uudelleen',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          )
                          : const Center(),
                )
                : ListView(
                  controller: _scrollController,
                  children: [
                    ...feeds.map(
                      (feed) => Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12.0,
                          bottom: 8.0,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 500),
                            child: NewsCard(feed: feed),
                          ),
                        ),
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
                            'Nyt olet kärryillä viimeisen 48 tunnin ajalta!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 100),
                        ],
                      ),

                    if (!_isSearching) Footer(showInfoButton: true),
                  ],
                ),
      ),
    );
  }
}
