import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'signin_page.dart';
import 'register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');  // token can be null, so we handle it
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;  // token can be nullable

  const MyApp({
    this.token,  // make the token parameter nullable
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isTokenValid = token != null && !JwtDecoder.isExpired(token!);  // null check before calling JwtDecoder
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isTokenValid ? HomeScreen(token: token!) : const SignInPage(),  // Set HomeScreen as the initial route
      routes: {
        '/register': (context) => const RegisterPage(),
        '/signin': (context) => const SignInPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
