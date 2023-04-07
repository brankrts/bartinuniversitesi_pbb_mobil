// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:pddmobile/models/base_model.dart';
import 'package:pddmobile/models/constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:pddmobile/screens/download_page.dart';
import 'package:pddmobile/screens/pdf_viewer.dart';
import 'package:pddmobile/screens/web_viewer.dart';
import 'package:pddmobile/services/network_manager.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String appbarTitle = 'Kararlar Modülü';
  int bottomNavigatorBarIndex = 0;
  int selectedIndex = 0;
  bool isLoading = false;
  BaseModel? model;
  String? searchText;
  String currentModule = CategoryUrls.kararModulu;
  bool _isFocused = false;
  bool _isSearchFocused = false;
  bool isMainPage = true;
  double? _progress;
  String _status = "";
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
  final _focusNode = FocusNode();
  final searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    searchFocusNode.addListener(_onSearchFocusChange);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    generalSearchEditingController.dispose();
    searchTextEditingController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    searchFocusNode.removeListener(_onSearchFocusChange);
    searchFocusNode.dispose();
    super.dispose();
  }

  void _showSingleDownloadModal(BuildContext context, String url) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.height * 0.4,
          child: SingleDownloadScreen(url: url),
        );
      },
    );
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
    List<String> processedUrl = [];
    String pdf = "pdf";
    String doc = "doc";
    String network = "network";
    if (url != null) {
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

  @override
  Widget build(BuildContext context) {
    double generalSearchWidth = MediaQuery.of(context).size.width * 0.35;
    return Scaffold(
      appBar: BuildAppbar(context, generalSearchWidth),
      //body: BuildBody(context),
      body: isMainPage ? BuildMainPage(context) : BuildBody(context),
      drawer: DrawerManu(context),
    );
  }

  AppBar BuildAppbar(BuildContext context, double generalSearchWidth) {
    return AppBar(
      title: Text(isMainPage ? "PERSONEL BİLGİ BANKASI" : appbarTitle),
      actions: [
        Visibility(
          visible: !isMainPage,
          child: Container(
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
                        });
                        var searchModel = await searchAllData(
                            generalSearchEditingController.text);
                        setState(() {
                          this.model = searchModel;
                          isLoading = false;
                          generalSearchEditingController.clear();
                          _focusNode.unfocus();
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
    String author = "Turgay DELİALİOĞLU\n\nPersonel Daire Başkanı";
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        children: [
          Image.asset('assets/images/logo.jpg'),
          InformationCard(
              title: "Kararlar Modülü",
              body:
                  "Değerli Kullanıcı,\n\nBartın Üniversitesi Personel Daire Başkanlığı tarafından hazırlanan Kararlar Modülünde; Anayasa Mahkemesi, Uyuşmazlık Mahkemesi, Danıştay ve diğer İdari Yargı Kararlarını bulabilirsiniz.\n\nSayfamıza katkı vermek amacıyla elinizde bulunan kararları bizimle paylaşabilirsiniz\n\nDestekleriniz ve işbirliğiniz için teşekkür ederiz.",
              author: author),
          InformationCard(
              title: "YÖK Uygulamaları Modülü",
              body:
                  "Değerli Kullanıcı,\n\nBartın Üniversitesi Personel Daire Başkanlığı tarafından hazırlanan YÖK Uygulamaları modülünde; Yükseköğretim Kurulu Başkanlığı tarafından alınan güncel karar ve görüşleri bulabilirsiniz.\n\nSayfamıza katkı vermek amacıyla elinizde bulunan görüş ve kararları bizimle paylaşabilirsiniz.\n\nDestekleriniz ve işbirliğiniz için teşekkür ederiz.",
              author: author),
          InformationCard(
              title: "DPB Uygulamaları Modülü",
              body:
                  "Değerli Kullanıcı,\n\nBartın Üniversitesi Personel Daire Başkanlığı tarafından hazırlanan DPB Uygulamaları Modülünde; mülga Devlet Personel Başkanlığı tarafından önceki yıllarda verilen güncel karar ve görüşleri bulabilirsiniz.\n\nSayfamıza katkı vermek amacıyla elinizde bulunan görüş ve kararları bizimle paylaşabilirsiniz.\n\nDestekleriniz ve işbirliğiniz için teşekkür ederiz.",
              author: author),
          InformationCard(
              title: "Mali Uygulamalar Modülü",
              body:
                  "Değerli Kullanıcı,\n\nBartın Üniversitesi Personel Daire Başkanlığı tarafından hazırlanan Mali Uygulamaları Modülünde; Sayıştay Başkanlığı tarafından verilen Daire ve Temyiz Kurulu Kararları ile Hazine ve Maliye Bakanlığı ile Strateji ve Bütçe Başkanlığı tarafından verilen güncel karar ve görüşleri bulabilirsiniz.\n\nSayfamıza katkı vermek amacıyla elinizde bulunan görüş ve kararları bizimle paylaşabilirsiniz.\n\nDestekleriniz ve işbirliğiniz için teşekkür ederiz.",
              author: author),
          InformationCard(
              title: "Tamimler Modülü",
              body:
                  "Değerli Kullanıcı,\n\nBartın Üniversitesi Personel Daire Başkanlığı tarafından birimimizin kuruluş sürecinden itibaren kurum içi uygulamalara yönelik yapılan tamimlere ulaşabilirsiniz.\n\nİlginiz için teşekkür ederiz.",
              author: author),
          InformationCard(
              title: "Karşılaştırma Cetvelleri",
              body:
                  "Değerli Kullanıcı,\n\nBartın Üniversitesi Personel Daire Başkanlığı tarafından hazırlanan Karşılaştırma Cetvelleri Modülünde; Kanunlar, Toplu Sözleşmeler, Cumhurbaşkanlığı Kararnameleri, Cunhurbaşkanlığı Kararları, Yönetmelikler, Cumhurbaşkanlığı Genelgeleri, Usuller ve Esasları başlıkları altında karşılaştırma cetvellerini bulabilirsiniz.\n\nSayfamıza katkı vermek amacıyla elinizde bulunan kararları bizimle paylaşabilirsiniz.\n\nDestekleriniz ve işbirliğiniz için teşekkür ederiz.",
              author: author),
          InformationCard(
              title: "Mevzuat Hazırlama",
              body:
                  "Değerli Kullanıcı,\n\nSayfamıza katkı vermek amacıyla elinizde bulunan belgeleri bizimle paylaşabilirsiniz. Destekleriniz ve işbirliğiniz için teşekkür ederiz.",
              author: author)
        ],
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
                              });
                              var searchModel = await searchData(currentModule,
                                  searchTextEditingController.text);
                              setState(() {
                                this.model = searchModel;
                                isLoading = false;
                                searchTextEditingController.clear();
                                searchFocusNode.unfocus();
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
                  return Container(
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
      },
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: processedUrl[0]));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("URL kopyalandı: ${processedUrl[0]}")),
        );
      },
      child: Container(
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
                      Icon(processedUrl[1] == "pdf"
                          ? Icons.picture_as_pdf_sharp
                          : (processedUrl[1] == "doc"
                              ? Icons.edit_document
                              : Icons.network_locked)),
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
        style: TextStyle(color: Colors.white70),
      ),
      onTap: () {
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
