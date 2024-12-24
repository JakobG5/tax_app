import 'package:hive/hive.dart';

abstract class UserLocalStorage {
  Future<void> saveUserCredentials(String email, String password);
  Future<Map<String, dynamic>?> getUserCredentials();
  Future<bool> isEmailTaken(String email);
  Future<List<Map<String, dynamic>>> getAllUsers();
  Future<void> put(String key, dynamic value);
  Future<bool> isSignedIn();
  Future<void> signOut();
  Future<void> saveCompanyData(Map<String, dynamic> companyData);
  Future<List<Map<String, dynamic>>> getCompanyData(String email);
}

class HiveUserStorage implements UserLocalStorage {
  final Box _userBox;
  static const String _usersListKey = 'users_list';
  static const String _companiesListKey = 'companies_list';

  HiveUserStorage(this._userBox);

  @override
  Future<void> saveUserCredentials(String email, String password) async {
    List<Map<String, dynamic>> users = await getAllUsers();
    users.add({
      'email': email,
      'password': password,
    });
    await _userBox.put(_usersListKey, users);
  }

  @override
  Future<Map<String, dynamic>?> getUserCredentials() async {
    final users = await getAllUsers();
    return users.isNotEmpty ? Map<String, dynamic>.from(users.last) : null;
  }

  @override
  Future<bool> isEmailTaken(String email) async {
    final users = await getAllUsers();
    return users.any((user) => user['email'] == email);
  }

  @override
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final usersList =
        _userBox.get(_usersListKey, defaultValue: <Map<String, dynamic>>[]);
    return List<Map<String, dynamic>>.from(
        usersList.map((user) => Map<String, dynamic>.from(user)));
  }

  @override
  Future<void> put(String key, dynamic value) async {
    await _userBox.put(key, value);
  }

  @override
  Future<bool> isSignedIn() async {
    return _userBox.get('isSignedIn', defaultValue: false);
  }

  @override
  Future<void> signOut() async {
    await _userBox.put('isSignedIn', false);
  }

  @override
  Future<void> saveCompanyData(Map<String, dynamic> companyData) async {
    List<Map<String, dynamic>> companies = await getAllCompanies();
    companies.add(companyData);
    await _userBox.put(_companiesListKey, companies);
  }

  @override
  Future<List<Map<String, dynamic>>> getCompanyData(String email) async {
    final companies = await getAllCompanies();
    return companies.where((company) => company['createdBy'] == email).toList();
  }

  Future<List<Map<String, dynamic>>> getAllCompanies() async {
    final companiesList =
        _userBox.get(_companiesListKey, defaultValue: <Map<String, dynamic>>[]);
    return List<Map<String, dynamic>>.from(
        companiesList.map((company) => Map<String, dynamic>.from(company)));
  }
}
