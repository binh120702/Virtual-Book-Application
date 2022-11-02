import 'package:app/models/source.dart';
import 'package:flutter/material.dart';
import 'package:app/extensions/sourceFinder.dart';

final List<String> sourceList = SourceFinder.getSourceList();

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
    sourceInstance = SourceFinder.findFromString(source);
    return sourceInstance.getTags();
  }

  void jumpToSurf(String chosenTag) {
    Navigator.pushNamed(context, '/surf', arguments: {
      'sourceInstance': sourceInstance,
      'chosenTag': chosenTag,
      'source': dropdownValue,
    });
  }

  List<Widget> getGridViewItems(List<String> tagList) {
    return tagList.map<Widget>((String value) {
      return Card(
        color: Colors.white10,
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
        backgroundColor: const Color.fromRGBO(212,198,169, 1),
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
