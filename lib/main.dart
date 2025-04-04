import 'package:expenses_tracker/expenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //lock screen orientation

ColorScheme colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 85, 178, 225),
  // onSecondaryContainer: C,
  brightness: Brightness.light,
);

ColorScheme darkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 5, 99, 125));

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((fn) {
    // here what we have done is locked the oreintation of app,
    //then only app will start //put runApp() here
  }).catchError((error) {
    print('Error setting orientation: $error');
  });
  runApp(
      SafeArea(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: darkColorScheme,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 55, 105, 129),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 9, 9, 9),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor:
                const Color.fromARGB(255, 85, 178, 225), // Text color
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
            titleLarge: TextStyle(fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 248, 255, 255))),
        cardTheme: const CardTheme().copyWith(
          color: darkColorScheme.surface,
          // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        ),
      ), //this is for dark theme
      theme: ThemeData(
          //this is for light theme, which theme/mode to select that depends on themeMode parameter
          //setting centralise colors of appbar and app color
          colorScheme: colorScheme,
          appBarTheme: AppBarTheme(
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 55, 105, 129),
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 9, 9, 9),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor:
                  const Color.fromARGB(255, 85, 178, 225), // Text color
            ),
          ),
          // cardTheme: CardTheme().copyWith(
          //   color: colorScheme.secondaryContainer,
          //   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          // ),
          textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(fontWeight: FontWeight.bold),
              bodyMedium: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 248, 255, 255)))
          //primaryColor:
          ),
      themeMode: ThemeMode.dark,
      home: Expenses(),
    ),
  ));

  /*
  alternative way of code for above code this code will block the orientation (lock orientation)
  * void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    runApp(MyApp());
  } catch (e) {
    print('Error setting orientation: $e');
  }
}
  * */
}
