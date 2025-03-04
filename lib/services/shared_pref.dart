import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  static const String eMail = 'username';
  static const isLogged = 'isLogged';

  SharedPref._instantiate();
  static final SharedPref instance = SharedPref._instantiate();

  Future<bool> setEmail(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    try{
      await prefs.setString(eMail, value!);
      print("Email is set to local storage $value");
      return true;
    } catch (e) {
      print("Error $e");
      return false;
    }
  }

  Future<String?> getEmail() async{
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString(eMail);
    print("Email in shared prefs $email");
    return email;
  }

   Future<void> setName(String? name) async { 
    final prefs = await SharedPreferences.getInstance();
    if (name != null) {
      await prefs.setString('name', name);
    } else {
      await prefs.remove('name');
    }
  }

  Future<String?> getName() async { 
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  Future<bool> setLogged(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    try{
      await prefs.setBool(isLogged, value);
      print("Logged is set to local storage $value");
      return true;
    } catch (e) {
      print("Error $e");
      return false;
    }
  }

  Future<bool?> getLogged() async{
    final prefs = await SharedPreferences.getInstance();
    bool? logged = prefs.getBool(isLogged);
    print("Logged in shared prefs $logged");
    return logged;
  }
}