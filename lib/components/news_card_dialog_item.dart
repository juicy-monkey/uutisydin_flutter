import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uutisydin_flutter/models.dart';
import 'package:uutisydin_flutter/utils/colors.dart';

class NewsCardDialogItem extends StatelessWidget {
  final NewsItem news;
  final String timeString;
  const NewsCardDialogItem({
    super.key,
    required this.news,
    required this.timeString,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse(news.link));
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 1.0,
        shadowColor: AppColors.shadow,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
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
                        'assets/logos/${news.publisherId}.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    news.publisher,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 131, 131, 131),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6.0),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      news.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),

              if (news.content.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(news.content, style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 10.0),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    timeString,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  InkWell(
                    onTap: () {
                      launchUrl(Uri.parse(news.link));
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.link, size: 16, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          news.publisherUrl,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
