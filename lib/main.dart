import 'package:flutter/material.dart';
import 'package:pddmobile/main_layout.dart';
import 'package:pddmobile/services/cache_service.dart';
import 'package:pddmobile/state/notificationState.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final List<Map<String, dynamic>>? notificationCache =
      await CacheService().getCacheData();

  runApp(ChangeNotifierProvider(
    create: (context) => NotificationState(),
    child: MyApp(notificationCache: notificationCache),
  ));
}

class MyApp extends StatelessWidget {
  final List<Map<String, dynamic>>? notificationCache;
  const MyApp({super.key, this.notificationCache});

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
      home: MainLayout(notificationCache: notificationCache),
      debugShowCheckedModeBanner: false,
    );
  }
}
