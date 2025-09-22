// import 'package:code_books/home/domain/entities/book_entity.dart';
// import 'package:code_books/home/presentation/manger/popular_books_cubit/cubit/popular_books_cubit_cubit.dart';
// import 'package:code_books/home/presentation/views/widgets/book_list_item.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:code_books/home/domain/entities/book_entity.dart';
import 'package:code_books/home/presentation/manger/FetchNewestBooksCubit/fetch_newest_books_cubit.dart';
import 'package:code_books/home/presentation/manger/popular_books_cubit/cubit/popular_books_cubit_cubit.dart';
import 'package:code_books/home/presentation/views/widgets/book_list_item.dart';
import 'package:code_books/home/presentation/views/widgets/book_pagianation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResumeBookPaginationListView extends StatefulWidget {
  const ResumeBookPaginationListView({
    super.key,
  });

  @override
  State<ResumeBookPaginationListView> createState() =>
      _ResumeBookListViewState();
}

class _ResumeBookListViewState extends State<ResumeBookPaginationListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return NotificationListener<ScrollNotification>(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 20,
        itemBuilder: (context, index) {
          return SizedBox(
            height: size.height * 0.15,
            child: const BookPaginationListItem(),
          );
        },
      ),
    );
  }
}
