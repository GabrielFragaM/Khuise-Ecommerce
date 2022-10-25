
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lojas_khuise/constants/app_constants.dart';
import 'package:lojas_khuise/constants/style.dart';
import 'package:lojas_khuise/services/auth_service.dart';
import 'package:lojas_khuise/widgets/custom_text.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

import 'authentication.dart';

class Create_Account_Screen extends StatefulWidget {
  const Create_Account_Screen({Key key}) : super(key: key);

  @override
  Create_Account_Screen_State createState() => Create_Account_Screen_State();
}

class Create_Account_Screen_State extends State<Create_Account_Screen>{

  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  final phone = TextEditingController();

  var phoneFormater = new MaskTextInputFormatter(mask: '(##) # ####-####', filter: { "#": RegExp(r'[0-9]') });

  bool is_loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isObscure = true;

  create_account() async{
    try{
      await context.read<AuthService>().signup(email.text, senha.text, phone.text);
      setState(() {
        login_status = false;
      });
    }on AuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      setState(() {
        is_loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                    Text("Novo Cadastro",
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
                  controller: phone,
                  inputFormatters: [phoneFormater],
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
                      labelText: "Telefone",
                      hintText: "Telefone completo.",
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
                                  AuthenticationPage(
                                  )));
                    },
                    hoverColor: Color.fromRGBO(255, 255, 255, 0.0),
                    child: CustomText(
                      text: "Já possuí uma conta?",
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
                      await create_account();
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
                      text: "Cadastrar",
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
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}