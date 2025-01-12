import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoriteJokes = context.watch<FavoritesProvider>().favoriteJokes;

    return Scaffold(
      appBar: AppBar(title: Text('Favorite Jokes')),
      body: favoriteJokes.isEmpty
          ? Center(child: Text('No favorites yet!'))
          : ListView.builder(
        itemCount: favoriteJokes.length,
        itemBuilder: (context, index) {
          final joke = favoriteJokes[index];
          return Card(
            child: ListTile(
              title: Text(joke['setup']),
              subtitle: Text(joke['punchline']),
            ),
          );
        },
      ),
    );
  }
}
