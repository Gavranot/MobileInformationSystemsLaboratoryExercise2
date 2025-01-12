import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_services.dart'; // Replace with your actual path to ApiService

class DailyNotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _notifications.initialize(settings);
  }

  static Future<void> fetchAndScheduleDailyJokeNotification() async {
    // Fetch a random joke
    final joke = await ApiService.fetchRandomJoke();

    // Save the joke in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('joke_setup', joke['setup'] ?? 'No joke setup available!');
    prefs.setString('joke_punchline', joke['punchline'] ?? 'No punchline available!');

    // Schedule the notification
    await scheduleDailyNotification();
  }

  static Future<void> scheduleDailyNotification() async {
    final prefs = await SharedPreferences.getInstance();
    final jokeSetup = prefs.getString('joke_setup') ?? 'No joke setup available!';
    final jokePunchline = prefs.getString('joke_punchline') ?? 'No punchline available!';

    final notificationBody = '$jokeSetup\n$jokePunchline';

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      15, // 3 PM
      16,
    );
    print('Notification scheduled for: $scheduledDate');

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      0,
      'Joke of the Day',
      notificationBody,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notification_channel',
          'Daily Notifications',
          channelDescription: 'Daily reminder for the joke of the day',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
  static Future<void> sendDebugNotification() async {
    final prefs = await SharedPreferences.getInstance();
    print("Enter");
    // Fetch the saved joke from SharedPreferences
    final jokeSetup = prefs.getString('joke_setup') ?? 'No joke available!';
    final jokePunchline = prefs.getString('joke_punchline') ?? '';
    print(jokeSetup);
    print(jokePunchline);
    // Combine the setup and punchline for the notification body
    final notificationBody = '$jokeSetup\n$jokePunchline';

    await _notifications.show(
      0,
      'Joke of the Day',
      notificationBody,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'debug_notification_channel',
          'Debug Notifications',
          channelDescription: 'Channel for debug notifications',
          icon: 'app_icon',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }


  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
