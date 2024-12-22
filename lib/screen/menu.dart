import 'package:depokrasa_mobile/models/restaurant_entry.dart';
import 'package:depokrasa_mobile/screen/addmenuform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class DepokRasaHomePage extends StatefulWidget {
  const DepokRasaHomePage({super.key});

  @override
  State<DepokRasaHomePage> createState() => _DepokRasaHomePageState();
}

class _DepokRasaHomePageState extends State<DepokRasaHomePage> {
  String baseUrl = kDebugMode ? "http://127.0.0.1:8000": "http://muhammad-wendy-depokrasa.pbp.cs.ui.ac.id";
  
  Future fetchRestaurants(CookieRequest request) async {
    final response = await request.get(
        '$baseUrl/api/restaurants/');

    List<RestaurantEntry> restaurants = [];
    for(var resto in response){
      restaurants.add(RestaurantEntry.fromJson(resto));
    }
    return restaurants;
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
                      ],
                    ),
                  ),
                ],
              ),
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
                        baseUrl
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMenuForm(),
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
  Widget _buildFoodCard(String imagePath, String title, String price, String restaurantName, String baseUrl) {
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
                        onPressed: () {},
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

