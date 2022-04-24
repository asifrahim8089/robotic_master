// ignore_for_file: unused_import, prefer_const_constructors

import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:provider/single_child_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robotek/Authfiles/splashScreen.dart';
import 'package:robotek/Providers/get_data_provider.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(
    MultiProvider(
      providers: providers,
      child: MyApp(),
    ),
  );
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<GetDataProvider>(create: (_) => GetDataProvider()),
];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
