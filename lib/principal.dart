import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String collection = "groups";


  @override
  Widget build(BuildContext context) {

    Widget _buildImage(DocumentSnapshot document) {

      return GestureDetector(
        child: Container(
          child: Image.network(
            document["image"],
            height: 100,
            fit: BoxFit.fill,
          ),
        ),
        onTap: () {
          openLink(document["link"]);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Grupos'),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection(collection).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(

                  separatorBuilder: (context, index) => Divider(),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return _buildImage(snapshot.data.documents[index]);
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
        ),
      ),
    );
  }

  void openLink(String url) async{

    if(await canLaunch(url)){
      await launch(url);
    } else {
      throw "Falha em abrir o link do grupo!";
    }

  }

}