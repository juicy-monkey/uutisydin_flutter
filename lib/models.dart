class NewsItem {
    final String publisherId;
    final String publisher;
    final String publisherUrl;
    final String title;
    final String content;
    final String date;
    final String categories;
    final String link;

    NewsItem({
      required this.publisherId,
      required this.publisher,
      required this.publisherUrl,
      required this.title,
      required this.content,
      required this.date,
      required this.categories,
      required this.link,
    });

    @override
    String toString() {
      return 'NewsItem(publisher: $publisher, title: $title, link: $link, date: $date)';
  }
}

class NewsFeed {
    final String mainTitle;
    final List<String> mainCategories;
    final String imageUrl;
    final List<NewsItem> relatedNews;

    NewsFeed({
      required this.mainTitle,
      required this.mainCategories,
      required this.imageUrl,
      required this.relatedNews,
    });
}
