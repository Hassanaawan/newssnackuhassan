import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:news_application/Models/newsArt.dart';

class FetchNews {
  static const String _apiKey = "6385658a140e41468047f1eedfacc315";
  static const String _baseUrl = "https://newsapi.org/v2/top-headlines";
  
  static final List<String> _sourcesId = [
    "abc-news",
    "bbc-news",
    "bbc-sport",
    "business-insider",
    "engadget",
    "entertainment-weekly",
    "espn",
    "espn-cric-info",
    "financial-post",
    "fox-news",
    "fox-sports",
    "globo",
    "google-news",
    "google-news-in",
    "medical-news-today",
    "national-geographic",
    "news24",
    "new-scientist",
    "new-york-magazine",
    "next-big-future",
    "techcrunch",
    "techradar",
    "the-hindu",
    "the-wall-street-journal",
    "the-washington-times",
    "time",
    "usa-today",
  ];

  static Future<NewsArt> fetchNews() async {
    final random = Random();

    // Pick a random news source
    String sourceId = _sourcesId[random.nextInt(_sourcesId.length)];

    // Build the API URL
    Uri apiUrl = Uri.parse("$_baseUrl?sources=$sourceId&apiKey=$_apiKey");

    try {
      // Fetch data from the API
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        Map<String, dynamic> bodyData = jsonDecode(response.body);

        // Get the list of articles
        List<dynamic> articles = bodyData["articles"] ?? [];

        // Check if articles exist
        if (articles.isNotEmpty) {
          // Pick a random article
          Map<String, dynamic> randomArticle = articles[random.nextInt(articles.length)];
          return NewsArt.fromAPItoApp(randomArticle);
        } else {
          throw Exception("No articles found");
        }
      } else {
        throw Exception("Failed to fetch news. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("An error occurred while fetching news: $e");
    }
  }
}
