// import 'package:code_books/home/domain/entities/book_entity.dart';
// import 'package:code_books/home/presentation/manger/ Newest_books_cubit/cubit/ Newest_books_cubit_cubit.dart';
// import 'package:code_books/home/presentation/views/widgets/resume_book_list_view.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:code_books/core/utils/functions/setup_service_locator.dart';
import 'package:code_books/home/data/repos_data/home_repo_impl.dart';
import 'package:code_books/home/domain/entities/book_entity.dart';
import 'package:code_books/home/domain/use_cases/fetch_newst_books_use_case.dart';
import 'package:code_books/home/presentation/manger/FetchNewestBooksCubit/fetch_newest_books_cubit.dart';
import 'package:code_books/home/presentation/views/widgets/resume_book_list_view.dart';
import 'package:code_books/home/presentation/views/widgets/resume_book_pagination_loading_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_books/core/utils/functions/build_error_snack_bar.dart';
import 'package:code_books/contants.dart';
import 'package:hive/hive.dart';

enum CurrentCategory { all, flutter, algorithms, javascript, python, php }

class ResumeBookListItemBlocConsumer extends StatefulWidget {
  const ResumeBookListItemBlocConsumer(
      {super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<ResumeBookListItemBlocConsumer> createState() =>
      _ResumeBookListItemBlocConsumerState();
}

class _ResumeBookListItemBlocConsumerState
    extends State<ResumeBookListItemBlocConsumer> {
  List<BookEntity> books = [];
  List<BookEntity> flutterBooks = [];
  List<BookEntity> algorithmsBooks = [];
  List<BookEntity> javaScriptBooks = [];
  List<BookEntity> pythonBooks = [];
  List<BookEntity> phpBooks = [];
  var nextPage = 1;
  var isLoading = false;

  CurrentCategory currentCategory = CurrentCategory.all;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
    // Prefill 'All' list from cache so it shows immediately when returning from Search
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadAllFromCache();
    });
  }

  Future<void> _loadAllFromCache() async {
    try {
      final allBoxName = boxNameFor('new', 'programming');
      final box = Hive.isBoxOpen(allBoxName)
          ? Hive.box<BookEntity>(allBoxName)
          : await Hive.openBox<BookEntity>(allBoxName);
      if (mounted && books.isEmpty && box.isNotEmpty) {
        setState(() {
          books = box.values.toList();
        });
      }
    } catch (_) {
      // ignore cache errors silently
    }
  }

  void _scrollListener() {
    if (widget.scrollController.position.pixels >=
        0.7 * widget.scrollController.position.maxScrollExtent) {
      if (!isLoading) {
        isLoading = true;
        final cubit = BlocProvider.of<FetchNewestBooksCubit>(context);
        Future<void> future = Future.value();
        switch (currentCategory) {
          case CurrentCategory.all:
            future = cubit.fetchNewestBooks(pageNumber: nextPage++).then((_) {});
            break;
          case CurrentCategory.flutter:
            future = cubit.toggleToFlutter(pageNumber: nextPage++);
            break;
          case CurrentCategory.algorithms:
            future = cubit.toggleToAlgorithms(pageNumber: nextPage++);
            break;
          case CurrentCategory.javascript:
            future = cubit.toggleToJavaScript(pageNumber: nextPage++);
            break;
          case CurrentCategory.python:
            future = cubit.toggleToPython(pageNumber: nextPage++);
            break;
          case CurrentCategory.php:
            future = cubit.toggleToPhp(pageNumber: nextPage++);
            break;
        }
        future.whenComplete(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FetchNewestBooksCubit, FetchNewestBooksState>(
      listener: (context, state) {
        if (state is NewestBooksSuccess) {
          if (mounted) {
            setState(() {
              if (currentCategory != CurrentCategory.all) {
                // switched category back to all; reset paging and list
                books = [];
                nextPage = 1;
              }
              currentCategory = CurrentCategory.all;
              books.addAll(state.books);
            });
          }
        } else if (state is FlutterBooks) {
          if (mounted) {
            setState(() {
              if (currentCategory != CurrentCategory.flutter) {
                flutterBooks = [];
                nextPage = 1;
              }
              currentCategory = CurrentCategory.flutter;
              flutterBooks.addAll(state.books);
            });
          }
        } else if (state is AlgorithmsBooks) {
          if (mounted) {
            setState(() {
              if (currentCategory != CurrentCategory.algorithms) {
                algorithmsBooks = [];
                nextPage = 1;
              }
              currentCategory = CurrentCategory.algorithms;
              algorithmsBooks.addAll(state.books);
            });
          }
        } else if (state is JavaScriptBooks) {
          if (mounted) {
            setState(() {
              if (currentCategory != CurrentCategory.javascript) {
                javaScriptBooks = [];
                nextPage = 1;
              }
              currentCategory = CurrentCategory.javascript;
              javaScriptBooks.addAll(state.books);
            });
          }
        } else if (state is PythonBooks) {
          if (mounted) {
            setState(() {
              if (currentCategory != CurrentCategory.python) {
                pythonBooks = [];
                nextPage = 1;
              }
              currentCategory = CurrentCategory.python;
              pythonBooks.addAll(state.books);
            });
          }
        } else if (state is PhpBooks) {
          if (mounted) {
            setState(() {
              if (currentCategory != CurrentCategory.php) {
                phpBooks = [];
                nextPage = 1;
              }
              currentCategory = CurrentCategory.php;
              phpBooks.addAll(state.books);
            });
          }
        } else if (state is NewestBooksFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildErrorWidget(state.errMessage),
          );
        } else if (state is NewestBooksPaginationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildErrorWidget(state.errMessage),
          );
        }
      },
      builder: (context, state) {
        if (state is NewestBooksLoading) {
          // If we already have cached 'All' items, keep showing them.
          if (books.isNotEmpty) {
            return ResumeBookListView(
              books: books,
              scrollController: widget.scrollController,
            );
          }
          return const ResumeBookPaginationListView();
        } else if (state is NewestBooksSuccess ||
            state is NewestBooksPaginationLoading) {
          return ResumeBookListView(
            books: books,
            scrollController: widget.scrollController,
          );
        } else if (state is FlutterBooks ||
            state is FlutterBooksPaginationLoading) {
          return ResumeBookListView(
            books: flutterBooks,
            scrollController: widget.scrollController,
          );
        } else if (state is AlgorithmsBooks ||
            state is AlgorithmsBooksPaginationLoading) {
          return ResumeBookListView(
            books: algorithmsBooks,
            scrollController: widget.scrollController,
          );
        } else if (state is JavaScriptBooks ||
            state is JavaScriptBooksPaginationLoading) {
          return ResumeBookListView(
            books: javaScriptBooks,
            scrollController: widget.scrollController,
          );
        } else if (state is PythonBooks ||
            state is PythonBooksPaginationLoading) {
          return ResumeBookListView(
            books: pythonBooks,
            scrollController: widget.scrollController,
          );
        } else if (state is PhpBooks || state is PhpBooksPaginationLoading) {
          return ResumeBookListView(
            books: phpBooks,
            scrollController: widget.scrollController,
          );
        } else if (state is NewestBooksFailure) {
          return Center(child: Text(state.errMessage));
        } else {
          // Initial/other states: show cached 'All' if available
          if (books.isNotEmpty) {
            return ResumeBookListView(
              books: books,
              scrollController: widget.scrollController,
            );
          }
          return const ResumeBookPaginationListView();
        }
      },
    );
  }
}
