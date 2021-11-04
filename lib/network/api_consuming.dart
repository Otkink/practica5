import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:practica5/modelos/topArtists_model.dart';

class ApiConsuming {
  Future<List<TopArtistsModel>?> getAllTop() async{
    final response = await http.get(Uri.parse('https://ws.audioscrobbler.com/2.0/?method=chart.gettopartists&api_key=b888f73daa74adb1a269ee720271d7db&format=json'));
    if(response.statusCode == 200){
      var popular = jsonDecode(response.body)['artists']['artist'] as List;
      List<TopArtistsModel> listPopular = popular.map((artist) => TopArtistsModel.fromMap(artist)).toList();
      return listPopular;
    }else{
      return null;
    }
  }
}