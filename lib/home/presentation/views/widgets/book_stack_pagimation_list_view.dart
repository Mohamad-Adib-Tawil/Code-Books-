import 'package:code_books/home/domain/entities/book_entity.dart';
import 'package:code_books/home/presentation/manger/popular_books_cubit/cubit/popular_books_cubit_cubit.dart';
import 'package:code_books/home/presentation/views/widgets/book_stack__pagination_list_item.dart';
import 'package:code_books/home/presentation/views/widgets/book_stack_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookStackPAginationListView extends StatefulWidget {
  const BookStackPAginationListView({super.key});

  @override
  State<BookStackPAginationListView> createState() => _BookStackListViewState();
}

class _BookStackListViewState extends State<BookStackPAginationListView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child: ListView.separated(
        itemBuilder: (context, index) {
          return SizedBox(
              height: size.height * 0.15,
              child: const BookStackPaginationListItem());
        },
        itemCount: 20,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 20,
          );
        },
      ),
    );
  }
}
