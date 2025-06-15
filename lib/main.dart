import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos/router.dart';
import 'firebase_options.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      await initializeRemoteConfig();

      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

      runApp(const ProviderScope(child: MainApp()));
    },
    (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

class FirebaseInitWrapper extends StatelessWidget {
  const FirebaseInitWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const MainApp();
        } else if (snapshot.hasError) {
          return const MaterialApp(home: Scaffold(body: Center(child: Text('Firebase init failed'))));
        } else {
          return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
        }
      },
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(color: Colors.white, routerConfig: appRouter, debugShowCheckedModeBanner: false);
  }
}

Future<void> initializeRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setDefaults({
    'show_proximity_button': false,
    'show_like_counter': false,
    'enable_dark_mode': false,
  });

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(fetchTimeout: const Duration(seconds: 10), minimumFetchInterval: const Duration(minutes: 1)),
  );

  await remoteConfig.fetchAndActivate();

  print('[RemoteConfig Init] enable_dark_mode: ${remoteConfig.getBool('enable_dark_mode')}');
  print('[RemoteConfig Init] show_proximity_button: ${remoteConfig.getBool('show_proximity_button')}');
  print('[RemoteConfig Init] show_like_counter: ${remoteConfig.getBool('show_like_counter')}');
}
