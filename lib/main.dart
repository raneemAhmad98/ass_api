import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<dynamic> getData() async {
// get API used http
    const urlApi =
        'https://countriesnow.space/api/v0.1/countries/info?returns=currency,flag,unicodeFlag,dialCode';
    final getApi = await http.get(Uri.parse(urlApi));

    if (getApi.statusCode == 200) {
      var bodyApi = json.decode(getApi.body);
      return await bodyApi;
    } else {
      return print('Error not found api');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          title: Text('assessment coding exercises'),
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (conn, AsyncSnapshot snap) {
            if (snap.hasData) {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.all(2.0),
                    child: GridTile(
                        footer: GridTileBar(
                          backgroundColor: Colors.black38,
                          title: Text(snap.data['data'][index]['name'] ?? ''),
                          trailing: Text(snap.data['data'][index]['currency'] ?? '' , style: TextStyle(
                              color: Colors.white
                          )),
                        ),
                        child: SvgPicture.network(
                          snap.data['data'][index]['flag'] ?? 'https://flagicons.lipis.dev/flags/4x3/cy.svg',
                          fit: BoxFit.cover,
                        )),
                  ));
            } else {
              return Text('wait 1 min ');
            }
          },
        ));
  }
}
