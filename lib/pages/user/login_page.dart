import 'dart:convert';

import 'package:course_asset_management/config/app_constant.dart';
import 'package:course_asset_management/pages/asset/HomePage.dart';
import 'package:d_info/d_info.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final edtUsername = TextEditingController();
  final edtPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool login_success = false;

  void login(BuildContext context) async {
    bool isValid = formKey.currentState!.validate();
    if (isValid == true) {
      // tervalidasi
      Uri url = Uri.parse(
        '${AppConstant.URL}/login.php',
      );
      http.post(url, body: {
        'username': edtUsername.text,
        'password': edtPassword.text,
      }).then((response) {
        // final msg = response.body.toString().substring(29, 30);
        DMethod.printResponse(response);

        try {
          // print(response.body);
          Map resBody = json.decode(response.body);
          bool success = resBody['success'] ?? false;
          if (success) {
            DInfo.toastSuccess('Login Success');
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          } else {
            DInfo.toastError('Login Not Success');
          }
          // Rest of your code...
        } catch (e) {
          DInfo.toastError('Something Wrong');
          DMethod.printBasic(e.toString());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -60,
            left: -60,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Colors.purple[300],
            ),
          ),
          Positioned(
            bottom: -90,
            right: -60,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Colors.purple[300],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: Icon(
              Icons.scatter_plot,
              size: 90,
              color: Colors.purple[400],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppConstant.appName.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Colors.purple[700],
                        ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: edtUsername,
                    validator: (value) => value == '' ? "Don't empty" : null,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,
                      hintText: 'Username',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: edtPassword,
                    obscureText: true,
                    validator: (value) => value == '' ? "Don't empty" : null,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      login(context);
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
