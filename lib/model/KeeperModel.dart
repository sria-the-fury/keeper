
import 'package:hive/hive.dart';
part 'KeeperModel.g.dart';

@HiveType(typeId: 0)
class KeeperModel extends HiveObject{

  @HiveField(0)
  late String noteDelta;

  @HiveField(1)
  late String dayMonthYear;

  @HiveField(2)
  late DateTime createdAt;
}