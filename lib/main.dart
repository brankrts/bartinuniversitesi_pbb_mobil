import 'package:flutter/material.dart';
import 'package:pddmobile/main_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personel Bilgi Bankasi',
      theme: ThemeData.dark().copyWith(
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Colors.white,
          )),
      home:  const MainLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}
