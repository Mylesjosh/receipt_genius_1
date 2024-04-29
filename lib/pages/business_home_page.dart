import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:receipt_genius/components/texts.dart';
import 'package:receipt_genius/pages/receipt_page.dart';
import '../components/my_app_bar.dart';
import '../components/my_drawer.dart';
import 'receipt_database.dart';

class HomePage extends StatelessWidget {

  Map<String, List<String>> savedReceiptsUrlsByDate = {}; // Removed const
  // Constructor without const
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const MyAppBar(
        title: "H O M E",
        actions: [],
      ),
      drawer: const MyDrawer(),
      body: Column(
        children:[
          SizedBox(height: 10.h,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
            "Welcome to your business dashboard!",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize:  20.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
              inherit: false,)
            ),
            ),
          ),

          SizedBox(height: 20.h,),

        GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReceiptPage(
                  onSaveReceipt: (newsavedReceipts) {
                    savedReceiptsUrlsByDate = newsavedReceipts;
                  },
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(25),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 1, // Spread radius
                    blurRadius: 7, // Blur radius
                    offset: Offset(0,  1), // Changes position of shadow
                  ),
                ]
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Texts(
                        text: "Generate Receipt",
                        colour: Theme.of(context).colorScheme.inversePrimary,
                        fontsize: 20,
                        fontweight: FontWeight.normal),

                    SizedBox(height: 5.h,),

                    Texts(
                        text: "Generate unique receipts.",
                        colour: Theme.of(context).colorScheme.primary,
                        fontsize: 13,
                        fontweight: FontWeight.normal),
                  ],
                ),

                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 1, // Spread radius
                          blurRadius: 7, // Blur radius
                          offset: Offset(0, 1), // Changes position of shadow
                        ),
                      ]
                  ),
                  child: Image.asset("lib/images/receipt.png",
                    width: 60.w,
                    height: 60.h,
                  ),
                )


              ]
            ),
          ),
        ),

          SizedBox(height: 20.h,),

          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedReceiptsPage(savedReceiptsUrlsByDate),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(25),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 1, // Spread radius
                      blurRadius: 7, // Blur radius
                      offset: Offset(0, 1), // Changes position of shadow
                    ),
                  ]
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Texts(
                            text: "Customer's Database",
                            colour: Theme.of(context).colorScheme.inversePrimary,
                            fontsize: 20,
                            fontweight: FontWeight.normal),

                        SizedBox(height: 5.h,),

                        Texts(
                            text: "See all your receipts.",
                            colour: Theme.of(context).colorScheme.primary,
                            fontsize: 13,
                            fontweight: FontWeight.normal),

                      ],
                    ),

                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Shadow color
                              spreadRadius: 1, // Spread radius
                              blurRadius: 7, // Blur radius
                              offset: Offset(0, 1), // Changes position of shadow
                            ),
                          ]
                      ),
                      child: Image.asset("lib/images/database.png",
                        width: 60.w,
                        height: 60.h,
                      ),
                    )


                  ]
              ),
            ),
          ),

        ]
      ),
    );
  }
}
