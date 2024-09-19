import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'AddTaskScreen.dart';
import 'config.dart';
import 'signin_page.dart'; // Ensure config.dart contains the correct URLs for APIs

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({required this.token, super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String userId;
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    userId = JwtDecoder.decode(widget.token)['_id'];
    getTodoLists();
  }

  // Fetch ToDo list from the server
  Future<void> getTodoLists() async {
    try {
      final response = await http.get(
        Uri.parse('$getTodoList?userId=$userId'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          setState(() {
            items = List<Map<String, dynamic>>.from(jsonResponse['success'] ?? []);
          });
        } else {
        }
      } else {
      }
    } catch (e) {
    }
  }

  // Delete a ToDo item from the server
  Future<void> deleteItem(String id) async {
    try {
      final Uri url = Uri.parse('$deleteTodo?id=$id'); // Ensure deleteTodo is correctly defined in config.dart
      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          setState(() {
            items.removeWhere((item) => item['_id'] == id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item deleted successfully')),
          );
        } else {
        }
      } else {
      }
    } catch (e) {

    }
  }

  // Sign out method to clear token and navigate to login screen
  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Clear the stored token
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SignInPage(), // Redirect to the login screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('DailyPlanner'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('DailyPlanner', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            const ListTile(leading: Icon(Icons.home), title: Text('Home')),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Task'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskScreen(token: widget.token),
                  ),
                ).then((value) {
                  if (value == true) {
                    getTodoLists();
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sign Out'),
              onTap: () {
                signOut(); // Call the sign-out function when tapped
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'TODO LIST',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            Expanded(
              child: items.isNotEmpty
                  ? ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var item = items[index];
                  DateTime createdAt;
                  try {
                    createdAt = DateTime.parse(item['createdAt']);
                  } catch (e) {
                    createdAt = DateTime.now();
                  }
                  String formattedDate = DateFormat('yyyy-MM-dd').format(createdAt);
                  String formattedTime = DateFormat('HH:mm').format(createdAt);

                  return Dismissible(
                    key: Key(item['_id'].toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      deleteItem(item['_id'].toString());
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text(item['title'] ?? 'title'),
                        subtitle: Text(item['des'] ?? 'des'),
                        trailing: Text('$formattedDate\n$formattedTime'),
                      ),
                    ),
                  );
                },
              )
                  : const Center(child: Text('Add Your Tasks')),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Task'),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskScreen(token: widget.token),
              ),
            ).then((value) {
              if (value == true) {
                getTodoLists();
              }
            });
          }
        },
      ),
    );
  }
}
