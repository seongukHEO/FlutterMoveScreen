import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  //여기서도 FormTextField를 사용할 것이고 이메일과 비번을 입력받을 것이다
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailTextController = TextEditingController();
  TextEditingController pwTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            children: [
              Text("패캠 마트\n가입을 환영합니다!", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
              SizedBox(height: 42,),
              Form(child: Column(
                key: _formKey,
                children: [
                  Column(
                    children: [
                      TextFormField(
                        controller: emailTextController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "이메일"
                        ),
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
                          labelText: "비밀번호"
                        ),
                        obscureText: true,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return "비밀번호를 입력하세요";
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                ],
              ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: MaterialButton(
                    onPressed: (){},
                  height: 48,
                  minWidth: double.infinity,
                  color: Colors.red,
                  child: Text("회원가입", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
