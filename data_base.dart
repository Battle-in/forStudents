import 'package:mysql1/mysql1.dart';
import 'user.dart';
import 'product.dart';

class DataBase{
  static var con;

  static void init() async {
    con = await MySqlConnection.connect(
      ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        db: 'forstd'
      )
    );
    await con.query("CREATE TABLE if not EXISTS 'users' ('login' VARCHAR(30) UNIQUE,"
        " 'password' VARCHAR(30))");
    await con.query("CREATE TABLE if not EXISTS 'products' ('url' VARCHAR(60),"
        " 'title' VARCHAR(30), 'description' VARCHAR(240), 'price' INTEGER)");
  }

  static Future<List<Product>> getProducts() async {
    var res = <Product>[];
    var resDB = await con.query("SELECT * FROM 'products'");
    for(var req in resDB){
      res.add(Product(req[0], req[1], req[2]));
    }
    return res;
  }

  static Future<User> getUserByLogin(String login) async {
    var res = await con.query("SELECT * FORM 'users' WHERE 'login' = '$login'");
    return User(res[0], res[1]);
  }
}