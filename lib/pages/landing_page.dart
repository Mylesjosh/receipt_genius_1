import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:receipt_genius/pages/select_page.dart';

import '../auth/login_or_register.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.background,
        child: ListView(
          children: [Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 70.h,),
              Center(child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Image.asset("lib/images/landing.png"),
              ),),
              SizedBox(height: 25.h,),

              Text("ReceiptGenius",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize:  34.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        inherit: false
                    ),
                ),
              ),
              SizedBox(height: 2.h),

              Text("Generate Receipts, Store For Customers.",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize:  15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      inherit: false,

                  ),
                ),
              ),
              SizedBox(height: 35.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple[300],
                  borderRadius: BorderRadius.circular(8.0.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 1, // Spread radius
                      blurRadius: 7, // Blur radius
                      offset: Offset(-1, 2), // Changes position of shadow
                    ),
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: (){
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(
                                builder: (context) => SelectPage()
                            ));
                      },
                      icon: Icon(Icons.navigate_next_rounded),
                    color: Colors.white,
                  ),
                ),
              )

            ],
          ),]
        ),
      );
  }
}
