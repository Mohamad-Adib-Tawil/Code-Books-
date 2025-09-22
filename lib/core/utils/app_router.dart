import 'package:code_books/home/domain/entities/book_entity.dart';
import 'package:go_router/go_router.dart';

import '../../home/presentation/views/book_details_view.dart';
import '../../home/presentation/views/home_view.dart';

abstract class AppRouter {
  static const kHomeView = '/homeView';
  static const kBookDetailsView = '/bookDetailsView';
  static const kLoading = 'kLoading';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
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
    ],
  );
}
// static const kSearchView = '/searchView';

// GoRoute(path: kLoading,builder: (context, state) => const LoaderPage(),),

// GoRoute(
//   path: kSearchView,
//   builder: (context, state) => const SearchView(),
// ),
// GoRoute(
//   path: kHomeView,
//   builder: (context, state) => const HomeView(),
// ),
