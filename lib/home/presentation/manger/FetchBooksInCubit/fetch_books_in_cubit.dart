import 'package:bloc/bloc.dart';
import 'package:code_books/home/domain/use_cases/fetch_books_in.dart';
import 'package:meta/meta.dart';
import 'dart:developer';

import 'package:bloc/bloc.dart';

import 'package:code_books/home/domain/entities/book_entity.dart';

import 'package:code_books/home/domain/use_cases/fetch_popular_books_use_case.dart';

import 'package:meta/meta.dart';

part 'fetch_books_in_state.dart';

class FetchBooksInCubit extends Cubit<FetchBooksInState> {
  FetchBooksInCubit(this.fetchBooksInBooksUseCase)
      : super(FetchBooksInInitial());

  final FetchBooksInBooksUseCase fetchBooksInBooksUseCase;

  Future<void> fetchBooksIn(
      {int pageNumber = 0,
      String searchName = 'programming',
      String sord = 'newest'}) async {
    if (pageNumber == 0) {
      emit(FetchBooksInLoading());
    } else {
      emit(FetchBooksInPaginationLoading());
    }

    var result =
        await fetchBooksInBooksUseCase.call(pageNumber, searchName, sord);

    result.fold((l) {
      if (pageNumber == 0) {
        emit(FetchBooksInFailure(l.toString()));
      } else {
        emit(FetchBooksInPaginationFailure(l.toString()));
      }
    }, (r) {
      emit(FetchBooksInSuccess(r));
    });
  }
}
