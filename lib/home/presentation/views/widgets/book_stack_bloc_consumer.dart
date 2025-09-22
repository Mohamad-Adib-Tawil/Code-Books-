import 'package:code_books/core/utils/functions/build_error_snack_bar.dart';
import 'package:code_books/home/domain/entities/book_entity.dart';
import 'package:code_books/home/presentation/manger/popular_books_cubit/cubit/popular_books_cubit_cubit.dart';
import 'package:code_books/home/presentation/views/widgets/book_stack_list_view.dart';
import 'package:code_books/home/presentation/views/widgets/book_stack_pagimation_list_view.dart';
import 'package:code_books/contants.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookStackListBlocConsumer extends StatefulWidget {
  const BookStackListBlocConsumer({
    super.key,
  });

  @override
  State<BookStackListBlocConsumer> createState() =>
      _BookStackListBlocConsumerState();
}

class _BookStackListBlocConsumerState extends State<BookStackListBlocConsumer> {
  List<BookEntity> books = [];
  List<BookEntity> booksTrend = [];
  List<BookEntity> booksNewest = [];

  @override
  void initState() {
    super.initState();
    // Prefill UI from cache immediately when returning to HomeView
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadCachedLists();
    });
  }

  Future<void> _loadCachedLists() async {
    try {
      final popularBoxName = boxNameFor('popular', 'programming');
      final newestBoxName = boxNameFor('new', 'programming');
      final trendBoxName = boxNameFor('relevance', 'programming');

      final popularBox = Hive.isBoxOpen(popularBoxName)
          ? Hive.box<BookEntity>(popularBoxName)
          : await Hive.openBox<BookEntity>(popularBoxName);
      final newestBox = Hive.isBoxOpen(newestBoxName)
          ? Hive.box<BookEntity>(newestBoxName)
          : await Hive.openBox<BookEntity>(newestBoxName);
      final trendBox = Hive.isBoxOpen(trendBoxName)
          ? Hive.box<BookEntity>(trendBoxName)
          : await Hive.openBox<BookEntity>(trendBoxName);

      if (mounted) {
        setState(() {
          books = popularBox.values.toList();
          booksNewest = newestBox.values.toList();
          booksTrend = trendBox.values.toList();
        });
      }
    } catch (_) {
      // ignore cache load errors silently
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PopularBooksCubit, PopularBooksCubitState>(
      bloc: context.read<PopularBooksCubit>(),
      listener: (context, state) {
        if (state is PopularBooksSuccess) {
          if (mounted) {
            setState(() {
              books.addAll(state.books);
            });
          }
        } else if (state is PopularBooksNewest) {
          if (mounted) {
            setState(() {
              booksNewest.addAll(state.books);
            });
          }
        } else if (state is PopularBooksTrend) {
          if (mounted) {
            setState(() {
              booksTrend.addAll(state.books);
            });
          }
        } else if (state is PopularBooksPaginationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildErrorWidget(state.errMessage),
          );
        }
      },
      builder: (context, state) {
        if (state is PopularBooksLoading) {
          // If we already have cached items, keep showing them.
          if (books.isNotEmpty) {
            return BookStackListView(books: books);
          }
          if (booksNewest.isNotEmpty) {
            return BookStackListView(books: booksNewest);
          }
          if (booksTrend.isNotEmpty) {
            return BookStackListView(books: booksTrend);
          }
          return const BookStackPAginationListView();
        } else if (state is PopularBooksPaginationLoading) {
          // Keep showing accumulated list while next page loads
          return BookStackListView(books: books);
        } else if (state is PopularBooksSuccess) {
          return BookStackListView(books: books);
        } else if (state is PopularBooksNewest) {
          return BookStackListView(books: booksNewest);
        } else if (state is PopularBooksTrend) {
          return BookStackListView(books: booksTrend);
        } else if (state is PopularBooksFailure) {
          return Center(child: Text(state.errMessage));
        } else {
          return Container(); // Placeholder for an empty state
        }
      },
    );
  }
}
