// import 'package:flutter/material.dart';

// import '../../constants.dart';

// class CameoDetailShimmer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width / 1.5,
//                 child: Text(
//                   widget.title,
//                   style: kSeactionTitle,
//                 ),
//               ),
//               Text("see all", style: kSeeAllStyle),
//             ],
//           ),
//         ),
//         Container(
//             margin: EdgeInsets.only(top: 10),
//             height: 280,
//             child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: 2,
//                 itemBuilder: (context, index) => CustomCard(
//                       name: widget.cardItems[index]["title"],
//                       position: widget.cardItems[index]["gig_details"],
//                       url: '$domainUrl/${widget.cardItems[index]["gig_image"]}',
//                       price: widget.cardItems[index]["gig_price"],
//                       id: widget.cardItems[index]["id"],
//                     )))
//       ],
//     );
//   }
// }
