import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<Map<String, String>> getJokeOfTheDay() async {
    final prefs = await SharedPreferences.getInstance();
    final jokeSetup = prefs.getString('joke_setup') ?? 'No joke today!';
    final jokePunchline = prefs.getString('joke_punchline') ?? '';
    return {
      'setup': jokeSetup,
      'punchline': jokePunchline,
    };
  }
}
