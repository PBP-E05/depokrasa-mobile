import 'package:depokrasa_mobile/models/restaurant_entry.dart';
import 'package:depokrasa_mobile/screen/addmenuform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:depokrasa_mobile/models/featured_news.dart';
import 'package:depokrasa_mobile/models/user.dart' as depokrasa_user;
import 'package:depokrasa_mobile/featured_news/screens/editnews.dart';
import 'package:depokrasa_mobile/featured_news/screens/addnews.dart';
import 'package:depokrasa_mobile/models/wishlist_entry.dart';

class DepokRasaHomePage extends StatefulWidget {
  final depokrasa_user.User user;

  const DepokRasaHomePage({super.key, required this.user});

  @override
  State<DepokRasaHomePage> createState() => _DepokRasaHomePageState();
}

class _DepokRasaHomePageState extends State<DepokRasaHomePage> {
  String baseUrl = kDebugMode ? "http://127.0.0.1:8000": "http://muhammad-wendy-depokrasa.pbp.cs.ui.ac.id";
  List<FeaturedNews> featuredNewsList = [];
  final CarouselSliderController _carouselController = CarouselSliderController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFeaturedNews();
  }
  
  Future fetchRestaurants(CookieRequest request) async {
    final response = await request.get(
        '$baseUrl/api/restaurants/');

    List<RestaurantEntry> restaurants = [];
    for(var resto in response){
      restaurants.add(RestaurantEntry.fromJson(resto));
    }
    return restaurants;
  }

  Future<void> fetchFeaturedNews() async {
    setState(() {
      isLoading = true;
    });

    String baseUrl = dotenv.env['BASE_URL'] ?? "http://127.0.0.1:8000";
    String apiUrl = "$baseUrl/news-json/";
    
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          featuredNewsList = data.map((item) {
            return FeaturedNews.fromJson(item ?? {});
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load featured news');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading news: $e')),
      );
    }
  }

  Future<void> deleteNews(String newsId) async {
    String baseUrl = dotenv.env['BASE_URL'] ?? "http://127.0.0.1:8000";
    String apiUrl = "$baseUrl/delete-news/$newsId/";
    
    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          featuredNewsList.removeWhere((news) => news.id == newsId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('News deleted successfully')),
        );
      } else {
        throw Exception('Failed to delete news');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting news: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25.0, bottom: 15),
                      child: Image.asset(
                        'images/depokrasa-logo.png',
                        width: 198,
                        height: 52,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search Bar
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.search),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Add News Button for Admin
                        if (widget.user.isAdmin)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                try {
                                  final result = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AddNewsPage(
                                        user: widget.user,
                                        onNewsSubmitted: fetchFeaturedNews,
                                      ),
                                    ),
                                  );
                                  if (result == true) {
                                    fetchFeaturedNews();
                                  }
                                } catch (e) {
                                  print('Error navigating to AddNewsPage: $e');
                                }
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add New Article'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.yellow.shade700,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // News Carousel
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.yellow,
                        ),
                      )
                    : featuredNewsList.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'No news articles available',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          )
                        : _buildNewsCarousel(),

                // Carousel Navigation Buttons
                if (featuredNewsList.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => _carouselController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow.shade700,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () => _carouselController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow.shade700,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                          child: const Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: fetchRestaurants(request),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Loading Pages"),
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                }
                
                if (!snapshot.hasData) {
                  return const Column(
                    children: [
                      Text(
                        'Restaurants not found!',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                }

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Restaurant List',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return _buildRestaurantCard(
                              snapshot.data[index]!.name.toString().replaceAll(" ", "-"),
                              snapshot.data[index]!.name,
                              baseUrl
                            );
                          }
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Depok Rasa Pick',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter'
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: FutureBuilder(
              future: fetchRestaurants(request),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SliverToBoxAdapter(child: SizedBox());
                }

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildFoodCard(
                        "${snapshot.data[index~/3].name.toString().replaceAll(" ", "-").toLowerCase()}-menu-${index%3 + 1}",
                        snapshot.data[index~/3].menu[index % 3].foodName.toString(),
                        snapshot.data[index~/3].menu[index % 3].price.toString(),
                        snapshot.data[index~/3].name.toString().replaceAll(" ", "-").toLowerCase(),
                        baseUrl,
                        widget.user,
                        context // Pass context parameter
                      );
                    },
                    childCount: snapshot.data.length * 3,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddMenuForm(user: widget.user), // Pass user parameter
            ),
          );
        },
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildNewsCarousel() {
    return CarouselSlider.builder(
      carouselController: _carouselController,
      itemCount: featuredNewsList.length,
      options: CarouselOptions(
        height: 500.0,
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
        return _buildNewsCard(news, context);
      },
    );
  }

  Widget _buildNewsCard(FeaturedNews news, BuildContext context) {
    // Split the title for custom styling
    final titleParts = news.title.split(' ');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
        color: Colors.yellow.shade50,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 450, // Fixed height for the entire card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              news.grandImage.isNotEmpty
                  ? Image.network(
                      news.grandImage,
                      fit: BoxFit.cover,
                      height: 250,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'images/image1.jpg',
                          fit: BoxFit.cover,
                          height: 250,
                          width: double.infinity,
                        );
                      },
                    )
                  : Image.asset(
                      'images/image1.jpg',
                      fit: BoxFit.cover,
                      height: 250,
                      width: double.infinity,
                    ),

              // Content Section
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Ensure the column takes minimum space
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title with custom styling
                        _buildCustomTitleText(titleParts),

                        const SizedBox(height: 10),

                        // Content Preview
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.description, color: Colors.orange.shade300),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                news.content,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Author and Time
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              news.author,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.calendar_today, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              news.timeAdded,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),

                        // Additional Info
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildInfoChip(
                              icon: Icons.timer,
                              label: '${news.cookingTime} min',
                              color: Colors.orange.shade100,
                            ),
                            const SizedBox(width: 10),
                            _buildInfoChip(
                              icon: Icons.local_fire_department,
                              label: '${news.calories} Cal',
                              color: Colors.red.shade100,
                            ),
                          ],
                        ),

                        // Edit and Delete Buttons for Admin
                        if (widget.user.isAdmin)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () async {
                                  try {
                                    final result = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => EditNewsPage(
                                          user: widget.user,
                                          news: news,
                                          onNewsUpdated: fetchFeaturedNews,
                                        ),
                                      ),
                                    );
                                    if (result == true) {
                                      fetchFeaturedNews();
                                    }
                                  } catch (e) {
                                    print('Error navigating to EditNewsPage: $e');
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(news.id);
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String newsId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete News'),
        content: const Text('Are you sure you want to delete this news article?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              deleteNews(newsId);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTitleText(List<String> titleParts) {
    return Row(
      children: [
        const Icon(Icons.circle, color: Colors.orange, size: 16),
        const SizedBox(width: 5),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: titleParts.first,
                style: const TextStyle(
                  fontFamily: 'Sans', // Change font to sans-serif
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (titleParts.length > 1) ...[
                const TextSpan(text: ' '),
                TextSpan(
                  text: titleParts[1],
                  style: const TextStyle(
                    fontFamily: 'Sans', // Change font to sans-serif
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
              if (titleParts.length > 2) ...[
                const TextSpan(text: ' '),
                TextSpan(
                  text: titleParts.sublist(2).join(' '),
                  style: const TextStyle(
                    fontFamily: 'Sans', // Change font to sans-serif
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

  // Widget untuk kartu restoran
  Widget _buildRestaurantCard(String imagePath, String name, baseUrl) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "$baseUrl/media/restaurant/$imagePath/$imagePath-logo.png",
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // Widget untuk kartu makanan
  Widget _buildFoodCard(String imagePath, String title, String price, String restaurantName, String baseUrl, depokrasa_user.User user, BuildContext context) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 50, // Image takes 3/5 of the square
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: SizedBox.expand(
                    child: Image.network(
                      '$baseUrl/media/restaurant/$restaurantName/$imagePath.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 25, 
                child: Padding(
                  padding: const EdgeInsets.only(top:8,right:8,left:8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 10, 
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rp$price", 
                        style: const TextStyle(
                          color: Colors.green,
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.end,

                      ),
                    ]
                  )
                )
              ),
              Expanded(
                flex: 15, 
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final request = context.read<CookieRequest>();
                          String apiUrl = "$baseUrl/wishlist/add/";

                          try {
                            final response = await request.postJson(apiUrl, jsonEncode({
                              'name': title,
                            }));

                            if (response['status'] == 'success') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Item $title added to wishlist')),
                              );
                            } else {
                              throw Exception(response['message']);
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error adding item to wishlist: $e')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          minimumSize: const Size(double.infinity, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Add to Wishlist',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                          )
                        )
                      ),
                    ]
                  )
                )
              )
            ],
          ),
    );
}

