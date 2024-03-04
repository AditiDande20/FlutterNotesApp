
import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Notes {

  @HiveField(0)
  String? title;

  @HiveField(1)
  String? description;

  Notes(this.title, this.description);
}
