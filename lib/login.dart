import "dart:async";

import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_news_app/news_page.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool invisible = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) {
    var email = emailController.text;
    var password = passwordController.text;

    var data = {
      "email": email,
      "password": password,
    };
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               SizedBox(height: 50,),
                Image.asset(
                  "assets/vector.jpg",
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: 10,
                ),

                // Form Section Login
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0xFF36454F),
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Selamat Datang ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0xFF696F79),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Email",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xFF696F79),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty || value == "") {
                                return "Email harus di isi!";
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Mohon masukkan email yang valid!';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFFCFDFE),
                              hintText: "Masukan Email Anda",
                              hintStyle: const TextStyle(
                                color: Color(0xFF696F79),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: const Icon(Icons.email_outlined),
                              isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(15, 30, 15, 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide:
                                const BorderSide(width: 1, color: Color(0xFFDEDEDE)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                const BorderSide(width: 1, color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Password",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xFF696F79),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: invisible,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty || value == "") {
                                return "Password harus di isi!";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFFCFDFE),
                              hintText: "Masukan Password Anda",
                              hintStyle: const TextStyle(
                                color: Color(0xFF696F79),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon((invisible == true)
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    invisible = !invisible;
                                  });
                                },
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(15, 30, 15, 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide:
                                const BorderSide(width: 1, color: Color(0xFFDEDEDE)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                const BorderSide(width: 1, color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      "Lupa Password?",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFF2FA4D9),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
Navigator.push(context, MaterialPageRoute(builder: (ctx)=> NewsPage()));
                        // login(context);
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2FA4D9),
                    ),
                    child: const Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFF6F7FB),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Belum punya akun? ",
                        style: TextStyle(
                          color: Color(0xFF374253),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Daftar',
                        style: TextStyle(
                          color: Color(0xFF2FA4D9),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Move Page Ke SignUpPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NewsPage(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
