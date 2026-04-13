
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SplashScreen.dart';


class RoutingScreen extends StatelessWidget {
  const RoutingScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        routes: {
        }
    );
    }
    }

