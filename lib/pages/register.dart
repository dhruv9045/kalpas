import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task1/api/api_service.dart';
import 'package:task1/constant/constants.dart';
import 'package:task1/model/register_model.dart';

import '../ProgressHUD.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  RegisterRequestModel registerRequestModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    registerRequestModel = new RegisterRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.red,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              height:100,
              child: Align(
                alignment: Alignment.center,
                child:Text("WELCOME!!",style: TextStyle(
                    fontSize: 30,color: Colors.white,fontWeight: FontWeight.w700),),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0)),
                color: Colors.white.withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.2),
                      offset: Offset(0, 10),
                      blurRadius: 20)
                ],
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: globalFormKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 25),
                      Text(
                        "Sign up",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 35),
                      new TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (input) => registerRequestModel.email = input,
                        validator: (input) => !input.contains('@')
                            ? "Email Id should be valid"
                            : null,
                        decoration: new InputDecoration(
                          hintText: "Email Address",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                              borderSide: BorderSide(
                                  color: Colors.black
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),

                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      new TextFormField(
                        style:
                        TextStyle(color: Theme.of(context).accentColor),
                        keyboardType: TextInputType.text,
                        onSaved: (input) =>
                        registerRequestModel.password = input,
                        validator: (input) => input.length < 3
                            ? "Password should be more than 3 characters"
                            : null,
                        obscureText: hidePassword,
                        decoration: new InputDecoration(
                          hintText: "Password",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                              borderSide: BorderSide(
                                  color: Colors.black
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).accentColor,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            color: Theme.of(context)
                                .accentColor
                                .withOpacity(0.4),
                            icon: Icon(hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      new TextFormField(
                        style:
                        TextStyle(color: Theme.of(context).accentColor),
                        keyboardType: TextInputType.text,
                        onSaved: (input) =>
                        registerRequestModel.password = input,
                        validator: (input) => input.length < 3
                            ? "Password should be more than 3 characters"
                            : null,
                        obscureText: hidePassword,
                        decoration: new InputDecoration(
                          hintText: "Confirm Password",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                              borderSide: BorderSide(
                                  color: Colors.black
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor)),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).accentColor,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            color: Theme.of(context)
                                .accentColor
                                .withOpacity(0.4),
                            icon: Icon(hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      FlatButton(
                        padding: EdgeInsets.symmetric(
                            vertical: 12, horizontal: 80),
                        onPressed: () {
                          if (validateAndSave()) {
                            print(registerRequestModel.toJson());

                            setState(() {
                              isApiCallProcess = true;
                            });

                            APIService apiService = new APIService();
                            apiService.register(registerRequestModel).then((value) {
                              if (value != null) {
                                setState(() {
                                  isApiCallProcess = false;
                                });

                                if (value.token.isNotEmpty) {
                                  final snackBar = SnackBar(
                                      content: Text("Register Successful"));
                                  scaffoldKey.currentState
                                      .showSnackBar(snackBar);
                                } else {
                                  final snackBar =
                                  SnackBar(content: Text(value.error));
                                  scaffoldKey.currentState
                                      .showSnackBar(snackBar);
                                }
                              }
                            });
                          }
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Theme.of(context).accentColor,
                        shape: StadiumBorder(),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? "),
                          InkWell(
                            child: Text("Sign in",style: TextStyle(color: Colors.deepOrange),),
                            onTap: ()=>Navigator.pushNamed(context, home),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
