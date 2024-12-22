// ignore_for_file: avoid_print
import 'dart:collection';
import 'package:depokrasa_mobile/articles/models/categories_entry.dart';
import 'package:depokrasa_mobile/articles/screens/article_content.dart';
import 'package:depokrasa_mobile/articles/models/articles_entry.dart';
import 'package:depokrasa_mobile/shared/bottom_navbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ArticlesPage extends StatefulWidget {
  final String categoryFilter;

  const ArticlesPage({
    super.key,
    this.categoryFilter = 'all',
    });

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  // ignore: non_constant_identifier_names
  late List<String> category_list;


  String baseUrl = kDebugMode ? "http://127.0.0.1:8000": "http://muhammad-wendy-depokrasa.pbp.cs.ui.ac.id";
  Future<List<ArticleEntry>> fetchArticles(CookieRequest request) async {
    // ignore: prefer_typing_uninitialized_variables
    final response;
    final categoryFilter = widget.categoryFilter;
    if(categoryFilter == 'all'){
      response = await request.get(
        '$baseUrl/articles/get-articles/');
    }else{
      response = await request.get(
        '$baseUrl/articles/get-articles-by-category/${widget.categoryFilter}/');
    }

    var data = response;

    List<ArticleEntry> listArticles = [];
    for(var entry in data) {
      if(entry != null){
        listArticles.add(ArticleEntry.fromJson(entry));
      }
    }

    return listArticles;
  }

  Future<List<String>> fetchCategories(CookieRequest request) async {
    final response = await request.get(
      '$baseUrl/articles/get-categories/'
    );


    List<CategoryEntry> categories = [];
    for(var category in response){
      categories.add(CategoryEntry.fromJson(category));
    }
    return categories.map((entry) => entry.name).toList();
  }

  @override
  Widget build(BuildContext context){
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: FutureBuilder(
        future: fetchArticles(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null){
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text("Loading Entries"),
                  CircularProgressIndicator(),
                ],
              )
            );
          }else {
            if(!snapshot.hasData){
              return const Column(
                children: [
                  Text(
                    'Articles not found!',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  SizedBox(height: 8),
                ],
              );
            }else{
              return Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25.0,bottom:15), // Add 55px of top padding
                        child: Image.asset(
                          'images/depokrasa-logo.png',
                          width: 198,
                          height: 52,
                        ),
                        
                      ),
                    ),
                    Text(
                      widget.categoryFilter == "all" ? "Articles" : "${widget.categoryFilter} - Articles",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Inter',
                      ),
                    ),
                    FutureBuilder(
                      future: fetchCategories(request), 
                      builder: (context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        if (snapshot.data!.isEmpty) {
                          return const Text("No Comments");
                        }
                        
                        return Container(
                          margin: const EdgeInsets.only(top: 3, bottom:3),
                          //height:39,
                          color:const Color(0xFFFB633A),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child:DropdownCategories(categories: snapshot.data),
                          )
                        );
                      }
                    ),
                    Flexible(  // You can give the ListView a specific height with this
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              // Navigate to the ArticleContentPage with the articleId
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArticleContentPage(
                                    articleId: snapshot.data![index].id,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Column(
                                
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.5), // Black shadow with some opacity
                                              blurRadius: 6, // Spread of the shadow
                                              offset: const Offset(1, 1), // Shadow direction (horizontal, vertical)
                                            ),
                                          ],
                                        ),
                                        child: Image.network(
                                          "$baseUrl${snapshot.data![index].featuredImg}",
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Text Section
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Title Text
                                            Text(
                                              "${snapshot.data![index].title}",
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // Metadata Row
                                            Row(
                                              children: [
                                                Text(
                                                  "${snapshot.data![index].createdOn.toString()} | ",
                                                  style: const TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                // Categories List
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                      children: [
                                                        for (var category in snapshot.data![index].categories)
                                                          GestureDetector(
                                                            onTap: () async {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => ArticlesPage(categoryFilter: category),
                                                                ),
                                                              );
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(right: 3.0),
                                                              child: Container(
                                                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                                                decoration: BoxDecoration(
                                                                  color: const Color(0xFFFB633A),
                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                ),
                                                                child: Text(
                                                                  category,
                                                                  style: const TextStyle(
                                                                    fontSize: 11.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: 'Inter',
                                                                    fontStyle: FontStyle.italic,
                                                                    color: Colors.white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(
                                    color: Color.fromARGB(66, 56, 56, 56),
                                    thickness: 1.0,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );


            }
          }
        }),
      );
  }
}

class DropdownCategories extends StatefulWidget {
  final List<String> categories;

  const DropdownCategories({
    super.key,
    required this.categories,
  });

  @override
  State<DropdownCategories> createState() => _DropdownCategoriesState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _DropdownCategoriesState extends State<DropdownCategories> {
  late List<MenuEntry> menuEntries;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    // Convert categories to dropdown menu entries
    menuEntries = UnmodifiableListView<MenuEntry>(
      widget.categories.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
    );
    selectedCategory = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: DropdownButton<String>(
            value: selectedCategory,  // Bind the selected category to this field
            isExpanded: false,  // Ensure it takes full width
            isDense: true,
            
            hint: const Text(
              'Categories',
              style: TextStyle(
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              color: Colors.white,            
              ),
              textAlign: TextAlign.right,
            ),
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            selectedItemBuilder: (BuildContext context) {
              return widget.categories.map<Widget>((String item) {
                return Container(
                  alignment: Alignment.centerRight,
                  width: 80,
                  child: Text(item, textAlign: TextAlign.end)
                );
              }).toList();
            }, 
            alignment: AlignmentDirectional.centerEnd,
            icon: const Icon(
              Icons.arrow_drop_down,
              size: 35,
              color: Colors.white,
            ),
            dropdownColor: const Color(0xFFFB633A),  // Set dropdown background color
            underline: Container(),  // Removes the underline, as it isn't needed
            onChanged: (String? category) {
              setState(() {
                selectedCategory = category;  // Update selected category
              });
              // Navigate to the Articles screen with the selected category
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticlesPage(categoryFilter: category ?? 'all'),
                ),
              );
            },
            items: widget.categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );

  }
}
