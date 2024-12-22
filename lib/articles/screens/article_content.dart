import 'package:depokrasa_mobile/articles/screens/articles_main.dart';
import 'package:depokrasa_mobile/shared/bottom_navbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:depokrasa_mobile/articles/models/comments_entry.dart';
import 'package:depokrasa_mobile/articles/models/articles_entry.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';


class ArticleContentPage extends StatefulWidget {
  final int articleId;


  const ArticleContentPage(
    {super.key, 
    required this.articleId,

    });

  @override
  State<ArticleContentPage> createState() => _ArticleContentPageState();
}

class _ArticleContentPageState extends State<ArticleContentPage> {
  late Future<List<dynamic>> commentsFuture;
  int _currentIndex = 0;

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String baseUrl = kDebugMode ? "http://127.0.0.1:8000": "http://muhammad-wendy-depokrasa.pbp.cs.ui.ac.id";
  
  Future<ArticleEntry> fetchArticleContent(CookieRequest request) async {
    final response = await request.get(
        '$baseUrl/articles/get-article/${widget.articleId}/');
    return ArticleEntry.fromJson(response);
  }

  Future<List<dynamic>> fetchComments(CookieRequest request) async {
    final response = await request.get(
        '$baseUrl/articles/get-comments/${widget.articleId}/');
    return response;
  }

  Future<void> addComment(CookieRequest request, String body) async {
    await request.post(
      '$baseUrl/articles/add-comment/',
      {
        'article_id': widget.articleId.toString(),
        'comment': body,
      },
    );
    setState(() {
      commentsFuture = fetchComments(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    commentsFuture = fetchComments(request);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: FutureBuilder(
        future: fetchArticleContent(request),
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
            }
          }
          final article = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height:25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Center the row's children
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back button with left padding using InkWell
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: InkWell(
                        onTap: () async {
                          Navigator.pop(context);  // Navigate back on tap
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          size: 35,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                    
                    // DepokRasa Logo
                    InkWell(
                      child: Image.asset(
                        'images/depokrasa-logo.png',
                        width: 198,
                        height: 52,
                      ),
                      // onTap: () async {
                      //   Navigator.push(context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //       MyHomePage()),
                      //   ));
                      // }
                    ),

                    const SizedBox(width: 53), 
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Image.network(
                          '$baseUrl${article.featuredImg}',
                          width: 402,
                          height: 210,
                          fit: BoxFit.cover,
                          
                        ),
                      ),
                      Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter'
                        ),
                      ),
                      Text(
                        article.createdOn,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter'
                        ),
                      ),
                      const SizedBox(height: 16),
                      HtmlWidget(
                        article.body,
                        baseUrl: Uri.parse(baseUrl),
                      ),
                      const SizedBox(height: 10,
                      ),

                      Container(
                        color: const Color.fromARGB(255, 193, 193, 193),
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "#Categories:",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                                fontStyle: FontStyle.italic
                                
                              ),
                            ),

                            // Article's Categories
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              
                              children: [
                                for (var category in article.categories)
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 3.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                        color: const Color(0xFFFB633A),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Text(
                                          "#$category",
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Inter',
                                            fontStyle: FontStyle.italic,
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      ),
                                    ),

                                    onTap: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ArticlesPage(categoryFilter: category),
                                        ),
                                      );
                                    }
                                  )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8,),
                      const Divider(
                        thickness: 3,
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Comments",
                            style: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showCommentDialog(context, (String body) async {
                                await addComment(request, body);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFB633A),
                              foregroundColor: const Color(0xFFFFFFFF)
                            ),
                            child: const Text(
                              "Add Comment",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              
                            ),
                          ),                        
                        ],
                      ),
                      FutureBuilder(
                        future: commentsFuture,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.data!.isEmpty) {
                            return const Text("No Comments");
                          }
                          
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final comment = CommentEntry.fromJson(snapshot.data![index]);
                              return CommentCard(comment: comment, baseUrl: baseUrl);
                            }
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CommentForm extends StatefulWidget {
  final void Function(String body) onSubmit;

  const CommentForm({super.key, required this.onSubmit});

  @override
  State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, 
      children: [
        TextField(
          controller: _controller,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: "Add a Comment",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onSubmit(_controller.text); // Submit the comment
              _controller.clear();
            }
          },
          child: const Text(
            "Submit",
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

void showCommentDialog(BuildContext context, void Function(String body) onSubmit) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Add a Comment"),
        content: CommentForm(onSubmit: (body) {
          onSubmit(body); // Pass the comment back to the parent widget
          Navigator.of(context).pop(); // Close the dialog after submission
        }),
      );
    },
  );
}

class CommentCard extends StatelessWidget {
  final CommentEntry comment;
  final String baseUrl;

  const CommentCard({
    super.key,
    required this.comment,
    required this.baseUrl
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 4,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage("$baseUrl${comment.author.profilePicture}"),
              radius: 30, // Adjust size as needed
            ),
            const SizedBox(width: 4,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        comment.author.username,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        comment.createdOn,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                          color: Color.fromARGB(255, 58, 58, 58),
                        
                        ),
                      ),
                      
                    ]
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.body,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider()
      ],
    );
  }}

