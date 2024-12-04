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
    //[7, TimeOfDay(hour: 15, minute: 30)],
    //[3, TimeOfDay(hour: 20, minute: 0)],
    //[0, TimeOfDay(hour: 19, minute: 50)], //test
  ];

  List<List<dynamic>> nonVagueConfig = [
    // Format : [jour avant échéance, heure de notification]
    [30, TimeOfDay(hour: 9, minute: 0)],
    //[15, TimeOfDay(hour: 14, minute: 0)],
    //[1, TimeOfDay(hour: 18, minute: 0)],
    //[0, TimeOfDay(hour: 19, minute: 50)], //test
  ];

  Future<void> init() async {

    //await requestExactAlarmPermission();

    // Initialize time zones
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));//));'Europe/Paris'currentTimeZone

    // Android notification details
    const AndroidInitializationSettings initializationSettingsAndroid = 
        AndroidInitializationSettings('@android:drawable/ic_dialog_info');//'app_icon');
    
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
    }

    print('NotificationService initialisé');
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
      // Pour Android 13+, utiliser permission_handler
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      if (deviceInfo.version.sdkInt >= 33) {
        final status = await Permission.notification.request();
        return status.isGranted;
      }
      
      // Pour les versions Android antérieures à 13
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
    return Random().nextInt(10000).toInt();///(todo.hashCode ^ DateTime.now().millisecondsSinceEpoch) & 0x7FFFFFFF;
  }

  // Méthode principale pour planifier les notifications d'une tâche
  Future<void> scheduleTodoNotifications({
    required Todo todo,
  }) async {
    // Toujours utiliser la date de fin comme référence
    if (todo.dueDate == null) return;

    // Choisir la configuration
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
        hour: DateTime.now().hour,//notificationTime.hour,
        minute: DateTime.now().minute +2//notificationTime.minute
      );
      debugPrint("preparing notification with time : ${potentialNotificationDate}, while DateTime.now() is ${DateTime.now()} and due date is ${todo.dueDate}.");
      debugPrint("notification verification output status : ${potentialNotificationDate.isAfter(DateTime.now()) && 
          potentialNotificationDate.isBefore(todo.dueDate!)}");
      // Vérifier que la notification est dans la plage valide
      if (potentialNotificationDate.isAfter(DateTime.now()) && 
          potentialNotificationDate.isBefore(todo.dueDate!)) {
        debugPrint("notification date passed basic border verifications");
        // Générer un identifiant unique
        int notificationId = _generateUniqueNotificationId(todo);

        // Créer la notification
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
      //enableVibration: true,
      //playSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Préparer le titre et le corps de la notification
    String title = "Tâche à venir : ${todo.title}";
    
    String body = todo.startDate != null
        ? "Rappel pour la tâche vague \"${todo.title}\". " 
          "À terminer pour le ${dateFormatter.format(dueDate)}"
        : "Rappel important pour la tâche \"${todo.title}\". " 
          "Date limite : ${dateFormatter.format(dueDate)}";

    try {
      print('Tentative de planification de notification:');
      print('ID: $notificationId');
      print('Date schedulée: $scheduledDate');
      print('Heure actuelle: ${DateTime.now()}');
      print('Timezone local: ${tz.local}');

      // Conversion explicite en TZDateTime
      final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);
      
      // Vérification supplémentaire
      if (tzScheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
        print('ATTENTION: Date de notification dans le passé!');
        return;
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId, 
        "Tâche à venir : ${todo.title}",
        "À terminer pour le ${dateFormatter.format(dueDate)}",
        tzScheduledDate,//tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: 
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // Nouveau paramètre
      );

      print('Notification planifiée avec succès');
      
    } catch (e) {
      print('Erreur complète lors de la planification de la notification : $e');
      print('Stacktrace: ${StackTrace.current}');
      _currentAlarmType = AlarmType.inexact;
    }

    // Ajouter la notification à la liste des notifications de la tâche
    todo.addNotification(
      NotificationInfo(
        deviceId: await _getDeviceId(), 
        notificationId: notificationId
      )
    );
  }

  Future<String> _getDeviceId() async {
    // Implémentation de DeviceIdentifierManager
    return DeviceIdentifierManager.getDeviceIdentifier();
  }

  // Annuler toutes les notifications pour une tâche
  Future<void> cancelTodoNotifications(Todo todo) async {
    for (var notificationInfo in todo.notificationIds) {
      await flutterLocalNotificationsPlugin.cancel(notificationInfo.notificationId);
    }
    // Vider la liste des identifiants de notifications
    todo.notificationIds.clear();
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> testNotificationImmediately(Todo todo) async {
    print('Test notification immédiate');
    
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
      'Ceci est une notification de test', 
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


// Extension pour faciliter la copie avec modification d'un DateTime
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