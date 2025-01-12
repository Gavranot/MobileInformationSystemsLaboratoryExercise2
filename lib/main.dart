import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lab2/services/firebase_notification_service.dart';
import 'package:lab2/services/local_notification_service.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart'; // Ensure this file is correctly generated
import 'package:provider/provider.dart';
import 'providers/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'services/notification_service.dart';



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase Notification Service
  FirebaseNotificationService().initialize();

  // Initialize Local Notification Service (Optional)
  LocalNotificationService localNotificationService = LocalNotificationService();
  await localNotificationService.initialize();
  localNotificationService.scheduleDailyNotification();

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
        scaffoldBackgroundColor: Colors.grey[200],
        cardColor: Colors.white,
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal,
          elevation: 4,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal, // Updated property name
            foregroundColor: Colors.white, // Ensures text/icon color is appropriate
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
