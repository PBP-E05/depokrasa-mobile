import 'package:depokrasa_mobile/screen/addmenuform.dart';
import 'package:flutter/material.dart';
import 'package:depokrasa_mobile/shared/bottom_navbar.dart';

void main() {
  runApp(DepokRasaApp());
}

class DepokRasaApp extends StatelessWidget {
  const DepokRasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DepokRasaHomePage(),
    );
  }
}

class DepokRasaHomePage extends StatefulWidget {
  const DepokRasaHomePage({super.key});

  @override
  _DepokRasaHomePageState createState() => _DepokRasaHomePageState();
}

class _DepokRasaHomePageState extends State<DepokRasaHomePage> {
  int _currentIndex = 0;

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
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
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Restaurant List
              const Text(
                'Restaurant List',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120, // Tinggi container agar slider terlihat dengan baik
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Scroll horizontal
                  itemCount: 10, // Jumlah restoran yang ingin ditampilkan
                  itemBuilder: (context, index) {
                    // Data restoran simulasi
                    final restaurantData = [
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

                    final restaurant = restaurantData[index % restaurantData.length];
                    return _buildRestaurantCard(
                      restaurant['image']!,
                      restaurant['name']!,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Depok Rasa Pick
              const Text(
                'Depok Rasa Pick',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
              const SizedBox(height: 16),
              Center(
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
