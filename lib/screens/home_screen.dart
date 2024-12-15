import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'jokes_screen.dart';

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
            icon: Icon(Icons.lightbulb),
            onPressed: () async {
              final randomJoke = await ApiService.fetchRandomJoke();
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(randomJoke['setup'], style: Theme.of(context).textTheme.headlineLarge),
                  content: Text(randomJoke['punchline'], style: Theme.of(context).textTheme.bodyLarge),
                ),
              );
            },
          ),
        ],
      ),
      body: AnimatedList(
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
    );
  }
}
