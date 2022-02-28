import 'package:flutter/material.dart';
import 'package:shopkite_demo/models/user.dart';
import 'package:shopkite_demo/services/api_service.dart';
import 'package:shopkite_demo/services/service_locator.dart';

class ApiDemo extends StatefulWidget {
  const ApiDemo({Key? key}) : super(key: key);

  @override
  _ApiDemoState createState() => _ApiDemoState();
}

class _ApiDemoState extends State<ApiDemo> {
  final ApiService apiService = serviceLocator<ApiService>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool signedIn = false;
  late Future<User> currentUser;

  bool _isValidEmail(String email) {
    RegExp matcher =
        RegExp("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}");
    return matcher.hasMatch(email);
  }

  void doLogin(String email, String password) async {
    setState(() {
      currentUser = apiService.getUser(email, password);
      signedIn = true;
    });
  }

  Widget loginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email Address", //babel text
                hintText: "Input Email", //hint text
                prefixIcon: Icon(Icons.people), //prefix iocn
                hintStyle: TextStyle(
                  fontSize: 17,
                ), //hint text style
                labelStyle: TextStyle(
                    fontSize: 17, color: Colors.deepOrangeAccent), //label style
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address!';
                } else if (!_isValidEmail(value)) {
                  return 'Input is not a valid email address';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password", //babel text
                hintText: "Input Password", //hint text
                prefixIcon: Icon(Icons.lock), //prefix iocn
                hintStyle: TextStyle(
                  fontSize: 17,
                ), //hint text style
                labelStyle: TextStyle(
                    fontSize: 17, color: Colors.deepOrangeAccent), //label style
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password!';
                } else if (value.length < 8) {
                  return 'Passwords must be greater than or equal to 8 characters!';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  doLogin(_emailController.text, _passwordController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signing you in...')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              child: const Text('Demo Signup'),
              onPressed: () {
                setState(() {
                  currentUser = apiService.createDemoUser();
                  signedIn = true;
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Widget userDetails() {
    return FutureBuilder(
      future: currentUser,
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Column(
              children: <Widget>[
                const Text(
                  'User Details',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  'Full Name: ${snapshot.data!.name}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  'Username: ${snapshot.data!.username}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  'Email Address: ${snapshot.data!.email}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  'Phone Number: ${snapshot.data!.phone}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        signedIn = false;
                      });
                    },
                    child: const Text('Sign out'))
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Api Demo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              (signedIn ? 'Signed In' : 'Please Sign In Below'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: (signedIn ? Colors.green : Colors.red),
              ),
            ),
          ),
          Center(
            child: (signedIn ? userDetails() : loginForm()),
          )
        ],
      ),
    );
  }
}
