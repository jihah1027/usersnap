//NURUL NAJIHAH BINTI HUSAIN 302039

import 'package:flutter/material.dart';
import 'package:usersnap/view/splashscreen.dart';

void main() {
  runApp(const RandomUserApp());
}

class RandomUserApp extends StatelessWidget {
  const RandomUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Snap : Random User Viewer',
      theme: ThemeData(primarySwatch: Colors.blue ),
      home: const SplashScreen(),
        );
  }
}
