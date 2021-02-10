import 'package:flutter/material.dart';
import 'package:cameo/utils.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var btnStyle = TextStyle(color: Colors.white, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 650,
                    child: Image(
                      image: NetworkImage(
                          'https://images.unsplash.com/photo-1607081692245-419edffb5462?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 300, left: 220),
                    child: Container(
                      child: Image(
                        image: NetworkImage(
                            'https://images.unsplash.com/photo-1595986630530-969786b19b4d?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=375&q=80'),
                      ),
                      clipBehavior: Clip.hardEdge,
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  )
                ],
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.4,
            ),
            Expanded(
              child: Container(
                color: Colors.black87,
                child: Column(
                  children: [
                    height(15.0),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        'Welcome to ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        'WOW!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                    ]),
                    height(15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlineButton(
                          borderSide: BorderSide(color: Colors.yellow.shade800),
                          color: Colors.yellow.shade800,
                          onPressed: () =>
                              Navigator.pushNamed(context, '/signup'),
                          highlightedBorderColor: Colors.yellow.shade800,
                          disabledBorderColor: Colors.yellow.shade800,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Signup',
                              style: btnStyle.copyWith(
                                  color: Colors.yellow.shade800),
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/login'),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Login',
                              style: btnStyle,
                            ),
                          ),
                          color: Colors.yellow.shade800,
                        )
                      ],
                    ),
                    height(15.0),
                    Text(
                      'VIP Invite',
                      style: TextStyle(
                          color: Colors.yellow.shade800, fontSize: 22),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
