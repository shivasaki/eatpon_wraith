import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:eatpon_wraith/views/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}
