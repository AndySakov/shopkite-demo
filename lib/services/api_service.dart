import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shopkite_demo/models/user.dart';

class ApiService {
  ApiService._privateConstructor();

  static final ApiService instance = ApiService._privateConstructor();

  final _url = 'https://jsonplaceholder.typicode.com/users/';

  Future<User> getUser(String email, String password) async {
    final res = await http.get(Uri.parse(_url + '1'));
    final user = userFromJson(res.body);
    if (user.email == email && password == 'password123') {
      return user;
    } else {
      final res1 = await http.get(Uri.parse(_url + '2'));
      final user2 = userFromJson(res1.body);
      return user2;
    }
  }

  Future<User> createDemoUser() async {
    final _demoUser = User(
      id: 1,
      name: "Damola Ogunbambo",
      username: 'mosky123',
      email: 'idontknowit123@gmail.com',
      address: Address(
        city: 'Lagos',
        street: 'Omotunde Akinsola, Omole',
        suite: 'Plot 480b',
        zipcode: '101233',
        geo: Geo(lat: '3.3608126', lng: '6.631414'),
      ),
      phone: '+234 567 890 1234',
      website: 'https://shopkite.com.ng',
      company: Company(
          name: 'Shopkite Merchant',
          catchPhrase: 'Let\'s do business!',
          bs: '...'),
    );
    final response = await http.post(Uri.parse(_url),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: userToJson(_demoUser));
    return userFromJson(response.body);
  }
}
