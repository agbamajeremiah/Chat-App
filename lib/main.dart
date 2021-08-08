import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:MSG/constant/route_names.dart';
import 'package:MSG/locator.dart';
import 'package:MSG/models/messages.dart';
import 'package:MSG/models/thread.dart';
import 'package:MSG/services/authentication_service.dart';
import 'package:MSG/services/database_service.dart';
import 'package:MSG/services/navigtion_service.dart';
import 'package:MSG/ui/shared/app_colors.dart';
import 'package:MSG/ui/shared/theme.dart';
import 'package:MSG/ui/router.dart';
import 'package:MSG/core/network/api_request.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//Manages Background Messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final random = Random();
  final chatMsgData = message.data['data'];
  final newMessage = jsonDecode(chatMsgData)[0];
  var isThreadSaved =
      await DatabaseService.db.checkIfThreadExist(newMessage['threadID']);
  if (isThreadSaved != true) {
    Thread newThread = Thread(
      id: newMessage['threadID'],
      members: newMessage['sender'],
      favourite: 0,
    );
    DatabaseService.db.insertThread(newThread);
  }
  DatabaseService.db.insertNewMessage(ChatMessage.fromMap(newMessage));
  await _updateReceivedMessges(messageID: newMessage['_id']);
  // Get Contact Name from database
  String displayName = newMessage['sender'];
  var contactDetails =
      await DatabaseService.db.getSingleContactFromDb(newMessage['sender']);
  if (contactDetails != null) {
    displayName = contactDetails['displayName'];
  }
  // debugPrint(displayName + newMessage['content']);
  final int notificationId = random.nextInt(1000000);
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: 'private_msg_channel',
        title: displayName,
        body: newMessage['content'],
        displayedLifeCycle: NotificationLifeCycle.AppKilled,
        showWhen: true,
        autoCancel: true,
        notificationLayout: NotificationLayout.Default,
        payload: {
          'threadID': newMessage['threadID'],
          'displayName': displayName,
          'sender': newMessage['sender'],
          'id': notificationId.toString(),
        },
      ),
      actionButtons: [
        NotificationActionButton(
          label: "Reply",
          key: "REPLY",
          autoCancel: true,
          buttonType: ActionButtonType.InputField,
        ),
        // NotificationActionButton(
        //   label: "Cancel",
        //   key: "CANCEL",
        //   autoCancel: true,
        //   buttonType: ActionButtonType.DisabledAction,
        // ),
      ]);
}

Future _updateReceivedMessges({@required String messageID}) async {
  final _authService = AuthenticationSerivice();
  await _authService.setToken();
  final _userToken = _authService.token;
  try {
    Map<String, dynamic> body = {"messageID": messageID};
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "authorization": "Bearer $_userToken",
    };
    var response = await postResquest(
      url: "/markasdelivered",
      headers: headers,
      body: body,
    );
    return response;
  } catch (e) {
    if (e is DioError) {
      debugPrint(e.response.statusCode.toString());
    }
    debugPrint(e.toString());
    throw e;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  overrideNavColors();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //Awesome notification
  AwesomeNotifications().initialize(
    'resource://drawable/app_icon',
    [
      NotificationChannel(
        channelKey: 'private_msg_channel',
        channelName: 'Private Message Notification',
        channelDescription: 'Notification channel for private messages',
        importance: NotificationImportance.High,
        defaultColor: AppColors.primaryColor,
        defaultRingtoneType: DefaultRingtoneType.Notification,
        enableLights: true,
        // soundSource: 'resource://raw/notify',
        playSound: true,
        groupKey: 'threadID',
        groupAlertBehavior: GroupAlertBehavior.Summary,
        ledColor: Colors.white,
        defaultPrivacy: NotificationPrivacy.Private,
      )
    ],
  );
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(builder: (context, notifier, child) {
        return MaterialApp(
          title: 'MSG',
          debugShowCheckedModeBanner: false,
          navigatorKey: locator<NavigationService>().navigationKey,
          theme: notifier.darkTheme == true ? darkTheme : lightTheme,
          initialRoute: Routes.splashViewRoute,
          onGenerateRoute: generateRoute,
        );
      }),
    );
  }
}

/// Set StatusBar and NavigationBar Customization for android
void overrideNavColors() {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      /// Set StatusBar Customization.
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,

      /// Set NavigationBar Customization.
      // systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  }
}
