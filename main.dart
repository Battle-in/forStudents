import 'package:mysql1/mysql1.dart';
import 'data_base.dart';
import 'user.dart';
import 'product.dart';
import 'dart:io';

void main()async{
  DataBase.init();
  String address = 'localhost';
  int port = 2228;
  var server = await HttpServer.bind(address, port);
  print("starting at: $address:$port");
  print("in browser: http://$address:$port");
  await for(var req in server){
    print(req.uri);
    var answ = URLparser(req.uri.toString());
    req.response.write(answ.req);
    req.response.close();
  }
}

class URLparser{

  String req;

  URLparser(String str){
    if(str.contains("/login/")){
      loginUser(str);
    } else if (str.contains('/products/')){
      products(str);
    }
  }

  Future<void> products(str) async {
    var products = await DataBase.getProducts();
    String res = "{products: [";
    for(Product product in products){
      res += product.toString() + ',';
    }
    req = res + ']}';
  }

  Future<void> loginUser(String str) async {
    str = str.replaceAll('/login/', '');
    var params = str.split('&');

    User inpUser = User.clear();
    for(var param in params){
      if(param.contains('l=')){
        inpUser.login = param.replaceAll('l=', '').replaceAll("'", '');
      } else {
        inpUser.password = param.replaceAll('p=', '').replaceAll("'", '');
      }
    }
    User user = await DataBase.getUserByLogin(inpUser.login);
    if (user.password == inpUser.password){
      return user.toString();
    } else {
      req = '{error: "password don`t matches"}';
    }

    if(params.length != 2)
      req = "{error: 'more params as expected'}";
  }
}