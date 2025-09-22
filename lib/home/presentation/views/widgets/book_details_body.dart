import 'package:code_books/home/domain/entities/book_entity.dart';
import 'package:code_books/home/presentation/views/widgets/book_details_item.dart';
import 'package:flutter/material.dart';
import 'sugination_book.dart';

class BookDetailsBody extends StatelessWidget {
  const BookDetailsBody({super.key, required this.book});
  final BookEntity book;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookDetailsItem(book: book),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SuginationBook(),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
