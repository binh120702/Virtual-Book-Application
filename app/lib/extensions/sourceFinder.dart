import 'package:app/extensions/metruyenchu.dart';
import 'package:app/extensions/tangthuvien.dart';
import 'package:app/extensions/truyenqq.dart';
import '../models/source.dart';
import 'nettruyen.dart';

const Map<String, String> baseForm= {
  'Tàng thư viện': 'Tangthuvien',
  'Mê truyện chữ': 'Metruyenchu',
  'Net truyện': 'Nettruyen',
  'Truyện QQ': 'Truyenqq',
};

class SourceFinder {
  static List<String> getSourceList() {
    return baseForm.keys.toList();
  }
  static Source findFromString(String sourceName){
    if (baseForm.keys.contains(sourceName)) {
      sourceName = baseForm[sourceName]!;
    }
    switch(sourceName) {
      case 'Tangthuvien': {
        return Tangthuvien();
      }
      break;
      case 'Metruyenchu': {
        return Metruyenchu();
      }
      break;
      case 'Nettruyen': {
        return Nettruyen();
      }
      break;
      case 'Truyenqq': {
        return Truyenqq();
      }
      break;
      default: {
        return Tangthuvien();
      }
      break;
    }
  }
}