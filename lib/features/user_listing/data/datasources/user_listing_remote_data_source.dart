import 'dart:convert';

import '../models/user_model.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';

abstract class UserListingRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> getSingleUser(int id);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<UserModel>> getUserList();
}

class UserListingRemoteDataSourceImpl implements UserListingRemoteDataSource {
  final http.Client client;

  UserListingRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> getSingleUser(int number) =>
      _getUserFromUrl('https://reqres.in/api/users/$number');

  @override
  Future<List<UserModel>> getUserList() =>
      _getUserListFromUrl('https://reqres.in/api/users');

  Future<UserModel> _getUserFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body)['data']);
    } else {
      throw ServerException();
    }
  }

  Future<List<UserModel>> _getUserListFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List fs = json.decode(response.body)['data'];

      final List<UserModel> us = fs.map((e) => UserModel.fromJson(e)).toList();

      return us;
    } else {
      throw ServerException();
    }
  }
}
