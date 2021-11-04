import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practica5/pantallas/albums.dart';
import 'package:practica5/pantallas/canciones.dart';
import 'package:practica5/pantallas/detalles.dart';
import 'package:practica5/pantallas/lyrics.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData( //Cambia el texto del status bar para todas las vistas
        appBarTheme: AppBarTheme(
          backwardsCompatibility: false, // 1
          systemOverlayStyle: SystemUiOverlayStyle.light, // 2
        ),
      ),
      routes: {
        '/songs' : (BuildContext context) => SongsScreen(),
        '/detalles' : (BuildContext context) => DetallesScreen(),
        '/lyrics' : (BuildContext context) => LyricScreen()
      },
      debugShowCheckedModeBanner: false,
      home: AlbumsScreen(),
    );
  }
}