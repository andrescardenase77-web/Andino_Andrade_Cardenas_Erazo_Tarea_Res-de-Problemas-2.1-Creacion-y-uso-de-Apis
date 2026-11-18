import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/config/app_routes.dart';
import 'app/config/app_theme.dart';
import 'app/config/providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getAppProviders(),
      child: MaterialApp(
        title: 'Cafetería - Pedidos',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.inicio,
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}

// Alias de conveniencia
typedef CafeteriaApp = MyApp;
