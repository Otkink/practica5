import 'package:flutter/material.dart';
import 'package:practica5/main.dart';
import 'package:practica5/modelos/topArtists_model.dart';
import 'package:practica5/network/api_consuming.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                albumes.clear(); //vacio la variable
                await _getTopArtists().whenComplete(() async {
                  for(int i = 0; i<49; i++){//iteracion para extraer solo el primer album de cada artista
                    await _getTopAlbums(topArtistsList[i]['name']); //obtengo los albumes mas populares de cada artista //PODRIA CONSIDERARSE COMO UN EXCESO DE PETICIONES
                    print('ARTISTA ${topArtistsList[i]['name']}');
                    print('ALBUM ${i+1} ${topAlbumsList[0]['name']}'); //siempre solo recuperar el primer album
                    
                    //var albumes = Map<String, String>();
                    albumes['$i artista'] = topArtistsList[i]['name'];
                    albumes['$i album'] = topAlbumsList[0]['name'];
                    albumes['$i albumCover'] = topAlbumsList[0]['image'][3]['#text']; //guardo la imagen extralarge
                    
                  }
                  print(albumes);
                  print(albumes.length);
                  print(albumes['5 album']);
                  //print('ALBUM $topAlbumsList');
                });
                //print('ARTISTA ${topArtistsList[0]['name']}'); //solo ocupo el nombre
                
                Navigator.pop(context);
                Navigator.pushNamed(context, '/albums');
              },
              child: Text('Explorar'),
            )
          )
        ],
      ),
    );
  }

  Future<void> _getTopArtists() async {
    ApiConsuming? apiCon = ApiConsuming();
    await apiCon.getTopArtists();
  }
  Future<void> _getTopAlbums(String name) async {
    ApiConsuming? apiCon = ApiConsuming();
    //print('MBID ${topArtistsList[49]['name']}');
    await apiCon.getTopAlbums(name);
  }
}