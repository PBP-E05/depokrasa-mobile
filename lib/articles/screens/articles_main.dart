import 'package:depokrasa_mobile/articles/screens/article_content.dart';
import 'package:depokrasa_mobile/authentication/screens/login.dart';
import 'package:depokrasa_mobile/articles/models/articles_entry.dart';
import 'package:depokrasa_mobile/shared/left_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;


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
  Future<List<ArticleEntry>> fetchProduct(CookieRequest request) async {
    final response;
    final categoryFilter = widget.categoryFilter;
    if(categoryFilter == 'all'){
      response = await request.get(
        'http://127.0.0.1:8000/articles/get-articles/');
    }else{
      response = await request.get(
        'http://127.0.0.1:8000/articles/get-articles-by-category/${widget.categoryFilter}/');
    }

    if(response == null){
      developer.log("    response null    ");
    }

    var data = response;

    List<ArticleEntry> listArticles = [];
    for(var entry in data) {
      if(entry != null){
        listArticles.add(ArticleEntry.fromJson(entry));
      }
    }

    developer.log("listArticles:    $listArticles    ");

    return listArticles;
  }

  @override
  Widget build(BuildContext context){
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryFilter == 'all' 
            ?'Articles' 
            : 'Articles: ${widget.categoryFilter}',
        )
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProduct(request),
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
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => ListTile(
                  leading: Image.network(
                    "http://127.0.0.1:8000${snapshot.data![index].featuredImg}",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover
                  ),
                   title: Text(
                      "${snapshot.data![index].title}",
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    // Print first paragraph <p> from article's content
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("${snapshot.data![index].createdOn.toString().substring(0, 10)} | "),
                        Text('Categories: '),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: 
                            Row(
                              children: [
                                for(var category in snapshot.data[index].categories)
                                SizedBox(
                                  width: 150,
                                  child: ListTile(
                                    title: Text(
                                      category,
                                      style: const TextStyle(fontSize: 10),),
                                    onTap: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ArticlesPage(categoryFilter: category))
                                      );
                                    },
                                  )
                                )
                              ],
                            )
                        )
                      ],
                    ),
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleContentPage(articleId: snapshot.data[index].id))
                      );
                    }
                  ) 
              );
            }
          }
        }),
      );
  }
}