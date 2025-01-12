import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';
import 'services/daily_notification_service.dart';
import 'screens/home_screen.dart';
import 'providers/favorites_provider.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings androidInitializationSettings =
  AndroidInitializationSettings('app_icon');
  // Make sure 'app_icon' (or your icon name) is in 'android/app/src/main/res/drawable/'

  // iOS initialization
  const DarwinInitializationSettings iosInitializationSettings =
  DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: iosInitializationSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // Optional: specify a callback for when a notification is tapped
    onDidReceiveNotificationResponse: (details) {
      // handle the notification tap
    },
  );

  tz.initializeTimeZones();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize the notification service
  await DailyNotificationService.initialize();

  // Schedule the daily notification at 3 PM
  //await DailyNotificationService.scheduleDailyNotification();
  await DailyNotificationService.fetchAndScheduleDailyJokeNotification();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: HomeScreen(),
    );
  }
}
