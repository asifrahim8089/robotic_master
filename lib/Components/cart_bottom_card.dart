// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:robotek/Providers/get_data_provider.dart';

// Widget cartBottomCard({String? name, onTap}) {
//   return SafeArea(
//     child: Consumer<GetDataProvider>(
//       builder: (context, data, child) {
//         return Row(
//           children: [
//             Expanded(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//                 child: Container(
//                   clipBehavior: Clip.antiAlias,
//                   height: 50,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.transparent),
//                   width: MediaQuery.of(context).size.width,
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.black,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       // ignore: prefer_const_literals_to_create_immutables
//                       children: [
//                         data.cartdata != null
//                             ? Text(
//                                 "${data.cartdata.length.toString()}\tItems",
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold),
//                               )
//                             : Text(
//                                 "0 Items",
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                         Text(
//                           "Review List",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     ),
 
//   );
// }
