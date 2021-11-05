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
    for(int i = 0; i < topAlbumInfo['tracks']['track'].length; i++){ //RESOLVER NULLIDAD DE QUE NO HAYA CANCIONES EN UN ALBUM
      _listaSongs.add(
        GestureDetector(
          onTap: () async {
            await _getTrackInfo(topAlbumInfo['artist'], topAlbumInfo['tracks']['track'][i]['name']);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("${i+1}. ", style: TextStyle(color: Colors.black54)),
                    Container(width: 200, child: Text(topAlbumInfo['tracks']['track'][i]['name'], overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black54))), //Evito que desborde y recorto el tecto al ancho del contenedor resultando en: lorem ipsum...
                  ],
                ),
                Text('${formatDuration(topAlbumInfo['tracks']['track'][i]['duration'])}', style: TextStyle(color: Colors.black54))
              ],
            ),
          ),
        )
      );
      _listaSongs.add(SizedBox(height: 20));
      _listaSongs.add(Container(margin: EdgeInsets.symmetric(horizontal: 50), child: Divider()));      
      _listaSongs.add(SizedBox(height: 20));
    }
    /* 色は正しいデータになる */
    String colorString = paletteGenerator.toString();
    String valueString = colorString.split('(0x')[1].split(')')[0];
    int value = int.parse(valueString, radix: 16);
    Color imageShadow = new Color(value); //BoxShadowでColorとして使う

    return Scaffold(
      extendBodyBehindAppBar: true,
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
                  color: Colors.black,
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
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, 150.0),
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          Center(
              child: Container(
                decoration: BoxDecoration(
                //color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(blurRadius: 10, color: imageShadow, spreadRadius: 5)],
              ),
                child: CircleAvatar(
                    radius: 160,
                    backgroundImage: NetworkImage('${detalle['albumCover']}'),
          ),
              )),
          SizedBox(height: 30),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),//lo encierro en un container para evitar que desborde y el texto se acomode automaticamente
            child: Text("${topAlbumInfo['name']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20 )),
          ),
          SizedBox(height: 15),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),//lo encierro en un container para evitar que desborde y el texto se acomode automaticamente
            child: Text("${topAlbumInfo['artist']}", style: TextStyle(fontSize: 15))
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

  _getTrackInfo(String artista, String track) async {
    ApiConsuming? apiCon = ApiConsuming();
    await apiCon.getTrackInfo(artista, track);
  }
}