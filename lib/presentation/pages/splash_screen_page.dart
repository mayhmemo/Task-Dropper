// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_dropper/presentation/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_dropper/presentation/pages/register_user_page.dart';

class SplashScreenPage extends StatefulWidget {
  SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> with SingleTickerProviderStateMixin {

  @override 
  void initState () {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed( Duration(seconds: 5), () async {
      WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => isFirstTime ? RegisterUserPage() : LoginPage(), 
        )
      );
    });
  }

  @override
  void dispose () {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual, overlays: SystemUiOverlay.values
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task,
              size: 80,
            ),
            SizedBox(height: 20),
            Text('Gerenciador de Tarefas', 
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 32
              ),
            )
          ],
        ),
      ),
    );

  }
}