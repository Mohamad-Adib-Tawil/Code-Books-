import 'package:code_books/home/domain/entities/book_entity.dart';
import 'package:code_books/home/presentation/views/widgets/book_details_body.dart';
import 'package:flutter/material.dart';

import '../../../contants.dart';

class BoookDetailsView extends StatelessWidget {
  const BoookDetailsView({super.key, required this.book});

  final BookEntity book;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlackColor,
      body: BookDetailsBody(book: book),
    );
  }
}
