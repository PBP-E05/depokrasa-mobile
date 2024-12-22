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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'DepokRasa',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              FutureBuilder(
                future: fetchRestaurants(request), 
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null){
                    return const material.Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Text("Loading Pages"),
                          CircularProgressIndicator(),
                        ],
                      )
                    );
                  }else {
                    if(!snapshot.hasData){
                      return const Column(
                        children: [
                          Text(
                            'Restaurants not found!',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          material.SizedBox(height: 8),
                        ],
                      );
                    }else{
                      return Container(
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Restaurant List
                            const Text(
                              'Restaurant List',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const material.SizedBox(height: 8),
                            material.SizedBox(
                              height: 120, // Tinggi container agar slider terlihat dengan baik
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal, // Scroll horizontal
                                itemCount: snapshot.data!.length, // Jumlah restoran yang ingin ditampilkan
                                itemBuilder: (context, index) {
                                  // Data restora n                        
                                    return _buildRestaurantCard(
                                      snapshot.data[index]!.name.toString().replaceAll(" ", "-"),                  
                                      snapshot.data[index]!.name,
                                      baseUrl                  
                                    );                                    
                                }
                              )
                            ),
                            
                            const material.SizedBox(height: 16),

                            // Depok Rasa Pick
                            const Text(
                              'Depok Rasa Pick',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter'
                              ),
                            ),
                            const SizedBox(height: 8),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: snapshot.data.length*3,
                              itemBuilder: (context, index) {
                                return  _buildFoodCard(
                                  "${snapshot.data[index~/3].name.toString().replaceAll(" ", "-").toLowerCase()}-menu-${index%3 + 1}",
                                  snapshot.data[index~/3].menu[index % 3].foodName.toString(),
                                  snapshot.data[index~/3].menu[index % 3].price.toString(),
                                  snapshot.data[index~/3].name.toString().replaceAll(" ", "-").toLowerCase(),
                                  baseUrl
                                );
                              },
                            ),
                          ]
                      ),

                      );
                   }
                  }
                } 
              ),

              // Show More Button
              const material.SizedBox(height: 16),
              material.Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Show More'),
                ),
              ),
            ],
          ),
        ),
      ),


      // FloatingActionButton
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
  Widget _buildFoodCard(String imagePath, String title, String price,String restaurantName,String baseUrl) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
      builder: (context, constraints) {
        double cardHeight = constraints.maxHeight * 0.5; // Adjust height based on available space

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                '$baseUrl/media/restaurant/$restaurantName/$imagePath.png',
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text("Rp$price", 
                    style: const TextStyle(
                      color: Colors.green,
                      fontFamily: 'Inter',
                      fontSize:14,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(double.infinity, 36),
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
                        fontSize:14 
                      )
                    )
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}
