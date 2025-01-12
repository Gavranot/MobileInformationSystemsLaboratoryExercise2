import '../services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

class JokesScreen extends StatelessWidget {
  final String type;

  JokesScreen({required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$type Jokes')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ApiService.fetchJokesByType(type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final joke = snapshot.data![index];
                final isFavorite = context.watch<FavoritesProvider>().favoriteJokes.contains(joke);

                return Card(
                  child: ListTile(
                    title: Text(joke['setup']),
                    subtitle: Text(joke['punchline']),
                    trailing: IconButton(
                      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                      onPressed: () {
                        context.read<FavoritesProvider>().toggleFavorite(joke);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
