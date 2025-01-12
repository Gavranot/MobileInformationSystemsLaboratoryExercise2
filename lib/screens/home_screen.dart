import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/api_services.dart';
import '../services/daily_notification_service.dart';
import 'jokes_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late Future<List<String>> jokeTypes;
  final List<String> _displayedJokeTypes = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    jokeTypes = ApiService.fetchJokeTypes();
    _loadJokeTypes();
  }

  void _loadJokeTypes() async {
    final types = await ApiService.fetchJokeTypes();
    for (int i = 0; i < types.length; i++) {
      Future.delayed(Duration(milliseconds: 200 * i), () {
        _displayedJokeTypes.add(types[i]);
        _listKey.currentState?.insertItem(i);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joke Types', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _displayedJokeTypes.length,
              itemBuilder: (context, index, animation) {
                final type = _displayedJokeTypes[index];
                return SlideTransition(
                  position: animation.drive(
                    Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
                        .chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(type, style: Theme.of(context).textTheme.bodyLarge),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.teal),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => JokesScreen(type: type)),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final status = await Permission.notification.request();
              if (!status.isGranted) {
                // show a message or redirect user to settings
                return;
              }
              // Trigger the debug notification
              await DailyNotificationService.sendDebugNotification();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Debug notification triggered!")),
              );
            },
            child: Text("Send Debug Notification"),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
