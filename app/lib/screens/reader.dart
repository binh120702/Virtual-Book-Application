import 'dart:convert';

import 'package:app/models/source.dart';
import 'package:button_navigation_bar/button_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class Reader extends StatefulWidget {
  const Reader({Key? key}) : super(key: key);

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  String chapterContent = '';
  String readingPercent = '0.0';
  late Source sourceInstance;
  bool came = false;
  final ScrollController _controller = ScrollController();
  bool selected = false;
  bool isImageView = false;
  List<String> imgUrlList = [];
  int listLen = 0;
  List<Widget> contentList = [];

  Future<void> getChapterContent() async {
    if (!isImageView) {
      setState(() {
        chapterContent = '';
      });
    }
    String getContent = await sourceInstance.getChapterContent();
    if (getContent.contains('@jsonencoded')) {
      isImageView = true;
      getContent = getContent.replaceAll('@jsonencoded', '');
      imgUrlList = [];
      for(String x in json.decode(getContent)) {
        imgUrlList.add(x);
      }
      listLen = imgUrlList.length;
    } else {
      isImageView = false;
      listLen = 1;
    }
    setState(() {
      chapterContent = getContent;
      contentList = [];
      for(int i = 0; i< listLen; i++) {
        contentList.add(getContentWidget(i));
      }
    });
  }

  void _scrollListener() {
    if (!_controller.position.outOfRange) {
      readingPercent = (_controller.offset*100 / (0.001+_controller.position.maxScrollExtent)).toStringAsFixed(1);
      setState(() {

      });
    }
  }

  void goNextChapter() {
    if (!sourceInstance.setNextReadingChapter()) return;
    readingPercent = '0.0';
    getChapterContent();
  }

  void goPreviousChapter() {
    if (!sourceInstance.setPreviousReadingChapter()) return;
    readingPercent = '0.0';
    getChapterContent();
  }

  void goSpecificChapter(int index) {
    if (!sourceInstance.setSpecificChapter(index)) {
      return;
    }
    readingPercent = '0.0';
    getChapterContent();
  }

  void changeBottomButtonState() {
    setState(() {
      selected = !selected;
    });
  }

  List<SidebarXItem> getCategoryItems() {
    List<SidebarXItem> items = [];
    sourceInstance.chapNameList.asMap().forEach((index, name) {
      items.add(SidebarXItem(
          icon: Icons.remove_rounded,
          label: name,
          onTap: () {
            goSpecificChapter(index);
          }
      ));
    });
    if (items.isEmpty) {
      items.add(SidebarXItem(
          icon: Icons.remove_rounded,
          label: 'Không tìm thấy chap!',
          onTap: () {}
      ));
    }
    return items;
  }

  void updateChapter() {
    sourceInstance.checkUpdate();
  }
  
  Widget getContentWidget(int index) {
    if (isImageView) {
      return Image(
        image: NetworkImage(imgUrlList[index]),
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        fit: BoxFit.fill,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          chapterContent,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Color.fromRGBO(59, 49, 40, 1),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!came) {
      came = true;
      var args = (ModalRoute.of(context)?.settings.arguments as Map);
      sourceInstance = args['sourceInstance'];
      getChapterContent();
    }
    return Scaffold(
      drawer:SizedBox(
        width: 300,
        child: SidebarX(
          theme: SidebarXTheme(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(212,198,169, 1),
              borderRadius: BorderRadius.circular(20),
            ),
            itemPadding: const EdgeInsets.all(0.5),
            itemMargin: const EdgeInsets.all(0.5)
          ),
          controller: SidebarXController(selectedIndex: sourceInstance.currentReadingChapter, extended: true),
          showToggleButton: false,
          headerBuilder: (context, extended) {
            return SizedBox(
              height: 100,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Image(image: NetworkImage(sourceInstance.myBook.thumbnailURL))
                  ),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(0.8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Text(
                              sourceInstance.myBook.name,
                              style: const TextStyle(
                                fontSize: 13,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Text(
                                sourceInstance.myBook.author,
                                style: const TextStyle(
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: IconButton(onPressed: updateChapter, icon: const Icon(Icons.update))
                  )
                ],
              ),
            );
          },
          headerDivider: const Divider(color: Colors.white, height: 1),
          items: getCategoryItems(),
        ),
      ),
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 5,
              child: Text(
                sourceInstance.getCurrentChapterName(),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromRGBO(59,49,40, 1),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Text(
                '$readingPercent%',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(59,49,40, 1),
                ),
              )
            )
          ],
        ),
        toolbarHeight: 30,
        backgroundColor: const Color.fromRGBO(212,198,169, 1),
      ),
      backgroundColor: const Color.fromRGBO(212,198,169, 1),
      body: ListView.builder(
        controller: _controller,
        itemCount: listLen,
        itemBuilder: (context, index) {
            return GestureDetector(
              onTap: changeBottomButtonState,
              child: contentList[index],
            );
          }
      ),
      floatingActionButton: AnimatedContainer(
        height: selected ? 50.0 : 0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        child: SingleChildScrollView(
          child: ButtonNavigationBar(
            children: [
              ButtonNavigationItem(
                width: 140,
                color: const Color.fromRGBO(212,198,169, 0.5),
                onPressed: goPreviousChapter,
                label: 'Trước',
              ),
              ButtonNavigationItem(
                width: 140,
                color: const Color.fromRGBO(212,198,169, 0.5),
                onPressed: goNextChapter,
                label: 'Tiếp',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
