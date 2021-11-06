import 'package:elastic_drawer/elastic_drawer.dart';
import 'package:flutter/material.dart';
import 'package:practica5/main.dart';

class DetallesScreen extends StatefulWidget {
  DetallesScreen({Key? key}) : super(key: key);

  @override
  _DetallesScreenState createState() => _DetallesScreenState();
}

class _DetallesScreenState extends State<DetallesScreen> {
  @override
  Widget build(BuildContext context) {
    final detalle = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>; //cone sta instruccion es posible recuperar los parametros enviados en el Navigator.pushNamed(..., arguments:"...")

    var _addTag = <Widget>[];//contendra cada una de los tags de la cancion
    if(trackInfo['toptags']['tag'].toString() != '[]'){ //si en conjunto de tags esta vacio //DARA ERROR SI EL NOMBRE DE LA CANCION CONTIENE UN: &
      for(int i = 0; i < trackInfo['toptags']['tag'].length; i++){
        _addTag.add(
          Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: 100,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF18252F), 
                Color(0xFF213340)
              ],
            ),
            /*boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                //offset: Offset(0, 3), // changes position of shadow
              ),
            ],*/
          ),
          child: Text(
            '${trackInfo['toptags']['tag'][i]['name']}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15.0,
                //fontWeight: FontWeight.w400,
                color: Colors.white),
          ),
        )
        );
      }
    }

    String summary = trackInfo['wiki']['summary'];


    return ElasticDrawer(
      //mainColor: Colors.white,
      drawerColor: Color(0xff18252F),

      mainChild: Scaffold(
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
                  Container(
                    width: 100,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      //color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                    ),
                    child: Text('${trackInfo['artist']['name']}', style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
                  ),
                  AbsorbPointer(
                    //inhabilita la interaccion con este widget
                    child: IconButton(
                      padding: EdgeInsets.all(18.0),
                      onPressed: () {},
                      icon: Icon(
                        Icons.music_note_outlined,
                        color: Colors.transparent
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  //bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                    colors: [Color(0xFF18252F), 
                        Color(0xFF213340)]),
              ),
            ),
            preferredSize: Size(MediaQuery.of(context).size.width, 150.0),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Column(
                children: [
                  SizedBox(height: 50),
                  Container(margin: EdgeInsets.symmetric(horizontal: 20), child: Text(detalle['track'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40), textAlign: TextAlign.center,)),
                  SizedBox(height: 20),
                  Text(detalle['duration']),
                  Container(
                      height: 70.0,
                      width: 100.0,
                    child: Image.asset(
                      "iconos/icons8-onda-sonora.gif",
                      fit: BoxFit.fill
                    ),
                  ),
                  SizedBox(height: 10),
                  trackInfo['listeners'] != null ? Text('Listeners: ${trackInfo['listeners']}') : Text("Listeners: 0"),
                  Text('Reproducciones: ${trackInfo['playcount']}'),
                  SizedBox(height: 30),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50), 
                    child: trackInfo['wiki'] != null ? 
                      Text(summary.substring(0, summary.indexOf('<a')), //es necesario tratar al texto como un String. Con este sub string quito todo el texto despues del <a que aparece al final de cada summary
                        style: TextStyle(color: Colors.black54)
                      ) 
                      : Text("")), //si no contiene wiki, no contiene ni summary ni content,  ya que si los llamara siendo inexistentes provocaria un error de invocacion.
                  SizedBox(height: 30),
                  trackInfo['toptags']['tag'].toString() != '[]' ? Text("Tags", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)) : Text(''),
                  SizedBox(height: 20),
                  Container(
                    width: 600,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Wrap( //helps moving crowded widgets to the next line
                    spacing: 10.0,
                      alignment: WrapAlignment.center,
                      children: _addTag
                    )
                  )
                ],
              )
            ),
          ],
        ), //Evito que desborde y recorto el texto al ancho del contenedor resultando en: lorem ipsum...
      ),


      drawerChild: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF18252F), 
                       Color(0xFF213340)])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
                    height: 200.0,
                    width: 300,
            child: Image.asset(
                      "iconos/wavewhip.gif",
                      color: Colors.white,
                      fit: BoxFit.fill,
                    ),
          ),
        ),
      )
    );
  }
}