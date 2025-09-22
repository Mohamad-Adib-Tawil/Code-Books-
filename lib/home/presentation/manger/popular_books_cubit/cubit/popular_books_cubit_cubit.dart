// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:bloc/bloc.dart';

import 'package:code_books/home/domain/entities/book_entity.dart';

import 'package:code_books/home/domain/use_cases/fetch_popular_books_use_case.dart';
import 'package:code_books/home/domain/use_cases/fetch_newst_books_use_case.dart';

import 'package:meta/meta.dart';

part 'popular_books_cubit_state.dart';

class PopularBooksCubit extends Cubit<PopularBooksCubitState> {
  PopularBooksCubit(this.fetchPopualrBooksUseCase, this.fetchNewestBooksUseCase)
      : super(PopularBooksCubitInitial());

  final FetchPopualrBooksUseCase fetchPopualrBooksUseCase;
  final FetchNewestBooksUseCase fetchNewestBooksUseCase;
  Future<void> fetchPopualrBooks(
      {int pageNumber = 0,
      String searchName = 'programming',
      String sord = 'popular'}) async {
    log('PopularBooksCubit pageNumber ::: $pageNumber');

    if (pageNumber == 0) {
      emit(PopularBooksLoading());

      log('PopularBooksCubit PopularBooksLoading ::: $pageNumber');
    } else {
      emit(PopularBooksPaginationLoading());

      log('PopularBooksCubit PopularBooksLoading ::: $pageNumber');
    }

    var result =
        await fetchPopualrBooksUseCase.call(pageNumber, searchName, sord);

    log('PopularBooksCubit result ::: $pageNumber');

    log('PopularBooksCubit result ::: $result');

    result.fold((l) {
      if (pageNumber == 0) {
        log('PopularBooksCubit PopularBooksFailure ::: $l');

        emit(PopularBooksFailure(l.toString()));
      } else {
        log('PopularBooksCubit PopularBooksFailure ::: $l');

        emit(PopularBooksPaginationFailure(l.toString()));
      }
    }, (r) {
      log('PopularBooksCubit PopularBooksSuccess ::: $r');

      emit(PopularBooksSuccess(r));
    });
  }

  Future<void> fetchPopualrBooksOtherBooks(
      {int pageNumber = 0,
      String searchName = 'programming',
      String sord = 'popular'}) async {
    log('PopularBooksCubit pageNumber ::: $pageNumber');

    if (pageNumber == 0) {
      emit(PopularBooksLoading());

      log('PopularBooksCubit PopularBooksLoading ::: $pageNumber');
    } else {
      emit(PopularBooksPaginationLoading());

      log('PopularBooksCubit PopularBooksLoading ::: $pageNumber');
    }

    var result =
        await fetchPopualrBooksUseCase.call(pageNumber, searchName, sord);

    log('PopularBooksCubit result ::: $pageNumber');

    log('PopularBooksCubit result ::: $result');

    result.fold((l) {
      if (pageNumber == 0) {
        log('PopularBooksCubit PopularBooksFailure ::: $l');

        emit(PopularBooksFailure(l.toString()));
      } else {
        log('PopularBooksCubit PopularBooksFailure ::: $l');

        emit(PopularBooksPaginationFailure(l.toString()));
      }
    }, (r) {
      log('PopularBooksCubit PopularBooksSuccess ::: $r');

      emit(PopularBooksSuccessOtherBook(r));
    });
  }

  void toggleToTrend(
      {int pageNumber = 0,
      String searchName = 'programming',
      String sord = 'relevance'}) async {
    if (pageNumber == 0) {
      emit(PopularBooksLoading());

      log('PopularBooksCubit PopularBooksLoading ::: $pageNumber');
    } else {
      emit(PopularBooksPaginationLoading());

      log('PopularBooksCubit PopularBooksLoading ::: $pageNumber');
    }
    var result =
        await fetchPopualrBooksUseCase.call(pageNumber, searchName, sord);
    result.fold((l) {
      if (pageNumber == 0) {
        log('PopularBooksCubit PopularBooksFailure ::: $l');

        emit(PopularBooksFailure(l.toString()));
      } else {
        log('PopularBooksCubit PopularBooksFailure ::: $l');

        emit(PopularBooksPaginationFailure(l.toString()));
      }
    }, (r) {
      log('PopularBooksCubit PopularBooksSuccess ::: $r');

      emit(PopularBooksTrend(r));
    });
  }

  void toggleToNewest(
      {int pageNumber = 0,
      String searchName = 'programming',
      String sord = 'newest'}) async {
    if (pageNumber == 0) {
      emit(PopularBooksLoading());

      log('PopularBooksCubit PopularBooksLoading ::: $pageNumber');
    } else {
      emit(PopularBooksPaginationLoading());

      log('PopularBooksCubit PopularBooksLoading ::: $pageNumber');
    }
    var result =
        await fetchNewestBooksUseCase.call(pageNumber, searchName, 'new');
    result.fold((l) {
      if (pageNumber == 0) {
        log('PopularBooksCubit PopularBooksFailure ::: $l');

        emit(PopularBooksFailure(l.toString()));
      } else {
        log('PopularBooksCubit PopularBooksFailure ::: $l');

        emit(PopularBooksPaginationFailure(l.toString()));
      }
    }, (r) {
      log('PopularBooksCubit PopularBooksSuccess ::: $r');

      emit(PopularBooksNewest(r));
    });
  }

}
