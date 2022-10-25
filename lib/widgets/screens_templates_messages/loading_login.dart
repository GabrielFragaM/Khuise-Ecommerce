
import 'package:flutter/material.dart';


class Loading_Login extends StatefulWidget {

  @override
  Loading_Login_State createState() =>
      Loading_Login_State();
}

class Loading_Login_State extends State<Loading_Login> {


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
              Icons.account_circle_outlined,
              size: 96.0,
              color: Colors.black,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Acessando sua conta...",
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