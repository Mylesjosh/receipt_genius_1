import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:receipt_genius/auth/auth_placement.dart';
import 'package:receipt_genius/components/my_button.dart';
import 'package:receipt_genius/components/texts.dart';

class SelectPage extends StatelessWidget {
   SelectPage({super.key});

  bool isbusiness = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        color:Theme.of(context).colorScheme.background,
        child: ListView(
          children: [Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Image.asset("lib/images/select.png"),
              ),

              SizedBox(height: 25.h,),

              Text("Manage Your Receipts",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize:  23.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    inherit: false,

                  ),
                ),
              ),
              SizedBox(height: 10.h,),
              Text("Get Started!",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize:  18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    inherit: false,

                  ),
                ),
              ),

              SizedBox(height:30.h,),

              /*GestureDetector(
                onTap: (){
                  isbusiness = false;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPlacement(isBusiness: isbusiness)));
                },
                child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                      color: Colors.deepPurple[400],
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      "User?",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          inherit: false
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 5.h,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Texts(text: "Or",
                          colour: Theme.of(context).colorScheme.primary,
                          fontsize: 15,
                          fontweight: FontWeight.normal),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),*/

              SizedBox(height: 5.h,),

              GestureDetector(
                onTap: (){isbusiness = true;
                Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPlacement(isBusiness: isbusiness)));},
                child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Center(
                    child: Text(
                      "Register Your Business!",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          inherit: false
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),]
        ),
      );
  }
}
