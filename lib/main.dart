import 'package:flutter/material.dart';
import 'package:week4/database/databaseqlite.dart';

import 'addstudent.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializedatabase();
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: screen1(),
    );
  }
}
