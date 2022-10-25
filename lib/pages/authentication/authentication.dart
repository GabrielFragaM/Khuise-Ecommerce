import 'dart:html';

import 'package:lojas_khuise/constants/app_constants.dart';
import 'package:lojas_khuise/pages/authentication/create_account.dart';
import 'package:flutter/material.dart';
import 'package:lojas_khuise/constants/style.dart';
import 'package:lojas_khuise/services/auth_service.dart';
import 'package:lojas_khuise/widgets/custom_text.dart';
import 'package:lojas_khuise/widgets/screens_templates_messages/loading_login.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key key}) : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>{

  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();

  bool is_loading = false;

  bool _isObscure = true;

  login() async{
    try{
      await context.read<AuthService>().login(email.text, senha.text);
    }on AuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      setState(() {
        is_loading = false;
      });
    }
  }

  loginLocal(email, password) async{
    try{
      await context.read<AuthService>().login(email, password);
      setState(() {
        login_status = false;
      });
    }on AuthException catch(e){
      setState(() {
        login_status = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget LoginWidget = Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset("assets/icons/logo.png", height: 100, width: 100,fit: BoxFit.fill,),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text("Entrar",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    CustomText(
                      text: "Lojas Khuise",
                      color: lightGrey,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: email,
                  validator: (value){
                    bool emailValidator = EmailValidator.validate(value);
                    if(!emailValidator){
                      setState(() {
                        is_loading = false;
                      });
                      return "Email inválido";
                    }
                    setState(() {
                      is_loading = false;
                    });
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "meu@email.com",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: senha,
                  obscureText: _isObscure,
                  validator: (value){
                    if(value.isEmpty){
                      setState(() {
                        is_loading = false;
                      });
                      return 'Obrigatório';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          hoverColor: Colors.transparent,
                          icon: Icon(
                              _isObscure ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          }),
                      labelText: "Senha",
                      hintText: "********",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () async {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    Create_Account_Screen(
                                    )));
                      },
                      hoverColor: Color.fromRGBO(255, 255, 255, 0.0),
                      child: CustomText(
                        text: "Ainda não tem um conta ?",
                        size: 14,
                        color: Colors.black,
                      ),
                    )
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () async {
                    if(formKey.currentState.validate()){
                      setState(() {
                        is_loading = true;
                      });
                      await login();
                      setState(() {
                        is_loading = false;
                      });
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(color: Colors.pink,
                          borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: is_loading == false ? CustomText(
                        text: "Acessar",
                        color: Colors.white,
                      ): SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                Create_Account_Screen(
                                )));
                  },
                  child: Container(
                      decoration: BoxDecoration(color: Colors.pink,
                          borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CustomText(
                        text: "Cadastrar",
                        color: Colors.white,
                      )
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if(login_status == true){
      try{
        final Storage _localStorage = window.localStorage;
        loginLocal(_localStorage['email'], _localStorage['password']);

        return Loading_Login();
      }catch(e){
        setState(() {
          login_status = false;
        });

        return LoginWidget;
      }
    }else{
      return LoginWidget;
    }
  }
}