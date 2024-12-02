import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:depokrasa_mobile/shared/left_drawer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:depokrasa_mobile/models/featured_news.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<FeaturedNews> featuredNewsList = [];
  final CarouselSliderController _carouselController =
      CarouselSliderController();

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
        featuredNewsList =
            data.map((item) => FeaturedNews.fromJson(item, baseUrl)).toList();
      });

    } else {
      throw Exception('Failed to load featured news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                itemBuilder: (context, index, realIndex) {
                  final news = featuredNewsList[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: news.grandImage.startsWith('images')
                          ? Image.asset(
                              news.grandImage,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              news.grandImage,
                              fit: BoxFit.cover,
                            ),
                    ),
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
                  child: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _carouselController.nextPage(),
                  child: const Icon(Icons.arrow_forward),
                ),
              ],
            )
          ],
        ),
      ),
      drawer: const LeftDrawer(),
    );
  }
}
