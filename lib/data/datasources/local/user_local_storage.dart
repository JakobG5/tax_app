
import 'package:hive/hive.dart';

abstract class UserLocalStorage {
  Future<void> saveUserCredentials(String email, String password);
  Future<Map<String, dynamic>?> getUserCredentials();
  Future<bool> isEmailTaken(String email);
  Future<List<Map<String, dynamic>>> getAllUsers();
  Future<void> put(String key, dynamic value);
  Future<bool> isSignedIn();
  Future<void> signOut();
  Future<void> setIsSignedIn(bool isSignedIn);

  Future<void> saveCurrentEmail(String email);
  Future<String?> getCurrentEmail();

  Future<void> saveCompanyData(Map<String, dynamic> companyData);
  Future<List<Map<String, dynamic>>> getCompanyData(String email);
  Future<List<Map<String, dynamic>>> getAllCompanyData();

  Future<void> saveEmployeeData(Map<String, dynamic> employeeData);
  Future<List<Map<String, dynamic>>> getAllEmployeeData();
}

class HiveUserStorage implements UserLocalStorage {
  final Box _userBox;

  static const String _usersListKey = 'users_list';
  static const String _employeeListKey = 'employee_list';
  static const String _companyListKey = 'company_list';
  static const String _currentEmailKey = 'current_email';
  static const String _userProfileKey = 'user_profile';

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
    return List<Map<String, dynamic>>.from(usersList.map((user) => Map<String, dynamic>.from(user)));
  }

  @override
  Future<void> saveEmployeeData(Map<String, dynamic> employeeData) async {
    List<Map<String, dynamic>> employees = await getAllEmployeeData();
    employees.add(employeeData);
    await _userBox.put(_employeeListKey, employees);
  }

  @override
  Future<List<Map<String, dynamic>>> getAllEmployeeData() async {
    final employeeList =
        _userBox.get(_employeeListKey, defaultValue: <Map<String, dynamic>>[]);
    return List<Map<String, dynamic>>.from(employeeList.map((employee) => Map<String, dynamic>.from(employee)));
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
  Future<void> setIsSignedIn(bool isSignedIn) async {
    await _userBox.put('isSignedIn', isSignedIn);
  }

  @override
  Future<void> saveCurrentEmail(String email) async {
    await _userBox.put(_currentEmailKey, email);
  }

  @override
  Future<String?> getCurrentEmail() async {
    return _userBox.get(_currentEmailKey, defaultValue: null);
  }

  @override
  Future<void> saveCompanyData(Map<String, dynamic> companyData) async {
    try {
      List<Map<String, dynamic>> companies = await getAllCompanyData();
      companies.add(Map<String, dynamic>.from(companyData));
      await _userBox.put(_companyListKey, companies);
    } catch (e) {
      print('Error saving company data: $e');
      throw Exception('Failed to save company data: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCompanyData(String email) async {
    try {
      final companies = await getAllCompanyData();
      final matchingCompanies = companies.where((company) {
        final createdBy = company['createdBy']?.toString();
        return createdBy == email;
      }).toList();
      
      print('Found ${matchingCompanies.length} companies for email: $email'); // Debug log
      return matchingCompanies;
    } catch (e) {
      print('Error getting company data for email $email: $e');
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllCompanyData() async {
    try {
      final rawData = _userBox.get(_companyListKey);
      if (rawData == null) return [];

      final companies = rawData as List;
      return companies.map((item) {
        if (item is Map) {
          return Map<String, dynamic>.from(item);
        }
        throw Exception('Invalid data format in storage');
      }).toList();
    } catch (e) {
      print('Error getting company data: $e');
      return [];
    }
  }

  @override
  Future<void> saveUserProfile(String email, Map<String, dynamic> profileData) async {
    await _userBox.put('$email$_userProfileKey', profileData);
  }

  @override
  Future<Map<String, dynamic>?> getUserProfile(String email) async {
    return _userBox.get('$email$_userProfileKey');
  }
}