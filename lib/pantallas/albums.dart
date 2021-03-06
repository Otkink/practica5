import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:practica5/main.dart';
import 'package:practica5/network/api_consuming.dart';

class AlbumsScreen extends StatefulWidget {
  AlbumsScreen({Key? key}) : super(key: key);

  @override
  _AlbumsScreenState createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {

  bool flag = true; //servira para iterar las portadas y se muestren uno a la izq. y otro a la der.

  @override
  Widget build(BuildContext context) {
    
    var _listaAlbums = <Widget>[];
    _listaAlbums.add(SizedBox(height: 20));
    for (int i = 0; i < 49; i++) { // i < 
     if(flag){
        _listaAlbums.add(
        GestureDetector(
          onTap: () async {
            print('esperando...');
            await _getAlbumInfo('${albumes['$i artista']}', '${albumes['$i album']}');
            paletteGenerator = await getImagePalette(NetworkImage('${albumes['$i albumCover']}'));
            print('HOLA $paletteGenerator');
            Navigator.pushNamed(context, '/songs', arguments: {'albumCover':albumes['$i albumCover']});
          },
          child: Container(
            margin: EdgeInsets.only(right: 30, top: 10),
              height: 210,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(120),
                  bottomRight: Radius.circular(120)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    blurRadius: 5,
                    offset: Offset(0, 8), // Shadow position
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage('${albumes['$i albumCover']}'),
                  fit: BoxFit.fitWidth  
                )
              ),
              
            ),
        ),
      );
      flag = false;
     }else{
        _listaAlbums.add(
        GestureDetector(
          onTap: () async {
            print('esperando...');
            await _getAlbumInfo('${albumes['$i artista']}', '${albumes['$i album']}');
            paletteGenerator = await getImagePalette(NetworkImage('${albumes['$i albumCover']}'));
            print('HOLA $paletteGenerator');
            Navigator.pushNamed(context, '/songs', arguments: {'albumCover':albumes['$i albumCover'], 'nombreAlbum':albumes['$i album']});
          },
          child: Container(
            margin: EdgeInsets.only(left: 30),
              height: 210,
              //width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(120),
                  bottomLeft: Radius.circular(120)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.8),
                    blurRadius: 5,
                    offset: Offset(0, 8), // Shadow position
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage('${albumes['$i albumCover']}'),
                  fit: BoxFit.fitWidth  
                )
              ),
              
            ),
        ),
      );
      flag = true;
     }
     _listaAlbums.add(SizedBox(height: 30,));
    }


    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    padding: EdgeInsets.all(18.0),
                    onPressed: (){Navigator.pop(context);}, 
                    icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white,),
                    
                  ),
                  Container(
                    width: 100,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          //offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Text(
                      'Albumes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.0,
                        //fontWeight: FontWeight.w400,
                        color: Colors.black
                      ),
                    ),
                  ),
                  AbsorbPointer( //inhabilita la interaccion con este widget
                    child: IconButton( 
                      padding: EdgeInsets.all(18.0),
                      onPressed: (){}, 
                      icon: Icon(Icons.music_note_outlined, color: Colors.white,),
                      
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                          ),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF18252F),
                    Color(0xFF213340)
                  ]
                ),
                /*boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 20.0,
                    spreadRadius: 1.0
                  )
                ]*/
              ),
            ),
            preferredSize: Size(
              MediaQuery.of(context).size.width,
              150.0
            ),
            ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: _listaAlbums
      ),
    );
  }


  _getAlbumInfo(String artista, String album) async {
    ApiConsuming? apiCon = ApiConsuming();
    await apiCon.getAlbumInfo(artista, album);
  }

  // Calculate dominant color from ImageProvider
  Future<Color> getImagePalette (ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator
        .fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor!.color;
  }
}