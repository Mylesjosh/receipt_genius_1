import 'package:flutter/material.dart';
import 'package:receipt_genius/pages/business_reg_page.dart';

import 'package:receipt_genius/pages/user_register_page.dart';

class AuthPlacement extends StatefulWidget {
  AuthPlacement({super.key, required this.isBusiness});
  bool isBusiness;

  @override
  State<AuthPlacement> createState() => _AuthPlacementState();
}

class _AuthPlacementState extends State<AuthPlacement> {
  void toggleReg (){
    setState(() {
      widget.isBusiness = !widget.isBusiness;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isBusiness){
      return BusinessRegisterPage(onTap: toggleReg,);
    }else {
      return UserRegisterPage(onTap: toggleReg,);
    }
  }
}

//class UserType (bool isBusiness) {
  //if you are a registering as a normal user then, reg page for user
