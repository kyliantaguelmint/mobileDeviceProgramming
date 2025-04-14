import 'package:hive/hive.dart';

part 'quote.g.dart';

@HiveType(typeId: 0)
class Quote extends HiveObject {
  @HiveField(0)
  String text;

  @HiveField(1)
  String author;

  Quote({required this.text, required this.author});
}
