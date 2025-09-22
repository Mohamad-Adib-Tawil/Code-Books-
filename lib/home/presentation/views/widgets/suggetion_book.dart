import 'dart:developer' as logg;
import 'dart:math';

import 'package:code_books/home/data/models/book_model/book_model.dart';
import 'package:code_books/home/domain/entities/book_entity.dart';
import 'package:code_books/home/presentation/views/widgets/book_rating.dart';
import 'package:code_books/home/presentation/views/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

import '../../../../contants.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class SuggetionBook extends StatefulWidget {
  const SuggetionBook({super.key});

  @override
  State<SuggetionBook> createState() => _SuggetionBookState();
}

class _SuggetionBookState extends State<SuggetionBook> {
  final String apiUrlBase =
      'https://www.googleapis.com/books/v1/volumes?Filtering=free-ebooks&q=programming&startIndex=';
  BookModel? randomBook;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRandomBook();
  }

  Future<void> fetchRandomBook() async {
    final randomPage =
        Random().nextInt(40) + 1; // Random number between 1 and 40
    final apiUrl = '$apiUrlBase$randomPage';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'];
      if (items != null && items.isNotEmpty) {
        final randomIndex = Random().nextInt(items.length);
        if (mounted) {
          setState(() {
            randomBook = BookModel.fromJson(items[randomIndex]);
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } else {
      throw Exception('Failed to load books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 210,
          width: double.infinity,
          decoration: const BoxDecoration(),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.only(left: 24, top: 24, right: 150),
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(29),
              color: kBlackColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 10),
                  blurRadius: 33,
                  color: const Color(0xFF313131).withOpacity(.84),
                ),
              ],
            ),
            child: isLoading
                ? const Center(child: SizedBox())
                : randomBook == null
                    ? const Center(child: Text('No books found'))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text.rich(
                            TextSpan(
                              style: const TextStyle(color: kWhiteColor),
                              children: [
                                TextSpan(
                                  text: "${randomBook!.title}\n",
                                  style: const TextStyle(fontSize: 15),
                                ),
                                TextSpan(
                                  text: randomBook!.authors.first,
                                  style: const TextStyle(color: kSliverColor),
                                ),
                              ],
                            ),
                            maxLines: 2, // Set maximum lines to 2
                            overflow: TextOverflow
                                .ellipsis, // Handle overflow with ellipsis
                          ),
                          const SizedBox(
                              height: 10), // Add spacing between text and row
                          Row(
                            children: <Widget>[
                              BookRating(
                                score: randomBook!.averageRating,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RoundedButton(
                                  color: kPrimaryColor,
                                  press: () {
                                    // Implement the functionality for the button
                                  },
                                  text: "Read",
                                  verticalPadding: 10,
                                ),
                              ),
                              const SizedBox(width: 4),
                            ],
                          )
                        ],
                      ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: SizedBox(
            height: 180,
            width: 120,
            child:
                randomBook != null && randomBook!.imageLinksThumbnail.isNotEmpty
                    ? Image.network(
                        randomBook!.imageLinksThumbnail,
                        width: 150,
                        fit: BoxFit.fitWidth,
                      )
                    : const SizedBox(),
          ),
        ),
      ],
    );
  }
}

// class SuggetionBook extends StatelessWidget {
//   const SuggetionBook({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           height: 200,
//           width: double.infinity,
//           decoration: const BoxDecoration(),
//         ),
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: Container(
//             padding: const EdgeInsets.only(left: 24, top: 24, right: 150),
//             height: 160,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(29),
//               color: kBlackColor,
//               boxShadow: [
//                 BoxShadow(
//                   offset: const Offset(0, 10),
//                   blurRadius: 33,
//                   color: const Color(0xFF313131).withOpacity(.84),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 RichText(
//                   text: const TextSpan(
//                     style: TextStyle(color: kWhiteColor),
//                     children: [
//                       TextSpan(
//                         text: "How To Win \nFriends & Influence \n",
//                         style: TextStyle(
//                           fontSize: 15,
//                         ),
//                       ),
//                       TextSpan(
//                         text: "Gary Venchuk",
//                         style: TextStyle(color: kWhiteColor),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Row(
//                   children: <Widget>[
//                     const BookRating(
//                       score: 4,
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: RoundedButton(
//                         color: kPrimaryColor,
//                         press: () {},
//                         text: "Read",
//                         verticalPadding: 10,
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 4,
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//         Positioned(
//             top: 0,
//             right: 0,
//             child: SizedBox(
//               height: 180,
//               width: 120,
//               child: Image.asset(
//                 kBookImageHarry,
//                 width: 150,
//                 fit: BoxFit.fitWidth,
//               ),
//               //  Container(),
//               // CustomBookImage(image: kBookImageHarry),
//             )
//             // Image.asset(
//             //   kBookImageHarry,
//             //   width: 150,
//             //   fit: BoxFit.fitWidth,
//             // ),
//             ),
//       ],
//     );
//   }
// }
