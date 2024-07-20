
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_moving_screen/login/provider/login_provider.dart';
import 'package:flutter_moving_screen/login/sign_up_screen.dart';
import 'package:flutter_moving_screen/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // 사용자에게 입력 받을 값
  TextEditingController emailTextController = TextEditingController();
  TextEditingController pwTextController = TextEditingController();

  // 사용자가 입력한 값이 Auth에 있는지 확인하는 로직
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print(e.toString());
      } else if (e.code == "wrong-password") {
        print(e.toString());
      }
    } catch (e) {
      print(e.toString());
    }
    return null; // 에러 발생 시 null 반환
  }

  //구글 로그인 구현
  Future<UserCredential?> signInWithGoogle() async{
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/bm_logo.png"),
                Text(
                  "패캠 마트",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 42,
                  ),
                ),
                SizedBox(height: 64),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailTextController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "이메일",
                        ),
                        // 사용자가 만약 값을 입력하지 않는다면?
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "이메일 주소를 입력하세요";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      TextFormField(
                        controller: pwTextController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "비밀번호",
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "비밀번호를 입력하세요";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: Consumer(
                    builder: (context, ref, child) {
                      return MaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            final result = await signIn(
                              emailTextController.text.trim(),
                              pwTextController.text.trim(),
                            );
                            if (result != null) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("로그인 성공")),
                                );
                                ref.watch(userCredentialProvider.notifier).state = result;
                                context.go("/");
                              }
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("로그인 실패")),
                                );
                              }
                            }
                          }
                        },
                        height: 48,
                        minWidth: double.infinity,
                        color: Colors.red,
                        child: Text(
                          "로그인",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                  ),
                ),
                TextButton(
                  onPressed: () => context.push("/sign_up"),
                  child: Text("계정이 없나요? 회원가입"),
                ),
                Divider(),
                InkWell(
                  onTap: () async{
                    final userCredit = await signInWithGoogle();

                    if (userCredit == null) {
                      return;
                    }else{
                      context.go("/");
                    }
                  },
                    child: Image.asset("assets/google_login.png")
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
