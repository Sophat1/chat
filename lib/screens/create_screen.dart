import 'package:flutter/material.dart';
import 'package:flutter_chat/Home%20Pages/my_home_pages.dart';
import 'package:flutter_chat/auth/cotroller_auth/Methods.dart';

class CreateScreens extends StatefulWidget {
  const CreateScreens({Key? key}) : super(key: key);

  @override
  State<CreateScreens> createState() => _CreateScreensState();
}

class _CreateScreensState extends State<CreateScreens> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _conpasswordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: const CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              color: Colors.grey,
                            ),
                          ),
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(context);
                                });
                              },
                            ),
                          ),
                        ),
                        Container()
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  Container(
                    width: size.width / 1.1,
                    child: const Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.cyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width / 1.1,
                    child: Text(
                      "Create Account to Contiue!",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 18,
                      right: 18,
                      top: 18,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: const [
                              Text(
                                'Username : ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        inputField(
                          size,
                          "Name",
                          Icons.account_box,
                          _nameController,
                          false,
                        ),
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: const [
                              Text(
                                'Email : ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        inputField(
                          size,
                          "email",
                          Icons.account_box,
                          _emailController,
                          false,
                        ),
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: const [
                              Text(
                                'Password : ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        inputField(
                          size,
                          "password",
                          Icons.lock,
                          _passwordController,
                          true,
                        ),
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: const [
                              Text(
                                'Confirm Password : ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        inputField(
                          size,
                          "Name",
                          Icons.account_box,
                          _conpasswordController,
                          false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height / 20,
                  ),
                  customButton(size),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Have Accout ? |',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        child: const Text(
                          'SIGN IN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_nameController.text.isNotEmpty &&
            _emailController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          createAccount(_nameController.text, _emailController.text,
                  _passwordController.text)
              .then((user) {
            if (user != null) {
              setState(() {
                isLoading = false;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MyHomePage(),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(
                    'Account Created Sucessfull',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              );
              print("Account Created Sucessfull");
            } else {
              print("Login Failed");
              setState(
                () {
                  isLoading = false;
                },
              );
            }
          });
        } else {
          print("Please enter Fields");
        }
      },
      child: Container(
        height: size.height / 14,
        width: size.width / 1.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.cyan,
        ),
        alignment: Alignment.center,
        child: const Text(
          "Create Account",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget inputField(
    Size size,
    String hintText,
    IconData icon,
    TextEditingController valuecontroller,
    bool password,
  ) {
    return SizedBox(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextFormField(
        controller: valuecontroller,
        obscureText: password,
        style: const TextStyle(
          fontSize: 19.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 20,
          ),
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(28),
            ),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 2,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(28),
            ),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter Your Email and Password";
          }
          return null;
        },
      ),
    );
  }
}
