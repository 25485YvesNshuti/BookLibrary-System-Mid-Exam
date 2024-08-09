import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mybook_library/screens/home_screen.dart';
import 'package:mybook_library/providers/book_provider.dart';
import 'package:mybook_library/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'MyBook Library',
          theme: ThemeData.light().copyWith(
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.green),
              bodyMedium: TextStyle(color: Colors.green),
              bodySmall: TextStyle(color: Colors.green),
              headlineLarge: TextStyle(color: Colors.green),
              headlineMedium: TextStyle(color: Colors.green),
              headlineSmall: TextStyle(color: Colors.green),
              titleLarge: TextStyle(color: Colors.green),
              titleMedium: TextStyle(color: Colors.green),
              titleSmall: TextStyle(color: Colors.green),
              labelLarge: TextStyle(color: Colors.green),
              labelMedium: TextStyle(color: Colors.green),
              labelSmall: TextStyle(color: Colors.green),
            ),
          ),
          darkTheme: ThemeData.dark(),
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: HomeScreen(),
        );
      },
    );
  }
}
