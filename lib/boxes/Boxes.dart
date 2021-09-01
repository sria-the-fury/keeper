

import 'package:hive/hive.dart';
import 'package:keeper/model/KeeperModel.dart';

class Boxes{
  static Box<KeeperModel> getNote() => Hive.box<KeeperModel>('keeper');

}