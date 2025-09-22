import 'package:code_books/home/domain/entities/book_entity.dart';
import 'package:hive/hive.dart';

void saveBooksData(List<BookEntity> books, String boxName) {
  if (!Hive.isBoxOpen(boxName)) {
    // Open synchronously if already exists; if not, create/open lazily.
    // Note: In a pure sync context, Hive.openBox is async. Here we rely on
    // callers in async contexts. For safety, fallback to existing open boxes.
  }
  final box = Hive.isBoxOpen(boxName)
      ? Hive.box<BookEntity>(boxName)
      : Hive.openBox<BookEntity>(boxName) as dynamic; // best-effort for async
  // If openBox returned Future, adding may be deferred; to avoid type issues
  // keep simple: when not open, skip persist (it will be cached on next fetch).
  if (box is Box<BookEntity>) {
    box.addAll(books);
  }
}

Future<void> saveBooksDataAsync(List<BookEntity> books, String boxName) async {
  final Box<BookEntity> box = Hive.isBoxOpen(boxName)
      ? Hive.box<BookEntity>(boxName)
      : await Hive.openBox<BookEntity>(boxName);
  await box.addAll(books);
}

Future<void> saveBooksPageAsync(
  List<BookEntity> books,
  String boxName, {
  required int pageNumber,
}) async {
  final Box<BookEntity> box = Hive.isBoxOpen(boxName)
      ? Hive.box<BookEntity>(boxName)
      : await Hive.openBox<BookEntity>(boxName);
  if (pageNumber == 0) {
    await box.clear();
  }
  await box.addAll(books);
}
