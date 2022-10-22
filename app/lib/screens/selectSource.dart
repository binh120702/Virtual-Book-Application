import 'package:app/models/source.dart';
import 'package:app/extensions/tangthuvien.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const List<String> sourceList = ['Tang thu vien', 'Me truyen chu'];

class SelectSource extends StatefulWidget {
  const SelectSource({Key? key}) : super(key: key);

  @override
  State<SelectSource> createState() => _SelectSourceState();
}

class _SelectSourceState extends State<SelectSource> {

  String dropdownValue = sourceList.first;
  List<String> tagList = [];
  late Source sourceInstance;

  List<DropdownMenuItem<String>> dropdownItemsGenerate(List<String> sourceList) {
    return sourceList.map<DropdownMenuItem<String>> ((String value) {
      return DropdownMenuItem(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  void onChangedSource(String? value) {
    setState(() {
      dropdownValue = value!;
      tagList = getTagList(value);
    });
  }

  List<String> getTagList(String source) {
    switch(source) {
      case 'Tang thu vien': {
        sourceInstance = Tangthuvien();
      }
      break;
      case 'Me truyen chu': {
      }
      break;
      default: {
        print('something is wrong');
      }
      break;
    }
    return sourceInstance.getTags();
  }

  void jumpToSurf(String chosenTag) {
    Navigator.pushNamed(context, '/surf', arguments: {
      'sourceInstance': sourceInstance,
      'chosenTag': chosenTag,
    });
  }

  List<Widget> getGridViewItems(List<String> tagList) {
    return tagList.map<Widget>((String value) {
      return Card(
        color: Colors.grey[300],
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            jumpToSurf(value);
          },
          child: Center(child: Text(value)),
        ),

      );
    }).toList();
  }

  @override
  void initState() {
    tagList = getTagList(sourceList.first);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //backgroundColor: Colors.brown[600],
        body: Column(
          children: [
            Flexible(
              flex: 0,
              child: DropdownButton<String>(
                value: dropdownValue,
                items: dropdownItemsGenerate(sourceList),
                onChanged: onChangedSource,
              ),
            ),
            Flexible(
              flex: 1,
              child: GridView.count(
                childAspectRatio: 3,
                shrinkWrap: true,
                crossAxisCount: 2,
                children: getGridViewItems(tagList),
              ),
            )
          ],
        ),
      ),
    );
  }
}
