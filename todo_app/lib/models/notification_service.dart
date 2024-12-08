import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:todo_app/models/device_identifier_service.dart';
import 'dart:math';
import 'package:todo_app/models/todo.dart';


enum AlarmType {
  exact,
  inexact
}

// data structure to store the notification information (reference)
class NotificationInfo {
  final String deviceId;
  final int notificationId;

  NotificationInfo({
    required this.deviceId, 
    required this.notificationId
  });
}

// Todo extension to handle the notifications
extension TodoNotificationExtension on Todo {
  // method to add a notification to the list
  void addNotification(NotificationInfo notification) {
    notificationIds.add(notification);
  }
}

class NotificationService {
  AlarmType _currentAlarmType = AlarmType.exact;
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();

    
  // Configuration avec des listes [jours, heures]
  List<List<dynamic>> vagueConfig = [
    // Format : [jour avant échéance, heure de notification]
    [14, TimeOfDay(hour: 10, minute: 0)],
    [7, TimeOfDay(hour: 15, minute: 30)],
    [3, TimeOfDay(hour: 20, minute: 0)],
  ];

  List<List<dynamic>> nonVagueConfig = [
    // Format : [jour avant échéance, heure de notification]
    [30, TimeOfDay(hour: 9, minute: 0)],
    [15, TimeOfDay(hour: 14, minute: 0)],
    [1, TimeOfDay(hour: 18, minute: 0)],
  ];

  Future<void> init() async {

    //await requestExactAlarmPermission();

    // Initialize time zones
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    // Android notification details
    const AndroidInitializationSettings initializationSettingsAndroid = 
        AndroidInitializationSettings('@android:drawable/ic_dialog_info');
    
    // iOS notification details
    const DarwinInitializationSettings initializationSettingsIOS = 
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    // Combined initialization settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialiser le plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );

    // Demander les permissions
    final notificationPermissionGranted = await requestNotificationPermissions();
    final exactAlarmPermissionGranted = await requestExactAlarmPermission();

    if (!notificationPermissionGranted) {
      print('Notification permissions not granted');
      // Gérer le cas où les permissions sont refusées
      // Peut-être afficher un dialogue à l'utilisateur

    }

    if (!exactAlarmPermissionGranted) {
      print('Exact alarm permissions not granted');
      // Basculer sur des alarmes inexactes ou gérer différemment
      _currentAlarmType = AlarmType.inexact;
    }

    print('NotificationService initialized');
    print('Exact Alarm Permission: $exactAlarmPermissionGranted');
    print('Notification Permission: $notificationPermissionGranted');
  }

  // Gestionnaire de tap sur notification
  void onNotificationTap(NotificationResponse notificationResponse) {
    // Logique de gestion quand l'utilisateur tape sur une notification
    print('Notification tapped');
  }

  Future<bool> requestExactAlarmPermission() async {
    // Vérifier la version d'Android
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    // Demander la permission uniquement pour Android 12 et supérieur
    if (androidInfo.version.sdkInt >= 31) {
      final status = await Permission.scheduleExactAlarm.status;
      
      if (!status.isGranted) {
        final result = await Permission.scheduleExactAlarm.request();
        
        if (result.isDenied) {
          // Gérer le cas où la permission est refusée
          print('Exact alarm permission denied for notifications. Switching to inexact alarms.');
          _currentAlarmType = AlarmType.inexact;
          return false;
        }
        return true;
      }
      return true;

    }
    return true;
  }

  Future<bool> requestNotificationPermissions() async {
    if (Platform.isIOS) {
      // Pour iOS, utiliser directement l'implémentation iOS
      final iOS = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      
      if (iOS != null) {
        return await iOS.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ?? false;
      }
      return false;
    }
    
    if (Platform.isAndroid) {
      // for Android 13+, use permission_handler
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      if (deviceInfo.version.sdkInt >= 33) {
        final status = await Permission.notification.request();
        return status.isGranted;
      }
      
      // for android version before 13
      final androidImplementation = 
        flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      
      return androidImplementation != null;
    }

    return false;
  }


  // generate a unique notification identifier.
  int _generateUniqueNotificationId(Todo todo) {
    //return (todo.hashCode + DateTime.now().millisecondsSinceEpoch + 
    //       Random().nextInt(10000)).toInt();
    return Random().nextInt(100000).toInt();///(todo.hashCode ^ DateTime.now().millisecondsSinceEpoch) & 0x7FFFFFFF;
  }

  // Méthode principale pour planifier les notifications d'une tâche
  Future<void> scheduleTodoNotifications({
    required Todo todo,
  }) async {
    if (todo.dueDate == null) return;

    // choose configuration
    List<List<dynamic>> config = todo.startDate != null 
        ? vagueConfig 
        : nonVagueConfig;

    // Formatter pour affichage de la date
    final dateFormatter = DateFormat('dd/MM/yyyy à HH:mm');

    // Parcourir chaque configuration de notification
    for (var notificationConfig in config) {
      // Calculer la date de notification
      int daysBeforeDueDate = notificationConfig[0];
      TimeOfDay notificationTime = notificationConfig[1];

      DateTime referenceDate = todo.dueDate!;
      DateTime potentialNotificationDate = referenceDate.copyWith(
        //to test notifications :
        hour: notificationTime.hour, //hour: DateTime.now().hour,
        minute: notificationTime.minute, //minute: DateTime.now().minute +2
      );

      debugPrint("preparing notification with time : ${potentialNotificationDate}, while DateTime.now() is ${DateTime.now()} and due date is ${todo.dueDate}.");
      debugPrint("notification verification output status : ${potentialNotificationDate.isAfter(DateTime.now()) && 
          potentialNotificationDate.isBefore(todo.dueDate!)}");
      // verify notification date limits
      if (potentialNotificationDate.isAfter(DateTime.now()) && 
          potentialNotificationDate.isBefore(todo.dueDate!)) {
        debugPrint("notification date passed basic border verifications");
        // generate unique id
        int notificationId = _generateUniqueNotificationId(todo);

        await _createNotification(
          todo: todo, 
          scheduledDate: potentialNotificationDate, 
          notificationId: notificationId,
          dueDate: todo.dueDate!,
          dateFormatter: dateFormatter
        );
      }
    }
  }

 Future<void> _createNotification({
    required Todo todo, 
    required DateTime scheduledDate, 
    required int notificationId,
    required DateTime dueDate,
    required DateFormat dateFormatter,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = 
        AndroidNotificationDetails(
      'todo_channel',
      'Todo Notifications',
      importance: Importance.high,
      priority: Priority.high,
      //allowWhileIdle: true,
      //showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // title and body of notification
    String title = "Upcoming Task : ${todo.title}";
    
    String body = todo.startDate != null
        ? "Reminder for the vague task \"${todo.title}\". " 
          "To be completed by ${dateFormatter.format(dueDate)}"
        : "Important task reminder \"${todo.title}\". " 
          "Due date : ${dateFormatter.format(dueDate)}";

    try {
      print('Notification plannification attempt:');
      print('ID: $notificationId');
      print('Scheduled date: $scheduledDate');
      print('Current Date: ${DateTime.now()}');
      print('Local Timezone: ${tz.local}');

      // Conversion explicite en TZDateTime
      final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);
      
      // Vérification supplémentaire
      if (tzScheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
        print('WARNING: notification date in the past!');
        return;
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId, 
        title,
        body,
        tzScheduledDate,//tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
        platformChannelSpecifics,
        androidScheduleMode: _currentAlarmType==AlarmType.exact ? AndroidScheduleMode.exactAllowWhileIdle : AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: 
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      print('Notification succesfully planned');
      
    } catch (e) {
      print('Complete error while trying to plan notification : $e');
      print('Stacktrace: ${StackTrace.current}');
      _currentAlarmType = AlarmType.inexact;
    }

    // add notification to notification list of task
    todo.addNotification(
      NotificationInfo(
        deviceId: await _getDeviceId(), 
        notificationId: notificationId
      )
    );
  }

  Future<String> _getDeviceId() async {
    return DeviceIdentifierManager.getDeviceIdentifier();
  }

  Future<void> cancelTodoNotifications(Todo todo) async {
    for (var notificationInfo in todo.notificationIds) {
      if (notificationInfo.deviceId == _getDeviceId()) {
        await flutterLocalNotificationsPlugin.cancel(notificationInfo.notificationId);
      }
    }

    for (var notificationInfo in todo.notificationIds) {
      if (notificationInfo.deviceId == _getDeviceId()) {
        todo.notificationIds.clear();
      }
    }
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> resetAllDeviceNotifications(List<Todo> tasks) async {
    cancelAllNotifications();
    for (var task in tasks) {
      cancelTodoNotifications(task);
      task.scheduleNotifications(this);
    }
  }

  Future<void> testNotificationImmediately(Todo todo) async {
    print('immediate notfication test');
    
    const AndroidNotificationDetails androidPlatformChannelSpecifics = 
        AndroidNotificationDetails(
      'todo_channel_id',
      'Test Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(100000), 
      'Test Notification', 
      'This is a test notification', 
      platformChannelSpecifics
    );
  }

  Future<void> checkPendingNotificationRequests() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print('${pendingNotificationRequests.length} pending notification ');

    for (PendingNotificationRequest pendingNotificationRequest
        in pendingNotificationRequests) {
      print(pendingNotificationRequest.id.toString() +
          " " +
          (pendingNotificationRequest.payload ?? ""));
    }
    print('NOW ' + tz.TZDateTime.now(tz.local).toString());
  }
}



extension DateTimeExtension on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}