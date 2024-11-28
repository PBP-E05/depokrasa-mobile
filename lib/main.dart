import 'package:flutter/material.dart';
import 'package:depokrasa_mobile/authentication/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'DepokRasa',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const LoginPage(),
      ),
    );
  }
}