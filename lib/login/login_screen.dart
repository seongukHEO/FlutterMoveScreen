
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  //사용자에게 입력 받을 값
  TextEditingController emailTextController = TextEditingController();
  TextEditingController pwTextController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/bm_logo.png"),
              Text("패캠 마트", style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 42,
              ),),
              SizedBox(height: 64,),
              Form(child: Column(
                key: _formKey,
                children: [
                  TextFormField(
                    controller: emailTextController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "이메일",
                    ),
                    //그니까 사용자가 만약에 값을 압력하지 않는다면?
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return "이메일 주소를 입력하세요";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24,),
                  TextFormField(
                    controller: pwTextController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "비밀번호",
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return "비밀번호를 입력하세요";
                      }
                      return null;
                    },
                  ),
                ],
              )),
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: MaterialButton(
                    onPressed: (){},
                  height: 48,
                  minWidth: double.infinity,
                  color: Colors.red,
                  child: Text("로그인", style: TextStyle(color: Colors.white),),
                ),
              ),
              TextButton(
                  onPressed: (){},
                  child: Text("계정이 없나요? 회원가입")
              ),
              Divider(),
              Image.asset("assets/google_login.png"),
            ],
          ),
        ),
      ),
    );
  }
}
