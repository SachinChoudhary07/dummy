// pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskc/AuthProvider.dart';
import 'package:taskc/HomePage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In'),
      ),
      body: Center(
        child: authProvider.isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: () async {
            await authProvider.signInWithGoogle();
            if (authProvider.user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AddProductPage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to sign in with Google')),
              );
            }
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
