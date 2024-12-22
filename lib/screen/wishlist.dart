import 'package:depokrasa_mobile/models/wishlist_entry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:depokrasa_mobile/models/user.dart' as depokrasa_user;

class WishlistPage extends StatefulWidget {
  final depokrasa_user.User user;

  const WishlistPage({super.key, required this.user});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  String baseUrl = kDebugMode ? "http://127.0.0.1:8000" : "https://sx6s6j6f-8000.asse.devtunnels.ms/"; 
  List<WishlistEntry> wishlist = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    setState(() {
      isLoading = true;
    });

    final request = context.read<CookieRequest>();
    String apiUrl = "$baseUrl/wishlist/";

    try {
      final response = await request.get(apiUrl);

      if (response['status'] == 'success') {
        final List<dynamic> data = response['data'];
        setState(() {
          wishlist = data.map((item) {
            return WishlistEntry.fromJson(item ?? {});
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load wishlist');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading wishlist: $e')),
      );
    }
  }

  // Future<void> addToWishlist(WishlistEntry item) async {
  //   final request = context.read<CookieRequest>();
  //   String apiUrl = "$baseUrl/wishlist/add/";

  //   try {
  //     final response = await request.postJson(apiUrl, {
  //       'product_id': item.productId,
  //     });

  //     if (response['status'] == 'success') {
  //       setState(() {
  //         wishlist.add(item);
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Item added to wishlist')),
  //       );
  //     } else {
  //       throw Exception(response['message']);
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error adding item to wishlist: $e')),
  //     );
  //   }
  // }

  Future<void> deleteFromWishlist(String itemId) async {
    final request = context.read<CookieRequest>();
    String apiUrl = "$baseUrl/wishlist/delete/";

    try {
      final response = await request.post(apiUrl, {
        'id': itemId,
      });

      if (response['status'] == 'success') {
        setState(() {
          wishlist.removeWhere((item) => item.id == itemId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item removed from wishlist')),
        );
      } else {
        throw Exception('Failed to remove item from wishlist');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing item from wishlist: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : wishlist.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No items in wishlist',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: wishlist.length,
                  itemBuilder: (context, index) {
                    final item = wishlist[index];
                    return _buildWishlistCard(item);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add to wishlist functionality
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildWishlistCard(WishlistEntry item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Rp${item.price}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                deleteFromWishlist(item.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
