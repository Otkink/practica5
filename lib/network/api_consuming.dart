import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:practica5/main.dart';
import 'package:practica5/modelos/topArtists_model.dart';

class ApiConsuming {

  dynamic getTopArtists() async{ //recupera los artistas mas populares del momento
    final response = await http.get(Uri.parse('https://ws.audioscrobbler.com/2.0/?method=chart.gettopartists&api_key=b888f73daa74adb1a269ee720271d7db&format=json'));
    if(response.statusCode == 200){
      var top = jsonDecode(response.body)['artists']['artist'];
      topArtistsList = top;
      print(topArtistsList);
      return top;
    }else{
      return null;
    }
  }

  dynamic getTopAlbums(String name) async{ //recupera los albums mas populares del artista al que le corresponda tal mbid
    final response = await http.get(Uri.parse('https://ws.audioscrobbler.com/2.0/?method=artist.gettopalbums&artist=$name&api_key=b888f73daa74adb1a269ee720271d7db&format=json'));
    if(response.statusCode == 200){
      var top = jsonDecode(response.body)['topalbums']['album'];
      topAlbumsList = top;
      //print(topAlbumsList);
      return top;
    }else{
      return null;
    }
  }

  dynamic getAlbumInfo(String artista, String album) async{ //recupera los albums mas populares del artista al que le corresponda tal mbid
    final response = await http.get(Uri.parse('https://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=b888f73daa74adb1a269ee720271d7db&artist=$artista&album=$album&format=json'));
    if(response.statusCode == 200){
      var top = jsonDecode(response.body)['album'];
      topAlbumInfo = top;
      print(topAlbumInfo);
      return top;
    }else{
      return null;
    }
  }

  dynamic getTrackInfo(String artista, String track) async{ //recupera la infor de la cancion seleccionada
    final response = await http.get(Uri.parse('https://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=b888f73daa74adb1a269ee720271d7db&artist=$artista&track=$track&format=json'));
    if(response.statusCode == 200){
      String source = Utf8Decoder().convert(response.bodyBytes); //necesario para mostrar los caracteres especiales
      var top = jsonDecode(source)['track'];
      trackInfo = top;
      print(trackInfo);
      return top;
    }else{
      return null;
    }
  }

  dynamic getTrackSearch(String artista, String track) async{ //recupera los albums mas populares del artista al que le corresponda tal mbid
    final response = await http.get(Uri.parse('https://api.musixmatch.com/ws/1.1/track.search?q_track=$track&q_artist=$artista&page_size=3&page=1&s_track_rating=desc&apikey=c8f77fd34c1c8ea1a6a24e718ea63225'));
    if(response.statusCode == 200){
      //String source = Utf8Decoder().convert(response.bodyBytes); //necesario para mostrar los caracteres especiales
      var search = jsonDecode(response.body)['message']; //if(trackSearch['body']['track_list'].toString() != '[]'){ /* codigo.... */ }
      trackSearch = search;
      if(trackSearch['body']['track_list'].toString() != '[]'){ has_lyrics = true; }
      print(topAlbumInfo);
      return search;
    }else{
      return null;
    }
  }

  dynamic getTrackLyrics(int trackID) async{ //recupera los albums mas populares del artista al que le corresponda tal mbid
    final response = await http.get(Uri.parse('https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$trackID&apikey=c8f77fd34c1c8ea1a6a24e718ea63225'));
    if(response.statusCode == 200){
      String source = Utf8Decoder().convert(response.bodyBytes); //necesario para mostrar los caracteres especiales
      var search = jsonDecode(source)['message'];
      trackLyrics = search;
      print(topAlbumInfo);
      return search;
    }else{
      return null;
    }
  }


  /*Future<List<TopArtistsModel>?> getAllTop() async{//recupera los albums mas populares del momento
    final response = await http.get(Uri.parse('https://ws.audioscrobbler.com/2.0/?method=chart.gettopartists&api_key=b888f73daa74adb1a269ee720271d7db&format=json'));
    if(response.statusCode == 200){
      var popular = jsonDecode(response.body)['artists']['artist'] as List;
      List<TopArtistsModel> listPopular = popular.map((artist) => TopArtistsModel.fromMap(artist)).toList();

      topArtistsList = popular;
      print('PRUEBA ${popular[1]}');
      
      
      return listPopular;
    }else{
      return null;
    }
  }*/


  
}