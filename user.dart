class User{
  String login;
  String password;


  User(this.login, this.password);

  User.clear();

  @override
  String toString() {
    return '{login: $login, password: $password}';
  }
}