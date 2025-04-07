import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uutisydin_flutter/components/news_card_dialog_item.dart';
import 'package:uutisydin_flutter/models.dart';
import 'package:uutisydin_flutter/utils/colors.dart';

class NewsCard extends StatelessWidget {
  final NewsFeed feed;
  const NewsCard({super.key, required this.feed});

  String formatDate(String isoDate) {
    final dateTime = DateTime.parse(isoDate).toLocal();
    final now = DateTime.now();

    final sameDay =
        now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;

    final timeFormat = DateFormat('HH:mm');
    final fullFormat = DateFormat('dd.MM. HH:mm');

    return sameDay ? timeFormat.format(dateTime) : fullFormat.format(dateTime);
  }

  List<Widget> _buildPublisherLogos(List<NewsItem> newsItems) {
    final uniquePublishers = <String>{};
    final publishers = <String>[];

    // Collect unique publishers in order
    for (var item in newsItems) {
      if (uniquePublishers.add(item.publisherId)) {
        publishers.add(item.publisherId);
      }
    }

    final widgets = <Widget>[];
    final count = publishers.length;

    for (int i = count - 1; i >= 0; i--) {
      widgets.add(
        Positioned(
          left: 12.0 * i,
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 1,
                  offset: Offset(0.1, 1),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/logos/${publishers[i]}.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  double _calculatePublisherLogoWidth(List<NewsItem> newsItems) {
    final uniquePublishers = <String>{};
    for (var item in newsItems) {
      uniquePublishers.add(item.publisher);
    }

    final count = uniquePublishers.length;
    if (count == 0) return 0;
    return 12 * (count - 1) + 16; // base width + offset
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = formatDate(feed.relatedNews[0].date);

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (context) => Dialog(
                insetPadding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                    maxWidth: 600
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 24,
                          right: 8,
                          bottom: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                feed.mainTitle,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            bottom: 12,
                          ),
                          child: SingleChildScrollView(
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: feed.relatedNews.length,
                              itemBuilder: (context, i) {
                                final news = feed.relatedNews[i];
                                final timeString = formatDate(news.date);
                                return NewsCardDialogItem(
                                  news: news,
                                  timeString: timeString,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 3.0,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (feed.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12.0),
                ),
                child: Image.network(
                  'https://juicy-monkey.github.io/uutisydin_node${feed.imageUrl}',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (feed.mainCategories.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        feed.mainCategories.join(' • '),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  Text(
                    feed.mainTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: _calculatePublisherLogoWidth(feed.relatedNews),
                        height: 20,
                        child: Stack(
                          children: _buildPublisherLogos(feed.relatedNews),
                        ),
                      ),
                      Text(
                        '${feed.relatedNews.length} julkaisua',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
