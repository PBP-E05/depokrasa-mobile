import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:depokrasa_mobile/shared/left_drawer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:depokrasa_mobile/models/featured_news.dart';
import 'package:depokrasa_mobile/models/user.dart';
import 'package:depokrasa_mobile/featured_news/screens/addnews.dart';
import 'package:depokrasa_mobile/featured_news/screens/editnews.dart';

class MyHomePage extends StatefulWidget {
  final User user;

  const MyHomePage({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<FeaturedNews> featuredNewsList = [];
  final CarouselSliderController _carouselController = CarouselSliderController();
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    fetchFeaturedNews();
  }

  Future<void> fetchFeaturedNews() async {
    String baseUrl = dotenv.env['BASE_URL'] ?? "http://127.0.0.1:8000";
    String apiUrl = "$baseUrl/news-json/";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        featuredNewsList = data.map((item) {
          return FeaturedNews.fromJson(item ?? {}, baseUrl);
        }).toList();
      });
    } else {
      throw Exception('Failed to load featured news');
    }
  }

  Future<void> deleteNews(String newsId) async {
    String baseUrl = dotenv.env['BASE_URL'] ?? "http://127.0.0.1:8000";
    String apiUrl = "$baseUrl/delete-news/$newsId/";
    final response = await http.delete(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        featuredNewsList.removeWhere((news) => news.id == newsId);
      });
      // fetchFeaturedNews();
    } else {
      throw Exception('Failed to delete news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.yellow.shade700,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.user.isAdmin)
                  TextButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewsPage(
                            user: widget.user,
                            onNewsSubmitted: fetchFeaturedNews, // Pass the callback
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: const Size(100, 50),
                      backgroundColor: Colors.yellow.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Add News'),
                  ),
                const SizedBox(height: 20),
                if (featuredNewsList.isNotEmpty)
                  CarouselSlider.builder(
                    carouselController: _carouselController,
                    itemCount: featuredNewsList.length,
                    options: CarouselOptions(
                      height: 400.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: false,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                    itemBuilder: (context, index, realIndex) {
                      final news = featuredNewsList[index];
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.black, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'images/image1.jpg',
                                    fit: BoxFit.cover,
                                    height: 200,
                                    width: double.infinity,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          news.title,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.yellow.shade700,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          news.content,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Published on: ${news.timeAdded}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (widget.user.isAdmin)
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.white),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditNewsPage(
                                            user: widget.user,
                                            news: news,
                                            onNewsUpdated: fetchFeaturedNews,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.white),
                                    onPressed: () async {
                                      await deleteNews(news.id);
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  )
                else
                  const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _carouselController.previousPage(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade700,
                      ),
                      child: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () => _carouselController.nextPage(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade700,
                      ),
                      child: const Icon(Icons.arrow_forward),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      drawer: const LeftDrawer(),
    );
  }
}
