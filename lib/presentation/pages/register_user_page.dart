// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:task_dropper/data/datasources/local_source.dart';
import 'package:task_dropper/presentation/pages/login_page.dart';

class RegisterUserPage extends StatefulWidget {
  RegisterUserPage({super.key});

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  final LocalDataSource _localDataSource = LocalDataSource();

  TextEditingController _userController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _passwordInvisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            "OLÁ, VAMOS CADASTRAR SEU USUÁRIO",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Padding(
              padding: EdgeInsets.only(left: 3.0),
              child: SizedBox(
                child: TextField(
                  controller: _userController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      labelText: 'Usuário',
                      prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.person),
                    )),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Padding(
              padding: EdgeInsets.only(left: 3.0),
              child: SizedBox(
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    labelText: 'Email',
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.mail),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Padding(
              padding: EdgeInsets.only(left: 3.0),
              child: SizedBox(
                child: TextField(
                  obscureText: _passwordInvisible,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      labelText: 'Senha',
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.lock),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: IconButton(
                          icon: Icon(
                            _passwordInvisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordInvisible = !_passwordInvisible;
                            });
                          },
                        ),
                      )),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Container(
            width: double.infinity,
            height: 40.0,
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: () async {
                bool regiserUserSuccess = await _localDataSource.registerUser(
                    _userController.text,
                    _emailController.text,
                    _passwordController.text);

                if (regiserUserSuccess) {
                  final snackBar = SnackBar(
                      content: Text('Usuário registrado com sucesso!'),
                      backgroundColor: Colors.green);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  });
                } else {
                  final snackBar = SnackBar(
                      content: Text('Falha ao tentar registrar usuário!'),
                      backgroundColor: Colors.red);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                'Registrar',
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
