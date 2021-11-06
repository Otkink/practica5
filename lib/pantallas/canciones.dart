import 'package:flutter/material.dart';
import 'package:practica5/main.dart';
import 'package:practica5/network/api_consuming.dart';

class SongsScreen extends StatefulWidget {
  SongsScreen({Key? key}) : super(key: key);

  @override
  _SongsScreenState createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  @override
  Widget build(BuildContext context) {


    final detalle = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>; //cone sta instruccion es posible recuperar los parametros enviados en el Navigator.pushNamed(..., arguments:"...")
    var _listaSongs = <Widget>[];
    _listaSongs.add(SizedBox(height: 20));
    if(topAlbumInfo['tracks'] != null){//el album puede no contener el parametro 'tracks'
    for(int i = 0; i < topAlbumInfo['tracks']['track'].length; i++){ //RESOLVER NULLIDAD DE QUE NO HAYA CANCIONES EN UN ALBUM
      _listaSongs.add(
        GestureDetector(
          onTap: () async {
            await _getTrackInfo(topAlbumInfo['artist'], topAlbumInfo['tracks']['track'][i]['name']);
            await _getTrackSearch(topAlbumInfo['artist'], topAlbumInfo['tracks']['track'][i]['name']);
            if(has_lyrics){await _getTrackLyrics(trackSearch['body']['track_list'][0]['track']['track_id']);} //si es true, es porque tal cancion tiene letra. Puede arrojar mas de una coincidencia, pero solo escogere la primera de la lista
            Navigator.pushNamed(context, '/detalles', arguments: {'track':topAlbumInfo['tracks']['track'][i]['name'], 'duration' : formatDuration(topAlbumInfo['tracks']['track'][i]['duration'])});
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(width: 50, child: Text("${i+1}. ", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold))),
                    Container(width: 200, child: topAlbumInfo['tracks']['track'][i] != null ? Text(topAlbumInfo['tracks']['track'][i]['name'], overflow: TextOverflow.fade, style: TextStyle(color: Colors.black54)) : Text("")), //Evito que desborde y recorto el tecto al ancho del contenedor resultando en: lorem ipsum...
                  ],
                ),
                topAlbumInfo['tracks']['track'][i] != null ? Text('${formatDuration(topAlbumInfo['tracks']['track'][i]['duration'])}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)) : Text("")
              ],
            ),
          ),
        )
      );
      _listaSongs.add(SizedBox(height: 20));
      _listaSongs.add(Container(margin: EdgeInsets.symmetric(horizontal: 50), child: Divider()));      
      _listaSongs.add(SizedBox(height: 20));
    }
    }else{
      _listaSongs.add(
        Container(
          height: 200.0,
          width: 200.0,
          child: Image.asset("iconos/undraw_Taken_re_yn20.png", fit: BoxFit.contain),
        )
      );
      _listaSongs.add(
        Text('Sin canciones :)', textAlign: TextAlign.center, style: TextStyle(fontWeight:FontWeight.w300))
      );
    }
    /* 色は正しいデータになる */
    String colorString = paletteGenerator.toString();
    String valueString = colorString.split('(0x')[1].split(')')[0];
    int value = int.parse(valueString, radix: 16);
    Color imageShadow = new Color(value); //BoxShadowでColorとして使う
    
    var mediaQuery = MediaQuery.of(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                padding: EdgeInsets.all(18.0),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
              ),
              SizedBox(),
              AbsorbPointer(
                //inhabilita la interaccion con este widget
                child: IconButton(
                  padding: EdgeInsets.all(18.0),
                  onPressed: () {},
                  icon: Icon(
                    Icons.music_note_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 150.0),
      ),
      body: Column(//NetworkImage('${detalle['albumCover']}')
        children: [
          //SizedBox(height: 50),
          Container(
            width: double.infinity,
            height: mediaQuery.size.height / 1.9,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(48.0),
              ),
              image: DecorationImage(
                image:
                    NetworkImage('${detalle['albumCover']}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),//lo encierro en un container para evitar que desborde y el texto se acomode automaticamente
            child: Text("${topAlbumInfo['name']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF18252F) )),
          ),
          SizedBox(height: 15),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),//lo encierro en un container para evitar que desborde y el texto se acomode automaticamente
            child: Text("${topAlbumInfo['artist']}", style: TextStyle(fontSize: 15, color: Color(0xFF18252F)))
          ),
          SizedBox(height: 30),
          Expanded(//リストウィジェットのため必要
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: _listaSongs,
            ),
          )
        ],
      ),
    );
  }

  String formatDuration(int totalSeconds) { //convierte los segundo a formato m:ss
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, ''); //m
    final secondsString = '$seconds'.padLeft(2, '0'); //ss
    return '$minutesString:$secondsString';// m:ss
  }

  Future<void>_getTrackInfo(String artista, String track) async {
    ApiConsuming? apiCon = ApiConsuming();
    await apiCon.getTrackInfo(artista, track);
  }

  Future<void>_getTrackSearch(String artista, String track) async {
    ApiConsuming? apiCon = ApiConsuming();
    await apiCon.getTrackSearch(artista, track);
  }
  Future<void>_getTrackLyrics(int trackID) async {
    ApiConsuming? apiCon = ApiConsuming();
    await apiCon.getTrackLyrics(trackID);
  }
}