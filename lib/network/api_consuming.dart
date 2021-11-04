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