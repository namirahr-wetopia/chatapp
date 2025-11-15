import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wetopian_auth/features/auth/controllers/login_controller.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatelessWidget {
  final LoginController _loginCtrl = GetIt.I<LoginController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          Obx(() => _loginCtrl.isLoading.value
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent.shade400),
                  ),
                ),
              )
            : IconButton(
                onPressed: _loginCtrl.logoutFromUI,
                icon: Icon(Icons.logout),
                color: Colors.greenAccent.shade400,
                iconSize: 20,
              ),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 40,
              color: Colors.greenAccent,
            ),
            SizedBox(height: 10),
            Text(
              'You are successfully logged in',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}