import 'package:depokrasa_mobile/articles/screens/articles_main.dart';
import 'package:depokrasa_mobile/feedback/feedback_widget.dart';
import 'package:depokrasa_mobile/screen/menu.dart';
import 'package:flutter/material.dart';
import 'package:depokrasa_mobile/models/user.dart' as depokrasa_user;
import 'package:depokrasa_mobile/user_management/screens/user_profile.dart';
import 'package:depokrasa_mobile/promosiDanDiskon/screen/promotion_page.dart'; // Import PromotionsPage

class BottomNavBar extends StatefulWidget {
  final depokrasa_user.User user; // Add user parameter

  const BottomNavBar({Key? key, required this.user})
      : super(key: key); // Add user parameter

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  // PageController to control the PageView
  late PageController _pageController;

  // List of pages to navigate to
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: _currentIndex); // Initialize PageController
    _pages = [
      DepokRasaHomePage(user: widget.user), // Pass user parameter
      PromotionsPage(user: widget.user), // Add PromotionsPage
      ArticlesPage(),
      FeedbackSupportPage(),
      UserProfileScreen(
          user: widget.user), // Correctly navigate to UserProfileScreen
    ];
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
            _currentIndex =
                index; // Update the current index when the page changes
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
            icon: Icon(Icons.local_offer), // Update icon for Promotions
            label: 'Promotions', // Update label for Promotions
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
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
