import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:news_application/Views/detailView.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsContainer extends StatelessWidget {
  final String imgUrl;
  final String newsHead;
  final String newsDes;
  final String newsCnt;
  final String newsUrl;
  final bool isLoading;

  NewsContainer({
    super.key,
    required this.imgUrl,
    required this.newsDes,
    required this.newsCnt,
    required this.newsHead,
    required this.newsUrl,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    if (isLoading) {
      // Show shimmer loading animation
      return Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: screenHeight * 0.4,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.03),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 20,
                      width: screenWidth * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 15,
                      width: screenWidth * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Show content when data is loaded
    return SingleChildScrollView(
      child: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: FadeInImage.assetNetwork(
                height: screenHeight * 0.4,
                width: screenWidth,
                fit: BoxFit.cover,
                placeholder: "assets/download.png",
                image: imgUrl,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.03),
                  // News Headline
                  Text(
                    newsHead.length > 90
                        ? "${newsHead.substring(0, 90)}..."
                        : newsHead,
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // News Description
                  Text(
                    newsDes,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[600],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // News Content
                  Text(
                    newsCnt != "--"
                        ? newsCnt.length > 250
                            ? "${newsCnt.substring(0, 250)}..."
                            : newsCnt
                        : newsCnt,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black87,
                    ),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 7, 150, 233),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailViewScreen(newsUrl: newsUrl),
                        ),
                      );
                    },
                    child: Text(
                      "Read More",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
