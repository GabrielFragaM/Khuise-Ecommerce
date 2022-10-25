
import 'package:flutter/material.dart';


class Loading_Products extends StatefulWidget {

  @override
  Loading_Products_State createState() =>
      Loading_Products_State();
}

class Loading_Products_State extends State<Loading_Products> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.stretch,
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.category,
              size: 96.0,
              color: Colors.black,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Buscando produtos...",
              style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.black,
                  fontWeight:
                  FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16.0,
            ),
          ],
        ),
      ),
    );
  }

}