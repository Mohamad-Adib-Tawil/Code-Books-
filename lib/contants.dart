import 'dart:ui';

const kFilterIcon = 'assets/icons/Filter.svg';
const kSearchIcon = 'assets/icons/Search.svg';
const kBackgroundSvgColor = Color(0xffF7F8F8);
const kBoxShadow = Color(0xff1d1617);

const kPrimaryColor = Color(0xffCF691F);
const kIconColor = Color(0xFFF48A37);

const kBlackColor = Color(0xff181818);
const kDarkBlackColor = Color(0xff0A0A0A);
const kWhiteColor = Color(0xffEEEEEE);
const kSliverColor = Color(0xff5C5C5C);
const kSliverIconColor = Color(0xff787878);
const kBlackOpacityColor = Color(0xff1E211E);
const kFontGTSectraFineRegular = 'GT Sectra Fine';
const kShadowColor = Color(0xFF313131);

const kPopularBox = 'PopularBox';
const kNewestBox = 'kNewestBox';
const kfetchBooksInBox = 'fetchBooksIn';

// Generate a unique Hive box name per list type (sord) and category (searchName)
// Examples:
//  boxNameFor('popular', 'flutter') => 'books_popular_flutter'
//  boxNameFor('new', 'algorithms') => 'books_new_algorithms'
String boxNameFor(String listType, String category) {
  final lt = listType.trim().toLowerCase();
  final cat = category.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
  return 'books_${lt}_${cat.isEmpty ? 'all' : cat}';
}
