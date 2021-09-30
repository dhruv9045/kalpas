
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readmore/readmore.dart';


class Favourate extends StatelessWidget {
  const Favourate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyFavouratePage(),
    );
  }
}
class MyFavouratePage extends StatefulWidget {

  const MyFavouratePage({Key key}) : super(key: key);
  @override
  _MyFavouratePageState createState() => _MyFavouratePageState();
}

class _MyFavouratePageState extends State<MyFavouratePage> {
  Box<String> favourateBox;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    favourateBox = Hive.box<String>("favourate");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: favourateBox.listenable(),
        builder: (context, Box<String> favourate, _){
          return ListView.builder(
            itemCount: favourateBox == null ? '__' : favourate.keys.toList().length,
              itemBuilder: (context, index) {
                final key = favourate.keys.toList()[index];
                final value = favourate.get(key);
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
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListTile(
                              leading: IconButton(icon: Icon(Icons.favorite,color: Colors.red,size: 60,),
                                  onPressed: ()=>favourateBox.put(index.toInt(),'dkjghkd')),
                              title: Column(
                                children: [
                                  Text(value,style: TextStyle(fontWeight: FontWeight.w800,),),
                                  ReadMoreText(
                                    value,
                                    trimLines: 2,
                                    colorClickableText: Colors.blue,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Read More',
                                    trimExpandedText: 'Show less',
                                    // moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              subtitle: Text(key.toString()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
          );
        },
      ),
    );
  }
}
