import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:readmore/readmore.dart';
import 'package:task1/model/news.dart';

Future<List<News>> fetchNews(http.Client client) async {
  final response = await client.get(Uri.parse('https://api.first.org/data/v1/news'));

  // Use the compute function to run parseNews in a separate isolate.
  return compute(parseNews, response.body);
}

// A function that converts a response body into a List<News>.
List<News> parseNews(String responseBody) {
  final parsed = jsonDecode(responseBody)['data'].cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<News>((json) => News.fromJson(json)).toList();
}


class NonFavourate extends StatelessWidget {
  const NonFavourate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyNonFavouratePage(),
    );
  }
}
class MyNonFavouratePage extends StatefulWidget {

  const MyNonFavouratePage({Key key}) : super(key: key);
  @override
  _MyNonFavouratePageState createState() => _MyNonFavouratePageState();
}

class _MyNonFavouratePageState extends State<MyNonFavouratePage> {

  Box<String> favourateBox;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    favourateBox = Hive.box<String>("favourate");
  }
  @override
  Widget build(BuildContext context) {
    List<News> news ;
    return Scaffold(

      body: FutureBuilder<List<News>>(
        future: fetchNews(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return _productWidget(context, snapshot.data,favourateBox);

          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Widget _productWidget(BuildContext context, product,favourateBox){
  print(product);
  return  ListView.builder(
    // physics: const NeverScrollableScrollPhysics(),
      itemCount: product == null ? '__' : product.length,
      itemBuilder: (context, index) {
        String text;
        if(product[index].summary == null){
          text ='' ;
        }else{text = product[index].summary;}

        return Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 4,
                      offset: Offset(0,5),
                      color: Colors.grey,
                      blurRadius: 9
                  )],
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: IconButton(icon: Icon(Icons.favorite_border_rounded,size: 60,),
                        onPressed: ()=>favourateBox.put(product[index].id,'dkjghkd')),
                      title: Column(
                        children: [
                          Text(product[index].title,style: TextStyle(fontWeight: FontWeight.w800,),),
                          ReadMoreText(
                            text,
                            trimLines: 2,
                            colorClickableText: Colors.blue,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Read More',
                            trimExpandedText: 'Show less',
                            // moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      subtitle: Text(product[index].published),
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      }  );
}