// ignore_for_file: use_key_in_widget_constructors, avoid_print, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:robotek/home.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'Commons/Constants.dart';
import 'mobile.dart' if (dart.library.html) 'web.dart';

class CustomDialogBox extends StatefulWidget {
  final dynamic title, descriptions, text, cartdata, userid;

  const CustomDialogBox(
      {required this.title,
      required this.descriptions,
      required this.text,
      required this.cartdata,
      required this.userid});

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  int number = 0;
  bool value = false;
  bool value2 = false;

  void convertImage() {
    print("Image");
  }

  void convertPdf({cartdata}) async {
    PdfDocument document = PdfDocument();
    // final page = document.pages.add();

    // page.graphics.drawString(
    //     'Your Order Details', PdfStandardFont(PdfFontFamily.helvetica, 30));

    PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
      font: PdfStandardFont(PdfFontFamily.helvetica, 30),
      cellPadding: PdfPaddings(
        left: 5,
        right: 2,
        top: 2,
        bottom: 2,
      ),
    );

    grid.columns.add(count: 3);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Category Name';
    header.cells[1].value = 'Product Name';
    header.cells[2].value = 'Quantity';

    for (var item in cartdata) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = item['category_name'];
      row.cells[1].value = item['product_name'];
      row.cells[2].value = item['qty'];
      // row = grid.rows.add();
    }
    grid.draw(
      page: document.pages.add(),
      bounds: const Rect.fromLTWH(0, 0, 0, 0),
    );

    List<int> bytes = document.save();
    document.dispose();

    saveAndLaunchFile(bytes, 'Output.pdf');
  }

  @override
  void initState() {
    print(widget.cartdata);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: contentBox(context),
      ),
    );
  }

  contentBox(context) {
    return SizedBox(
      width: 300,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: Constants.padding,
                top: 20 + Constants.padding,
                right: Constants.padding,
                bottom: Constants.padding),
            margin: EdgeInsets.only(top: Constants.avatarRadius),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(Constants.padding),
                // ignore: prefer_const_literals_to_create_immutables
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  "assets/ConvertJPGToPDF.png",
                  height: 100,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Title",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 280,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
                                // changes position of shadow
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Center(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                var number = value.toString();
                              },
                            ),
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Format",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: value,
                          onChanged: (val) {
                            setState(() {
                              value = val!;
                            });
                            value == true
                                ? convertPdf(cartdata: widget.cartdata)
                                : null;
                          },
                        ),
                        Text("PDF"),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: value2,
                          onChanged: (val) {
                            setState(() {
                              value2 = val!;
                            });
                            value2 == true ? convertImage() : null;
                          },
                        ),
                        Text("Image"),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.deepPurpleAccent, fontSize: 20),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Home(dealerdetails: widget.userid),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(
                            color: Colors.deepPurpleAccent, fontSize: 20),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
