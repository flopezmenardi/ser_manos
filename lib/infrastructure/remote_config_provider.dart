import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

final remoteConfigProvider = Provider<FirebaseRemoteConfig>((ref) {
  final remoteConfig = FirebaseRemoteConfig.instance;

  print('[RemoteConfig] enable_dark_mode: ${remoteConfig.getBool('enable_dark_mode')}');
  print('[RemoteConfig] show_proximity_button: ${remoteConfig.getBool('show_proximity_button')}');
  print('[RemoteConfig] show_like_counter: ${remoteConfig.getBool('show_like_counter')}');

  return remoteConfig;
});
