import 'package:flutter/material.dart';
import 'package:depokrasa_mobile/screen/addmenuform.dart';
import 'package:depokrasa_mobile/shared/bottom_navbar.dart';
import 'package:depokrasa_mobile/models/user.dart'; // Import the User class

void main() {
  runApp(DepokRasaApp());
}

class DepokRasaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DepokRasaHomePage(user: User(username: 'admin', isAdmin: true)), // Pass a User instance here
    );
  }
}

class DepokRasaHomePage extends StatefulWidget {
  final User user; // Add this line to define the user parameter

  const DepokRasaHomePage({Key? key, required this.user}) : super(key: key); // Update the constructor

  @override
  _DepokRasaHomePageState createState() => _DepokRasaHomePageState();
}

class _DepokRasaHomePageState extends State<DepokRasaHomePage> {
  int _currentIndex = 0;
  List<dynamic> _restaurants = []; // Full list of restaurants
  List<dynamic> _visibleRestaurants = []; // List of visible restaurants
  bool _showAll = false; // Flag to determine whether to show all or not

  // Simulated restaurant data
  final List<Map<String, String>> restaurantData = [
    {'image': 'assets/mujigae.png', 'name': 'Mujigae'},
    {'image': 'assets/ancon.png', 'name': 'Ancon'},
    {'image': 'assets/takarajima.png', 'name': 'Takarajima'},
    {'image': 'assets/restaurant4.png', 'name': 'Restaurant 4'},
    {'image': 'assets/restaurant5.png', 'name': 'Restaurant 5'},
    {'image': 'assets/restaurant6.png', 'name': 'Restaurant 6'},
    {'image': 'assets/restaurant7.png', 'name': 'Restaurant 7'},
    {'image': 'assets/restaurant8.png', 'name': 'Restaurant 8'},
    {'image': 'assets/restaurant9.png', 'name': 'Restaurant 9'},
    {'image': 'assets/restaurant10.png', 'name': 'Restaurant 10'},
  ];

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Initially show only the first 6 restaurants
    _restaurants = restaurantData;
    _visibleRestaurants = _restaurants.take(6).toList();
  }

  // Method to show all restaurants when the "Show More" button is pressed
  void _showMore() {
    setState(() {
      _showAll = true;
      _visibleRestaurants = _restaurants; // Show all restaurants
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Restaurant List
              const Text(
                'Restaurant List',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 120, // Height for the restaurant list container
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Horizontal scroll
                  itemCount: _visibleRestaurants.length, // Show the visible restaurants
                  itemBuilder: (context, index) {
                    final restaurant = _visibleRestaurants[index];
                    return _buildRestaurantCard(
                      restaurant['image']!,
                      restaurant['name']!,
                    );
                  },
                ),
              ),
              SizedBox(height: 16),

              // Depok Rasa Pick (Food Grid)
              const Text(
                'Depok Rasa Pick',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return _buildFoodCard(
                    'assets/chicken_bulgogi.png',
                    'Chicken Bulgogi',
                    'Rp 40.000',
                  );
                },
              ),

              // Show More Button
              SizedBox(height: 16),
              !_showAll
                  ? Center(
                      child: ElevatedButton(
                        onPressed: _showMore,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Show More'),
                      ),
                    )
                  : Container(), // Hide the button once all restaurants are shown
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavBar(user: widget.user), // Pass the user parameter here

      // FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AddMenuForm(user: widget.user), // Pass the user parameter here
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
  Widget _buildRestaurantCard(String imagePath, String name) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
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
  Widget _buildFoodCard(String imagePath, String title, String price) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
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
                Text(price, style: const TextStyle(color: Colors.green)),
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
                  child: const Text('Add to Wishlist'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
