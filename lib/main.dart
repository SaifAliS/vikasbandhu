import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "VikasBandhu",
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Main_page(),
    );
  }
}

class Main_page extends StatefulWidget {
  const Main_page({Key? key}) : super(key: key);

  @override
  State<Main_page> createState() => _Main_pageState();
}

class _Main_pageState extends State<Main_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VikasBandhu"),
        centerTitle: true,
      ),
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              ElevatedButton(
                onPressed: () {},
                child: Text('Record'),
                style: OutlinedButton.styleFrom(
                    shape: CircleBorder(), padding: EdgeInsets.all(37)),
              ),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                minLines: 2,
                maxLines: 5,
                decoration: InputDecoration(
                    labelText: "Translated Text",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.teal))),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Crop : ",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.teal))),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Quantity : ",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.teal))),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Units : ",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.teal))),
                    ),
                  ),
                ],
              ),SizedBox(height: 10,),
              Row(                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Action : ",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.teal))),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 70,),
              Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(onPressed: () {}, child: Text("Confirm")),
              ),
            
            ],
          ),
            ],
          ),
        ),
      ),
    );
  }
}
