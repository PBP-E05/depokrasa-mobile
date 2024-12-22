import 'package:depokrasa_mobile/articles/screens/articles_main.dart';
import 'package:depokrasa_mobile/screen/menu.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  // PageController to control the PageView
  late PageController _pageController;

  // List of pages to navigate to
  final List<Widget> _pages = [
    const DepokRasaHomePage(),
    const DepokRasaHomePage(),
    const DepokRasaHomePage(),
    const ArticlesPage(),
    const ArticlesPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex); // Initialize PageController
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        // PageView allows you to swipe between pages
        controller: _pageController, // Pass the PageController here
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // Update the current index when the page changes
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current index on tap
          });
          _pageController.jumpToPage(index); // Use jumpToPage to navigate
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Gift',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
