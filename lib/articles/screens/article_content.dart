import 'package:depokrasa_mobile/shared/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:depokrasa_mobile/articles/models/comments_entry.dart';
import 'package:depokrasa_mobile/articles/models/articles_entry.dart';

class ArticleContentPage extends StatefulWidget {
  final int articleId;

  const ArticleContentPage(
    {super.key, 
    required this.articleId});

  @override
  State<ArticleContentPage> createState() => _ArticleContentPageState();
}

class _ArticleContentPageState extends State<ArticleContentPage> {
  Future<ArticleEntry> fetchArticleContent(CookieRequest request) async {
    final response = await request.get(
        'http://127.0.0.1:8000/articles/get-article/${widget.articleId}/');
    return ArticleEntry.fromJson(response);
  }

  Future<List<CommentEntry>> fetchComments(CookieRequest request) async {
    final response = await request.get(
        'http://127.0.0.1:8000/articles/get-comments/{widget.articleId}/');
    return commentEntryFromJson(response);
  }

  Future<void> addComment(CookieRequest request, String body) async {
    await request.post(
      'http://127.0.0.1:8000/articles/add-comment/',
      {
        'article_id': widget.articleId.toString(),
        'body': body,
      },
    );
    setState(() {}); // Refresh comments
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Article Content"),
      ),
      drawer: const LeftDrawer(),
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
                Image.network(
                  'http://127.0.0.1:8000/${article.featuredImg}',
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Published on: ${article.createdOn.toString().substring(0,10)}"),
                      const SizedBox(height: 16),
                      Text(article.body),
                      const Divider(),
                      const Text(
                        "Comments",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      FutureBuilder(
                        future: fetchComments(request),
                        builder: (context, AsyncSnapshot<List<CommentEntry>> snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.data!.isEmpty) {
                            return const Text("No comments yet. Be the first!");
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final comment = snapshot.data![index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      comment.author.profilePicture),
                                ),
                                title: Text(comment.author.username),
                                subtitle: Text(comment.body),
                                trailing: Text(comment.createdOn.toString()),
                              );
                            },
                          );
                        },
                      ),
                      const Divider(),
                      const Text(
                        "Add a Comment",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      CommentForm(
                        onSubmit: (body) {
                          addComment(request, body);
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

  const CommentForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: "Comment",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onSubmit(_controller.text);
              _controller.clear();
            }
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
