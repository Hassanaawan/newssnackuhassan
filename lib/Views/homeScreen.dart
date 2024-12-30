import 'package:flutter/material.dart';
import 'package:news_application/Controllers/fetchNews.dart';
import 'package:news_application/Models/newsArt.dart';
import 'package:news_application/Views/widgets/newsContainer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  late NewsArt newsArt;

  GetNews() async {
    // Fetch news data asynchronously
    newsArt = await FetchNews.fetchNews();

    setState(() {
      isLoading = false; // Data is loaded
    });
  }

  @override
  void initState() {
    GetNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: PageController(initialPage: 0),
        scrollDirection: Axis.vertical,
        onPageChanged: (value) {
          // Set loading state and fetch new news data on page change
          setState(() {
            isLoading = true;
          });
          GetNews();
        },
        itemBuilder: (context, index) {
          // Use NewsContainer with shimmer effect
          return NewsContainer(
            imgUrl: isLoading ? "" : newsArt.imgUrl,
            newsCnt: isLoading ? "" : newsArt.newsCnt,
            newsHead: isLoading ? "" : newsArt.newsHead,
            newsDes: isLoading ? "" : newsArt.newsDes,
            newsUrl: isLoading ? "" : newsArt.newsUrl,
            isLoading: isLoading, // Pass loading state to NewsContainer
          );
        },
      ),
    );
  }
}
