import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:depokrasa_mobile/shared/left_drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List of image paths
  final List<String> imageList = [
    'images/image1.jpg',
    'images/image1.jpg', // Add more images as needed
    'images/image1.jpg',
  ];

  // Carousel controller
  final CarouselSliderController _carouselController = CarouselSliderController();

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
            // Floating Carousel Slider
            CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: imageList.length,
              itemBuilder: (context, index, realIndex) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 6), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      imageList[index],
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 300,
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 300,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.8,
                // Add scale effect for more floating appearance
                enlargeStrategy: CenterPageEnlargeStrategy.scale,
                // Slight scaling to enhance floating effect
              ),
            ),

            // Optional: Manual navigation buttons
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
            ),
          ],
        ),
      ),
      drawer: const LeftDrawer(),
    );
  }
}