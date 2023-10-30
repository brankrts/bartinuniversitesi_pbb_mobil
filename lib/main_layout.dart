// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pddmobile/models/base_model.dart';
import 'package:pddmobile/models/constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:pddmobile/screens/download_page.dart';
import 'package:pddmobile/screens/notification.dart';
import 'package:pddmobile/screens/pdf_viewer.dart';
import 'package:pddmobile/screens/web_viewer.dart';
import 'package:pddmobile/services/cache_service.dart';
import 'package:pddmobile/services/network_manager.dart';
import 'package:pddmobile/state/notificationState.dart';
import 'package:provider/provider.dart';

class MainLayout extends StatefulWidget {
  final List<Map<String, dynamic>>? notificationCache;
  const MainLayout({super.key, this.notificationCache});

  @override
  State<MainLayout> createState() =>
      // ignore: no_logic_in_create_state
      _MainLayoutState(notificationCache: notificationCache);
}

class _MainLayoutState extends State<MainLayout> {
  final List<Map<String, dynamic>>? notificationCache;

  _MainLayoutState({this.notificationCache});

  bool isNotificationChecked = false;
  final Widget pdf_logo = SizedBox(
      width: 40, height: 40, child: SvgPicture.asset("assets/images/pdf1.svg"));
  final Widget doc_logo = SizedBox(
      width: 40, height: 40, child: SvgPicture.asset("assets/images/doc1.svg"));
  final Widget web_logo = SizedBox(
      width: 40, height: 40, child: SvgPicture.asset("assets/images/web1.svg"));
  String appbarTitle = 'Kararlar Modülü';
  int bottomNavigatorBarIndex = 0;
  int selectedIndex = 0;
  bool isLoading = false;
  BaseModel? model;
  String? searchText;
  String currentModule = CategoryUrls.kararModulu;
  bool _isFocused = false;
  // ignore: unused_field
  bool _isSearchFocused = false;
  bool isMainPage = true;
  int _currentTabIndex = 0;

  bool isDownloading = false;
  File? file;

  List<List<String>> items = [
    kararModulu,
    yokUygulamalariModulu,
    dpbUygulamalariModulu,
    maliUygulamalarModulu,
    temimlerModulu,
    karsilatirmaCetvelleriModulu,
    mevzuatHazirlamaModulu
  ];

  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController generalSearchEditingController =
      TextEditingController();
  final TextEditingController searchTextEditingController =
      TextEditingController();
  final TextEditingController mainPageSearchController =
      TextEditingController();

  final _focusNode = FocusNode();
  final searchFocusNode = FocusNode();
  final mainPageSearchFocusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (notificationCache != null) {
        for (var notification in notificationCache!) {
          notification['notification']['element'] =
              Raporverileri.fromJson(notification['notification']['element']);
        }
        Provider.of<NotificationState>(context, listen: false)
            .setNotifications(notificationCache!);
      }
    });

    super.initState();
    _focusNode.addListener(_onFocusChange);
    searchFocusNode.addListener(_onSearchFocusChange);
    mainPageSearchFocusNode.addListener(_onMainPageSearchFocusChange);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    generalSearchEditingController.dispose();
    searchTextEditingController.dispose();
    mainPageSearchController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    searchFocusNode.removeListener(_onSearchFocusChange);
    searchFocusNode.dispose();
    mainPageSearchFocusNode.removeListener(_onMainPageSearchFocusChange);
    mainPageSearchFocusNode.dispose();
    super.dispose();
  }

  void _showSingleDownloadModal(BuildContext context, String url) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.height * 0.4,
          child: SingleDownloadScreen(url: url),
        );
      },
    );
  }

  void _onMainPageSearchFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onSearchFocusChange() {
    setState(() {
      _isSearchFocused = searchFocusNode.hasFocus;
    });
  }

  int findIndex(String? item) {
    if (item != null) {
      int index = items[selectedIndex].indexOf(item);
      return index + 1;
    }
    return 0;
  }

  List<String> processUrl(String? url) {
    String startValue = "https://form.bartin.edu.tr";
    List<String> processedUrl = ['null', 'null'];
    String pdf = "pdf";
    String doc = "doc";
    String network = "network";
    if (url!.isNotEmpty) {
      if (url.startsWith("/dosyalar/")) {
        url = startValue + url;
      }
      if (url.endsWith(".pdf")) {
        processedUrl = [url, pdf];
      }
      if (url.endsWith(".doc") | url.endsWith(".docx")) {
        processedUrl = [url, doc];
      }
      if (!(url.endsWith(".pdf") |
          url.endsWith(".doc") |
          url.endsWith(".docx"))) {
        processedUrl = [url, network];
      }
      return processedUrl;
    }
    return processedUrl;
  }

  void showUrlNotFoundModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning,
                color: Colors.amber,
                size: 40.0,
              ),
              SizedBox(height: 10.0),
              Text(
                "İçerik ile ilişkilendirilmiş URL adresi bulunamadı!",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget isMainPageOrBody(BuildContext context) {
    Widget result = isMainPage ? BuildMainPage(context) : BuildBody(context);
    return result;
  }

  void onTabTapped(int index) {
    setState(() {
      _currentTabIndex = index;
    });
    if (_currentTabIndex == 1) {}
  }

  @override
  Widget build(BuildContext context) {
    double generalSearchWidth = MediaQuery.of(context).size.width * 0.35;
    final List<Widget> tabList = [
      isMainPageOrBody(context),
      const Bildirimler()
    ];

    return Scaffold(
      appBar: _currentTabIndex == 0
          ? BuildAppbar(context, generalSearchWidth)
          : AppBar(
              title: const Text("Bildirimler"),
            ),
      body: tabList[_currentTabIndex],
      drawer: _currentTabIndex == 0 ? DrawerManu(context) : null,
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentTabIndex,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: notificationTabItem(context),
            label: 'Bildirimler',
          )
        ],
      ),
    );
  }

  Stack notificationTabItem(BuildContext context) {
    return Stack(children: <Widget>[
      const Icon(Icons.notifications),
      Positioned(
        right: 0,
        top: 0,
        child: Visibility(
          visible:
              Provider.of<NotificationState>(context).isThereNewNotification,
          child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              )),
        ),
      )
    ]);
  }

  AppBar BuildAppbar(BuildContext context, double generalSearchWidth) {
    final notificationState = Provider.of<NotificationState>(context);
    return AppBar(
      title: Text(isMainPage ? "PERSONEL BİLGİ BANKASI" : appbarTitle),
      actions: [
        Visibility(
          visible: !isMainPage,
          child: SizedBox(
            width: _isFocused
                ? MediaQuery.of(context).size.width * 0.7
                : generalSearchWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: TextField(
                autofocus: false,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                  hintText: "Tum moduller icerisinde arama",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      if (generalSearchEditingController.text.isNotEmpty) {
                        setState(() {
                          isLoading = true;
                          _focusNode.unfocus();
                        });
                        var searchModel = await searchAllData(
                            generalSearchEditingController.text);
                        if (searchModel != null) {
                          List<Map<String, dynamic>> notifications =
                              notificationChecker(searchModel);
                          notificationState.setNotifications(notifications);
                        }
                        setState(() {
                          model = searchModel;
                          isLoading = false;
                          generalSearchEditingController.clear();
                        });
                      }
                    },
                  ),
                ),
                controller: generalSearchEditingController,
              ),
            ),
          ),
        )
      ],
    );
  }

  SingleChildScrollView BuildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        children: [
          DropDownMenu(context),
          CustomDivider(),
          model != null
              ? model!.raporverileri!.isNotEmpty
                  ? DataList(model: model)
                  : BuildNotFound()
              : const Text("Kayit Bulunamadi")
        ],
      ),
    );
  }

  SingleChildScrollView BuildMainPage(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(children: [
        Image.asset('assets/images/logo.jpg'),
        mainPageMenuItems(context),
        mainPageSearchBar(context),
        isLoading
            ? const CircularProgressIndicator()
            : model?.raporverileri?.isNotEmpty == true
                ? (ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: model?.raporverileri?.length ?? 0,
                    itemBuilder: (BuildContext context, int i) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: CustomCard(
                            header:
                                model?.raporverileri![i].kararanabaslik?.veri,
                            pdfLink: model
                                    ?.raporverileri![i].karardosya?.veri ??
                                model?.raporverileri![i].karardosyayolu?.veri,
                            title: model?.raporverileri![i].kararbaslik?.veri,
                            date: model?.raporverileri![i].karartarih?.veri),
                      );
                    }))
                : const Text("Gosterilecek kayit bulunamadi"),
      ]),
    );
  }

  SizedBox mainPageSearchBar(BuildContext context) {
    final notificationState = Provider.of<NotificationState>(context);
    return SizedBox(
      width: double.infinity,
      height: kToolbarHeight * 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    focusNode: mainPageSearchFocusNode,
                    decoration: const InputDecoration(
                      hintText: "Tüm modüller içinde arayın...",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    controller: mainPageSearchController,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    if (mainPageSearchController.text.isNotEmpty) {
                      setState(() {
                        isLoading = true;
                        mainPageSearchFocusNode.unfocus();
                      });
                      var searchModel =
                          await searchAllData(mainPageSearchController.text);
                      if (searchModel != null) {
                        List<Map<String, dynamic>> notifications =
                            notificationChecker(searchModel);
                        notificationState.setNotifications(notifications);
                        //CacheService().cacheIfNotCache(notifications);
                      }

                      setState(() {
                        model = searchModel;
                        isLoading = false;
                        mainPageSearchController.clear();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SingleChildScrollView mainPageMenuItems(BuildContext contex) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          mainMenuItemButton(
              context: context,
              title: "Kararlar Modülü",
              index: 0,
              module: CategoryUrls.kararModulu),
          mainMenuItemButton(
              context: context,
              title: 'YÖK Uygulamaları Modülü',
              index: 1,
              module: CategoryUrls.yokUygulamalari),
          mainMenuItemButton(
              context: context,
              title: 'DPB Uygulamaları Modülü',
              index: 2,
              module: CategoryUrls.dpbUygulamalari),
          mainMenuItemButton(
              context: context,
              title: 'Mali Uygulamalar Modülü',
              index: 3,
              module: CategoryUrls.maliUygulamalar),
          mainMenuItemButton(
              context: context,
              title: 'Tamimler Modülü',
              index: 4,
              module: CategoryUrls.temimlerModulu),
          mainMenuItemButton(
              context: context,
              title: 'Karşılaştırma Cetvelleri',
              index: 5,
              module: CategoryUrls.karsilartirmaCetvelleri),
          mainMenuItemButton(
              context: context,
              title: 'Mevzuat Hazırlama',
              index: 6,
              module: CategoryUrls.mevzuatHazirlama),
          mainMenuWebItemButton(
              context: context,
              title: "Mevzuat Bilgi Sistemi",
              url: 'https://www.mevzuat.gov.tr/'),
          mainMenuWebItemButton(
              context: context,
              title: "Ombudsman Kararları",
              url: 'https://kararlar.ombudsman.gov.tr/Arama')
        ],
      ),
    );
  }

  Padding mainMenuItemButton(
      {required BuildContext context,
      required String title,
      required index,
      required module}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: SizedBox(
        width: 300,
        height: 70,
        child: ElevatedButton(
          onPressed: () async {
            setState(() {
              appbarTitle = title;
              textEditingController.clear();
              selectedValue = null;
              selectedIndex = index;
              currentModule = module;
              model = null;
              isMainPage = false;
            });
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            textStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          child: Text(title),
        ),
      ),
    );
  }

  Padding mainMenuWebItemButton(
      {required BuildContext context,
      required String title,
      required String url}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: SizedBox(
        width: 300,
        height: 70,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => WebViewer(url: url)));
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            textStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          child: Text(title),
        ),
      ),
    );
  }

  Card InformationCard(
      {required String title, required String body, required String author}) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
              color: Colors.blue,
            ),
            padding: const EdgeInsets.all(16.0),
            child: Text(
              textAlign: TextAlign.center,
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              body,
              style: const TextStyle(fontSize: 15.0),
              textAlign: TextAlign.justify,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                author,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding BuildNotFound() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text("Kayit Bulunamadi"),
      ),
    );
  }

  Column DataList({required BaseModel? model}) {
    final notificationState = Provider.of<NotificationState>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Kayit Sayisi : ${model!.raporverileri?.length ?? 0}",
                style: const TextStyle(fontSize: 15),
              ),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      focusNode: searchFocusNode,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 5),
                        hintText: "Modul icerisinde arayin..",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            if (searchTextEditingController.text.isNotEmpty) {
                              setState(() {
                                isLoading = true;
                                searchFocusNode.unfocus();
                              });
                              var searchModel = await searchData(currentModule,
                                  searchTextEditingController.text);
                              if (searchModel != null) {
                                List<Map<String, dynamic>> notifications =
                                    notificationChecker(searchModel);
                                notificationState
                                    .setNotifications(notifications);
                                //CacheService().cacheIfNotCache(notifications);
                              }
                              setState(() {
                                this.model = searchModel;
                                isLoading = false;
                                searchTextEditingController.clear();
                              });
                            }
                          },
                        ),
                      ),
                      controller: searchTextEditingController,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        isLoading
            ? const CircularProgressIndicator()
            : ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: model.raporverileri?.length ?? 0,
                itemBuilder: (BuildContext context, int i) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: CustomCard(
                        header: model.raporverileri![i].kararanabaslik?.veri,
                        pdfLink: model.raporverileri![i].karardosya?.veri ??
                            model.raporverileri![i].karardosyayolu?.veri,
                        title: model.raporverileri![i].kararbaslik?.veri,
                        date: model.raporverileri![i].karartarih?.veri),
                  );
                }),
      ],
    );
  }

  Widget CustomCard({
    required String? title,
    required String? date,
    required String? pdfLink,
    required String? header,
  }) {
    var processedUrl = processUrl(pdfLink);
    return InkWell(
      onTap: () async {
        if (processedUrl[0] != 'null') {
          if (processedUrl[1] == "doc" || processedUrl[1] == "docx") {
            _showSingleDownloadModal(context, processedUrl[0]);
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => processedUrl[1] == "pdf"
                    ? PdfViewer(
                        pdfUrl: processedUrl[0],
                      )
                    : WebViewer(
                        url: processedUrl[0],
                      )));
          }
        } else {
          showUrlNotFoundModal();
        }
      },
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: processedUrl[0]));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("URL kopyalandı: ${processedUrl[0]}")),
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: 100,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    header ?? " ",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date ?? " ",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      processedUrl[1] != "null"
                          ? (processedUrl[1] == "pdf"
                              ? pdf_logo
                              : (processedUrl[1] == "doc"
                                  ? doc_logo
                                  : web_logo))
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Text(
                      title ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 195, 190, 190),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider CustomDivider() {
    return const Divider(
      height: 20,
      thickness: 1,
      indent: 0,
      endIndent: 0,
      color: Colors.white,
    );
  }

  Padding DropDownMenu(BuildContext context) {
    final notificationState = Provider.of<NotificationState>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            'Kategori Secin',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: items[selectedIndex]
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) async {
            int index = findIndex(value);
            setState(() {
              isLoading = true;
            });
            if (currentModule == CategoryUrls.dpbUygulamalari &&
                findIndex(value) >= 20) {
              index += 1;
            }

            var model = await fetchData(currentModule, index.toString());
            List<Map<String, dynamic>> notifications =
                notificationChecker(model);
            notificationState.setNotifications(notifications);
            //CacheService().cacheIfNotCache(notifications);

            setState(() {
              selectedValue = value as String;
              isLoading = false;
              this.model = model;
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 60,
            width: MediaQuery.of(context).size.width * 1,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color.fromARGB(66, 255, 255, 255),
              ),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 50,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: textEditingController,
            searchInnerWidgetHeight: 70,
            searchInnerWidget: Container(
              height: 70,
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 4,
                right: 8,
                left: 8,
              ),
              child: TextFormField(
                expands: true,
                maxLines: null,
                controller: textEditingController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: 'Bir kategori secin...',
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return (item.value
                  .toString()
                  .contains(searchValue.toUpperCase()));
            },
          ),
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              textEditingController.clear();
            }
          },
        ),
      ),
    );
  }

  Drawer DrawerManu(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DraweMenuHeader(),
          DrawerManuMainPageItem(context: context),
          CustomDivider(),
          DrawerManuItem(
              context: context,
              title: "Kararlar Modülü",
              index: 0,
              module: CategoryUrls.kararModulu),
          DrawerManuItem(
              context: context,
              title: 'YÖK Uygulamaları Modülü',
              index: 1,
              module: CategoryUrls.yokUygulamalari),
          DrawerManuItem(
              context: context,
              title: 'DPB Uygulamaları Modülü',
              index: 2,
              module: CategoryUrls.dpbUygulamalari),
          DrawerManuItem(
              context: context,
              title: 'Mali Uygulamalar Modülü',
              index: 3,
              module: CategoryUrls.maliUygulamalar),
          DrawerManuItem(
              context: context,
              title: 'Tamimler Modülü',
              index: 4,
              module: CategoryUrls.temimlerModulu),
          DrawerManuItem(
              context: context,
              title: 'Karşılaştırma Cetvelleri',
              index: 5,
              module: CategoryUrls.karsilartirmaCetvelleri),
          DrawerManuItem(
              context: context,
              title: 'Mevzuat Hazırlama',
              index: 6,
              module: CategoryUrls.mevzuatHazirlama),
          CustomDivider(),
          DrawerManuWebItem(
              context: context,
              title: "Mevzuat Bilgi Sistemi",
              url: 'https://www.mevzuat.gov.tr/'),
          DrawerManuWebItem(
              context: context,
              title: "Ombudsman Kararları",
              url: 'https://kararlar.ombudsman.gov.tr/Arama')
        ],
      ),
    );
  }

  DrawerHeader DraweMenuHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 34, 33, 33),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo.jpg',
            height: 100.0,
          ),
          const SizedBox(height: 10.0),
          const Text(
            'PERSONEL BİLGİ BANKASI',
            style: TextStyle(
              color: Color.fromARGB(255, 234, 227, 227),
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  ListTile DrawerManuItem(
      {required BuildContext context,
      required String title,
      required int index,
      required String module}) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white70),
      ),
      onTap: () async {
        setState(() {
          appbarTitle = title;
          textEditingController.clear();
          selectedValue = null;
          selectedIndex = index;
          currentModule = module;
          model = null;
          isMainPage = false;
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile DrawerManuMainPageItem({required BuildContext context}) {
    return ListTile(
      title: const Text(
        'Anasayfa',
        style: TextStyle(fontSize: 20),
      ),
      onTap: () {
        setState(() {
          isMainPage = true;
          model = null;
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile DrawerManuWebItem(
      {required BuildContext context,
      required String title,
      required String url}) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => WebViewer(url: url)));
      },
    );
  }
}
