import 'package:flutter/material.dart';
import 'package:code_books/home/domain/entities/book_entity.dart';
import 'package:go_router/go_router.dart';

import '../../home/presentation/views/book_details_view.dart';
import '../../home/presentation/views/home_view.dart';
import '../../home/presentation/views/search_view.dart';

abstract class AppRouter {
  static const kHomeView = '/homeView';
  static const kBookDetailsView = '/bookDetailsView';
  static const kLoading = 'kLoading';
  static const kSearchView = '/searchView';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: kHomeView,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: kBookDetailsView,
        // builder: (context, state) => const BoookDetailsView(),
        builder: (context, state) {
          final book = state.extra as BookEntity;
          return BoookDetailsView(book: book);
        },
      ),
      GoRoute(
        path: kSearchView,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const SearchView(),
            transitionDuration: const Duration(milliseconds: 280),
            reverseTransitionDuration: const Duration(milliseconds: 260),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final offsetTween = Tween<Offset>(begin: const Offset(0.1, 0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeOutCubic));
              final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
                  .chain(CurveTween(curve: Curves.easeOut));
              return FadeTransition(
                opacity: animation.drive(fadeTween),
                child: SlideTransition(
                  position: animation.drive(offsetTween),
                  child: child,
                ),
              );
            },
          );
        },
      ),
    ],
  );
}
