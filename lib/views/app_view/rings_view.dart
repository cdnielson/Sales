library rings_view;

import 'dart:html';
import 'dart:convert';
import 'dart:async';

import 'package:polymer/polymer.dart';
import '../../model/global.dart';
import 'package:polymer_expressions/filter.dart';
import '../../utils/filters.dart' show StringToInt;
import 'package:core_elements/core_item.dart';
import '../../model/rings.dart';
import '../../model/swatches.dart';
import '../../model/clients.dart';
import '../../model/combos.dart';
import '../../model/users.dart';
//import '../../model/rings_other.dart';
import 'package:intl/intl.dart';
// lawndart
import 'package:lawndart/lawndart.dart';


@CustomTag('rings-view')
class RingsView extends PolymerElement {

  String get pathToThumbnails => "images/rings/thumbnails/";
  String get pathToData => "data/";
  // initialize system log
  //bool _logInitialized = initLog();
  // lawndart
  @observable String websqltext;
  @observable String indexeddbsqltext;
  var dbstockbalances = new IndexedDbStore("sbdb", 'orders');
  var dbordernotes = new IndexedDbStore("notesdb", 'notes');
  var dbmaster = new IndexedDbStore("masterdb", 'master');
  var dbrings = new IndexedDbStore("ringsdb", 'rings');
  var dbotherrings = new IndexedDbStore("otherdb", 'otherrings');
  var dbaccessories = new IndexedDbStore("accessdb", 'accessories');
  var dbcustomdisplay = new IndexedDbStore("accessdb", 'customdisplay');
  var dbcustomrings = new IndexedDbStore("customdb", 'customrings');
  String errortext;

  @observable String contentLabel = "No Tier";
  @observable String contentLabel2 = null;
  @observable String selectedLabel;
  @observable String header = "Sales Order";
  @observable int tier4GCost = 0;
  @observable List<List> tierList;



  String get pathToRings => "data/tiers.json";
  String get pathToRingsPhp => "data/tiers.php";
  String get pathToMeteorite => "data/meteorite.json";
  String get pathToCamo => "data/camo.json";
  String get pathToTitanium => "data/titanium.json";
  String get pathToCarbonFiber => "data/carbonfiber.json";
  String get pathToCobaltChrome => "data/cobaltchrome.json";
  String get pathToDamascus => "data/damascus.json";
  String get pathToTungstenCeramic => "data/tungstenceramic.json";
  String get pathToZirconium => "data/zirconium.json";
  String get pathToOtherMeteorite => "data/othermeteorite.json";
  String get pathToOtherCamo => "data/othercamo.json";
  String get pathToOtherTitanium => "data/othertitanium.json";
  String get pathToOtherCarbonFiber => "data/othercarbonfiber.json";
  String get pathToOtherCobaltChrome => "data/othercobaltchrome.json";
  String get pathToOtherDamascus => "data/otherdamascus.json";
  String get pathToOtherTungstenCeramic => "data/othertungstenceramic.json";
  String get pathToOtherZirconium => "data/otherzirconium.json";
  String get pathToOtherOther => "data/otherother.json";

  String get pathToAccessoryData => "data/accessories.json";
  String get pathToSwatch => "data/swatches.json";


  String get pathToLogin => "data/logins.json";

  String get pathToIndex => "index.html";

  String get imagePath => "images/rings/thumbnails/";
  String get pathToSwatchesThumb => "images/swatches/thumb/";
  String get pathToSwatches => "images/swatches/";

  String get logoPath => "images/lb_logo_white.jpg";
  String get logoPath2 => "images/lb_logo2.jpg";
  String get imageZoomPath => "images/rings/";
  String get pathToPhp => 'signature/';
  String get pathToPhpLoad => 'data/test.php';
  //String get pathToCombosLoad => 'data/loadCombos.php';
  String get pathToLoadOrder => 'data';
  String get pathToPhpAdd => 'data/salesadd.php';
  String get pathToGetClient => 'data/getClient.php';
  String get pathToEmailManually => 'signature/emailmanually.php';
  String get pathToSignatures => 'signature/signatures/';
  String get pathToSig => 'signature/';
  static const FILE_PRE_FIX = 'signature_';
  static const String FILE_TYPE = ".png";



  @observable List<Ring> tierData;
  @observable List<Swatch> swatchData;
  @observable List<Swatch> topSwatchData;
  @observable List<Swatch> sideSwatchData;
  @observable List<Swatch> acrylicData;
  @observable List<Ring> camoList = toObservable([]);
  @observable List<Ring> meteoriteList = toObservable([]);
  @observable List<Ring> titaniumList = toObservable([]);
  @observable List<Ring> carbonfiberList = toObservable([]);
  @observable List<Ring> cobaltchromeList = toObservable([]);
  @observable List<Ring> damascusList = toObservable([]);
  @observable List<Ring> tungstenceramicList = toObservable([]);
  @observable List<Ring> zirconiumList = toObservable([]);
  @observable List<Ring> accessories = toObservable([]);
  @observable List<Ring> othercamoList = toObservable([]);
  @observable List<Ring> othermeteoriteList = toObservable([]);
  @observable List<Ring> corecollectionList = toObservable([]);
  @observable List<Ring> othertitaniumList = toObservable([]);
  @observable List<Ring> othercarbonfiberList = toObservable([]);
  @observable List<Ring> othercobaltchromeList = toObservable([]);
  @observable List<Ring> otherdamascusList = toObservable([]);
  @observable List<Ring> othertungstenceramicList = toObservable([]);
  @observable List<Ring> otherzirconiumList = toObservable([]);
  @observable List<Ring> otherhardwoodList = toObservable([]);
  @observable List<Ring> otherotherList = toObservable([]);
  List<Map> combosMapList;
  @observable List<Combo> combos = toObservable([]);
  //List<bool> categoryLoadedList = [false, false, false, false, false, false, false, false];
  //List<bool> otherCategoryLoadedList = [false, false, false, false, false, false, false, false, false];

  @observable List<User> loginData;
  @observable List<Ring> currentTier;
  @observable List<Ring> tierOne = toObservable([]);
  @observable List<Ring> tierTwo = toObservable([]);
  @observable List<Ring> tierThree = toObservable([]);
  @observable List<Ring> tierFour = toObservable([]);
  //List<Ring> tierFourHolder;

  @observable String currentUser = "";

  String currentUserEmail = "";

  @observable List<Ring> otherRingsAll = toObservable([]);
  @observable List<Ring> orderImages = toObservable([]);
  @observable List<Ring> orderAccessories = toObservable([]);
  @observable List<Ring> orderOtherRings = toObservable([]);
  @observable List<Ring> orderOtherRingsPlus = toObservable([]);

  @observable List<User> loginList;
  //@observable int additionalTierCost;

  List removed = toObservable([]);
  //List removedStore = [];
  @observable List added = toObservable([]);
  //List addedStore = [];
  @observable List addeditem = toObservable([]);
  //List addeditemStore = [];
  @observable List<Map> typedSkus = toObservable([]);
  @observable List<Map> stockBalances = toObservable([]);
  @observable List finalRemoved = toObservable([]);
  @observable List finalAdded = toObservable([]);
  @observable List finalAddedPlus = toObservable([]);
  @observable List finalAddedItem = toObservable([]);
  //String temporderName;
  @observable String ringZoomImage;
  @observable bool hideZoom = true;
  @observable bool hideSubmit = true;
  @observable String ringZoomData;
  List<Map> mapList;
  List<Map> mapListLogin;
  //@observable bool openIt = false; //should rename these I'M HERE!!! YOINK
  @observable bool openIt2 = false; //should rename these
  //bool firstTime = true;
  //@observable int currentTierSelection = 0;
  //bool doNotDoIt = false;
  bool keepCost = false;
  int tempCost;
  @observable String failedLogin;
  @observable bool hideRings = false;
  //@observable bool hideAccessories = true;
  //@observable bool hideOtherRings = true;
  //bool zoomed = false;

  @observable List<int> checkPin = [];
  @observable String pin1;
  @observable String pin2;
  @observable String pin3;
  @observable String pin4;
  @observable String failedText;
  @observable int otherRingCost = 0;
  @observable int otherItemsCost = 0;
  //final int tier1 = 4104; //4104
  //final int tier2 = 7291; //7132
  //final int tier3 = 10490; //10311
  //final int tier4 = 14153; //13974
  //final int tier4G = 14997;
  //static const int METEORITE = 1;
  //static const int CAMO = 2;
  //static const int TITANIUM = 3;
  //static const int CARBONFIBER = 4;
  //static const int COBALTCHROME = 5;
  //static const int DAMASCUS = 6;
  //static const int TUNGSTENCERAMIC = 7;
  //static const int ZIRCONIUM = 8;
  //static const int ALL = 0;
  //static const int ALLALL = 0;
  //static const int OTHERMETEORITE = 1;
  //static const int OTHERCAMO = 2;
  //static const int OTHERTITANIUM = 3;
  //static const int OTHERCARBONFIBER = 4;
  //static const int OTHERCOBALTCHROME = 5;
  //static const int OTHERDAMASCUS = 6;
  //static const int OTHERTUNGSTENCERAMIC = 7;
  //static const int OTHERZIRCONIUM = 8;
  //static const int OTHEROTHER = 9;
  //bool meteoriteloaded = true;
  //bool accessoriesloaded = false;
  @observable int subTotalCost = 0;
  //@observable bool hideFinal = true;
  //@observable bool hideComplete = true;
  @observable bool hideSignature = true;
  @observable String boundData;
  Map sendMap;
  //StringBuffer sb = new StringBuffer();
  @observable int shippingCosts;
  //@observable bool hideCloseAccButton = true;
  //@observable bool hideCloseOtherButton = true;
  @observable int selected = 8;
  @observable int subselected = 0;
  @observable int comboselected = 0;
  @observable int othersubselected = 0;
  bool guaranteed = false;
  @observable bool showguaranteed = false;
  @observable int totalPlusShipping;
  bool inRange(num arg, num min, num max) => arg > min && arg < max;
  @observable String search;
  //@observable bool hide2ndTier = false;
  @observable bool hideSubmitButton = true;
  @observable bool hideCloseSignatureButton = true;
  @observable bool hideSaveButton = true;
  @observable bool hideLoadButton = false;
  @observable bool hideButtons = true;
  @observable bool showTypeSku = false;
  @observable bool showStockBalance = false;
  @observable bool hideStockBalance = true;
  String customSku;
  String customFinish;
  String customSkuPrice;
  String customStockBalancePrice;
  @observable String warningtext;
  @observable bool hideMenus = false;
  int customcost = 0;
  int sbcost = 0;
  int saveSelected;
  StreamSubscription imageLoadSub;
  @observable bool showCannotHaveBlank = false;
  @observable bool hideSignatureRequired = true;
  DateTime now = new DateTime.now();
  @observable String date;
  @observable String lastName;
  @observable bool hideguaranteedinreview = false;
  int tempSelected;
  String pathToPngFile;
  @observable bool backwarning = false;
  @observable bool hideguarantee = false;
  int sbid;
  int tierInfo = 0;
  int count = 0;
  bool loadStores = false;
  bool displayAdded = false;
  bool customDisplayAdded = false;
  bool firstDataLoad = true;
  @observable bool showDisplayWarning = false;
  @observable bool showTermsWarning = false;
  @observable String barcodedata = "";
  @observable Ring barcodeRing = toObservable([]);
  int multiload = 0;
  int loadcount = 0;
  final List<String> otherajaxList = ["othermeteoriteajax", "othercamoajax", "othertitaniumajax", "othercarbonfiberajax", "othercobaltchromeajax", "otherdamascusajax", "othertungstenceramicajax", "otherzirconiumajax", "otherotherajax"];
  final List<String> ajaxList = ["meteoriteajax", "camoajax", "titaniumajax", "carbonfiberajax", "cobaltchromeajax", "damascusajax", "tungstenceramicajax", "zirconiumajax"];
  @observable bool openLogIn = false;
  @observable bool hideCoverApp = false;
  @observable bool openLoading = true;
  @observable bool barcodeload = false;
  @observable bool orderimagesload = false;
  @observable bool hideExistingPartner = true;
  @observable bool hideScrollButton = true;
  @observable String listclass = "regulartier";
  @observable String tempvar = "";
  @observable bool viewSaveOrderDialog = false;
  @observable bool hideNotFound = true;

  final Transformer asInteger = new StringToInt();
  int tier = 0;
  bool loadingfromDB = false;
  @observable bool openLoadingWarning = false;
  var masterld;
  var removedld;
  var addedld;
  var addeditemld;
  var customdisplayld;
  var typedskusld;
  var stockbalancesld;
  var ordernotesld;
  bool firstpass = true;
  @observable List orderNames = toObservable([]);
  //@observable bool viewChooseOrder = false;
  String orderName = "";
  @observable String orderID;
  bool uploadit = false;
  @observable List<Ring> core_collection = toObservable([]);
  @observable List<Ring> basics_a = toObservable([]);
  @observable List<Ring> basics_b = toObservable([]);
  @observable List<Ring> engraved_set_a = toObservable([]);
  @observable List<Ring> hardwood_10 = toObservable([]);
  @observable List<Ring> elysium_8 = toObservable([]);
  @observable List<Ring> elysium_5 = toObservable([]);
  @observable List<Client> currentPartner = toObservable([]);
  @observable List<Client> clientList = toObservable([]);
  @observable List<Client> clientResponse = toObservable([]);

  @observable bool hideTierMenu = false;
  @observable bool hideAllMenu = true;
  @observable bool hideCombosMenu = true;
  @observable bool hideOtherButtons = true;
  @observable int partnerSelected = 0;
  //@observable int repeatcounter = 0;
  static const TIMEOUT = const Duration(seconds: 3);
  static const ms = const Duration(milliseconds: 1);
  bool isCombo = false;
  //List comboBarcodeAddList;
  @observable int tierselected = 5;
  @observable List<Ring> searchList = toObservable([]);
  List selectedList = []; // [selectedLabel, selected-sub-label] (tier, category, etc)
  //@observable int theTier;
  int chooseMenuItem;
  RingsView.created() : super.created();
  bool tierLoaded = false;
  String chosenCombo = "Basics A";
  @observable bool hideRingsInOrder = true;
  @observable bool hideOtherRingsInOrder = true;
  @observable bool hideRemovedItems = true;
  @observable bool hideOtherItemsInOrder = true;
  @observable bool hideCustomSkus = true;
  @observable bool hideStockBalances = true;
  @observable bool finalHidden = false;
  @observable int height = 700;
  @observable bool hidebarcodeRing = true;
  @observable bool hidecombomessage = true;
  @observable String thecombo;
  bool small = true;
  //@observable bool showRemoveRingWarning = true;
  //@observable bool hideloader = false;
  int order_id;
  int client_id;
  String orderNotes;
  @observable bool hideExistingCustomer = true;
  @observable bool hideNoBarcodeFound = true;
  @observable String barcodenote = "ADDED!";
  @observable bool hideStoreNameWarning = true;
  @observable bool openEmailedNotice = false;
  @observable bool showSelectCustom = false;
  @observable bool hideCustomDisplay = true;
  @observable String orderemail = "No email found";
  String store_name;
  @observable String topSwatch;
  @observable String sideSwatch;
  @observable String acrylic;
  @observable String customBase = "american_beauty.jpg";
  @observable String customBack = "display_back400.png";
  @observable String customTop = "display_top_shell.png";
  @observable String acrylicTop = "display_acrylic_white400.png";
  bool ccIsSingle = true;


  // life-cycle method called by the Polymer framework when the element is attached to the DOM
  @override void attached() {
    super.attached();

    DateFormat dateFormatter = new DateFormat("yyyy-MM-dd");
    date = dateFormatter.format(now);
    //$["iframe"].location.reload();
    getWidthHeight();

  }

  // a sample event handler function
  /*void eventHandler(Event event, var detail, Element target) {
    //print("$runtimeType::eventHandler()");
  }
*/
  void submit(Event event, var detail, Element target) {
    // prevent app reload on <form> submission
    event.preventDefault();
  }

  //rename this function
  void swapTier(Event event, var detail, Element target) {
    //print("$runtimeType::selectAction()");
    if (detail["isSelected"]) {
      handleSelection(selectedLabel);
    }
  }

  /*void pagenine() {
    selected = 9;
    scroll();
  }*/

  void changeUser(){
    openLogIn = true;
  }

  //rename this function
  void swapWindow(Event event, var detail, Element target) {
    if (detail["isSelected"]) {

      //swap which of the three righthand menus is being used
      var menu = target.dataset['menu'];
      if (menu == "1") {
        $['menu-id2'].selected = -1;
        $['menu-id3'].selected = -1;
        $['menu-id4'].selected = -1;
      }
      if (menu == "2") {
        $['menu-id1'].selected = -1;
        $['menu-id3'].selected = -1;
        $['menu-id4'].selected = -1;
      }
      if (menu == "3") {
        $['menu-id1'].selected = -1;
        $['menu-id2'].selected = -1;
        $['menu-id4'].selected = -1;
      }
      if (menu == "4") {
        $['menu-id1'].selected = -1;
        $['menu-id2'].selected = -1;
        $['menu-id3'].selected = -1;
      }

      /*if ($["menu-id2"].selected == 2 || $["menu-id2"].selected == 3 || $["menu-id2"].selected == 6) {
        return;
      } else {*/

      CoreItem item = detail["item"];
      selectedLabel = item.label;


      if (selectedLabel == "Tiers") {
        selected = 0;
        scroll();
        hideAllMenu = true;
        hideTierMenu = false;
        hideCombosMenu = true;
        handleSelection(selectedLabel);

      }
      if (selectedLabel == "Accessories") {
        selected = 1;
        scroll();
        hideAllMenu = true;
        hideTierMenu = true;
        hideCombosMenu = true;
        handleSelection(selectedLabel);
      }

      if (selectedLabel == "All Rings") {
        selected = 2;
        scroll();
        hideAllMenu = false;
        hideTierMenu = true;
        hideCombosMenu = true;
        handleSelection(selectedLabel);
      }

      if (selectedLabel == "Collections") {
        small = false;
        selected = 10;
        scroll();
        hideAllMenu = true;
        hideTierMenu = true;
        hideCombosMenu = false;
        setCombos();
      }

      if (selectedLabel == "Barcode Scan") {
        //print("selected = 8");
        selected = 8;
        scroll();
        hideAllMenu = true;
        hideTierMenu = true;
        hideCombosMenu = true;
        barcodeload = true;
        setCombos();
        //newTab(null, {"isSelected": true});

        async((_) => $["barcodeinput"].focus());
       }

      //var whatever = $['headerPanel'].scroller;

      if (selectedLabel == "Search") {
        selected = 11;
        scroll();
        async((_) => $["filter"].focus());
      }

    }
  }

  void handleSelection(selectedLabel) {
    //selectedList.add(selectedLabel);
    if (selectedLabel == "Tiers") {
      //print("Handling Selection for Tiers");
      if (tierselected == 5) {
        hideguarantee = false;
        small = true;
      } else {
        hideguarantee = true;
        small = false;
      }

      switch (subselected) {
        case 0:
          switch (tierselected) {
            case 1:
              //hideguarantee = true;
              if (tierOne.isEmpty) {
                startTimeout(500, "tierone");
              }; break;
            case 2:
              //hideguarantee = true;
              if (tierTwo.isEmpty) {
                startTimeout(500, "tiertwo");
              }; break;
            case 3:
              //hideguarantee = true;
              if (tierThree.isEmpty) {
                startTimeout(500, "tierthree");
              }; break;
            case 4:
              //hideguarantee = true;
              if (tierFour.isEmpty) {
                startTimeout(500, "tierfour");
              }; break;
            case 5:
              //hideguarantee = false;
              //print("hippy yippee");
              if (tierFour.isEmpty) {
                startTimeout(500, "tierfourg");
              }; break;
            case 0:
              //hideguarantee = true;
              break;
          }; break;
        case 1:
          startTimeout(500, "meteoritelist");

          break;
        case 2:
          startTimeout(500, "camolist");
          break;
        case 3:
          startTimeout(500, "titaniumlist");
          break;
        case 4:
          startTimeout(500, "carbonfiberlist");
          break;
        case 5:
          startTimeout(500, "cobaltchromelist");
          break;
        case 6:
          startTimeout(500, "damascuslist");
          break;
        case 7:
          startTimeout(500, "tungstenceramiclist");
          break;
        case 8:
          startTimeout(500, "zirconiumlist");
          break;
      }
    }
    if (selectedLabel == "Accessories") {
      small = false;
      hideguarantee = true;
      //print("Handling Selection for Accessories");
      if (accessories.isEmpty) {
        startTimeout(500, "accessories");
      }
    }
    if (selectedLabel == "All Rings") {
      small = false;
      hideguarantee = true;
      //print("Handling Selection for All Rings");
      switch (othersubselected) {
        case 0:
          if (otherRingsAll.isEmpty) {
            startTimeout(500, "otherringsall");
          }; break;
        case 1:
          if (corecollectionList.isEmpty) {
            startTimeout(500, "corecollectionlist");
          }; break;
        case 2:
          if (othermeteoriteList.isEmpty) {
            startTimeout(500, "othermeteoritelist");
          }; break;
        case 3:
          if (othercamoList.isEmpty) {
            startTimeout(500, "othercamolist");
          }; break;
        case 4:
          if (othertitaniumList.isEmpty) {
            startTimeout(500, "othertitaniumlist");
          }; break;
        case 5:
          if (othercarbonfiberList.isEmpty) {
            startTimeout(500, "othercarbonfiberlist");
          }; break;
        case 6:
          if (othercobaltchromeList.isEmpty) {
            startTimeout(500, "othercobaltchromelist");
          }; break;
        case 7:
          if (otherdamascusList.isEmpty) {
            startTimeout(500, "otherdamascuslist");
          }; break;
        case 8:
          if (othertungstenceramicList.isEmpty) {
            startTimeout(500, "othertungstenceramiclist");
          }; break;
        case 9:
          if (otherzirconiumList.isEmpty) {
            startTimeout(500, "otherzirconiumlist");
          }; break;
        case 10:
          if (otherhardwoodList.isEmpty) {
            startTimeout(500, "otherhardwoodlist");
          }; break;
        case 11:
          if (otherotherList.isEmpty) {
            startTimeout(500, "otherotherlist");
          }; break;
      }
    }
    getWidthHeight();
  }

  void setCombos() {
    if (basics_a.isEmpty) {

      //print(core_collection);
      basics_a = tierData.where((Ring element) => element.combo == "basics_a" || element.combo2 == "basics_a").toList();
      basics_b = tierData.where((Ring element) => element.combo == "basics_b" || element.combo2 == "basics_b").toList();
      engraved_set_a = tierData.where((Ring element) => element.combo == "engraved_set_a").toList();
      hardwood_10 = tierData.where((Ring element) => element.combo == "hardwood_10").toList();
      elysium_8 = tierData.where((Ring element) => element.combo == "elysium_8").toList();
      elysium_5 = tierData.where((Ring element) => element.combo2 == "elysium_5").toList();
      core_collection = tierData.where((Ring element) => element.SKU == "CORE_COLLECTION").toList();
    } else {
      //print("already full");
    }
  }

  void swapCoreCombo() {
    if (ccIsSingle) {
      core_collection = tierData.where((Ring element) => element.combo == "CORE56").toList();
      ccIsSingle = false;
    } else {
      core_collection = tierData.where((Ring element) => element.SKU == "CORE_COLLECTION").toList();
      ccIsSingle = true;
    }
    scrollIt();
  }

  void startTimer(String id) {
    List tempList;
    Timer myTimer;
    myTimer = new Timer.periodic(new Duration(milliseconds: 300), (Timer timer) {
      tempList = $['$id'].data;
      //print(tempList);
      if (tempList.isEmpty) {
        //print("loading");
      } else {
        myTimer.cancel();
        openLoading = false;
        //print("hilo");
        async((_) => $["barcodeinput"].focus());
        //var temp = $['rings1'].target;

      }
    });
  }

 /* Timer startOtherTimeout([int milliseconds]) {
    openLoading = true;
    var duration = milliseconds == null ? TIMEOUT : ms * milliseconds;
    return new Timer(duration, handleOtherTimeout);
  }*/

  /*void handleOtherTimeout() {

    if (selectedLabel == "Accessories") {
      accessories = tierData.where((Ring element) => element.tier == 22).toList();
      startTimer("accessories");
    }

    if (selectedLabel == "All Rings") {
      otherRingsAll = tierData.where((Ring element) => element.tier != 22).toList();
      startTimer("otherringsall");
    }
    return;
  }*/

  /*Timer startTimeoutOld([int milliseconds]) {
      openLoading = true;
      var duration = milliseconds == null ? TIMEOUT : ms * milliseconds;
      return new Timer(duration, handleTimeout);
  }*/
  void startTimeout(int milliseconds, String id) {

      openLoading = true;
      if (tierselected == 0 && subselected != 0) {
        openLoading = false;
      }

      //var duration = milliseconds == null ? TIMEOUT : ms * milliseconds;
      //Timer myTimer;
      new Timer(new Duration(milliseconds: milliseconds), () {
        //print("Timeout!");
        handleTimeout(id);
      });
  }

  void handleTimeout(String id) {
    // maybe make this a switch case too?

    switch (id) {
      case "tierone":
        tierOne = tierData.where((Ring element) => element.tier == 1).toList();

        break;
      case "tiertwo":
        tierTwo = tierData.where((Ring element) => element.tier == 1 || element.tier == 2).toList();

        break;
      case "tierthree":
        tierThree = tierData.where((Ring element) => element.tier == 1 || element.tier == 2 || element.tier == 3).toList();

        break;
      case "tierfour":
        tierFour = tierData.where((Ring element) => element.tier == 1 || element.tier == 2 || element.tier == 3 || element.tier == 4).toList();

        break;
      case "tierfourg":
        tierFour = tierData.where((Ring element) => element.tier == 1 || element.tier == 2 || element.tier == 3 || element.tier == 4).toList();

        break;
      case "otherringsall":
        otherRingsAll = tierData.where((Ring element) => element.tier != 22).toList();
        break;
      case "corecollectionlist":
        corecollectionList = tierData.where((Ring element) => element.category == "Core Collection" && element.tier != 22).toList();
        break;
      case "othermeteoritelist":
        othermeteoriteList = tierData.where((Ring element) => element.category == "Meteorite" && element.tier != 22).toList();
        break;
      case "othercamolist":
        othercamoList = tierData.where((Ring element) => (element.category == "Camo" || element.category == "King's Camo")  && element.tier != 22).toList();
        break;
      case "othertitaniumlist":
        othertitaniumList = tierData.where((Ring element) => element.category == "Titanium" && element.tier != 22).toList();
        break;
      case "othercarbonfiberlist":
        othercarbonfiberList = tierData.where((Ring element) => element.category == "Carbon Fiber" && element.tier != 22).toList();
        break;
      case "othercobaltchromelist":
        othercobaltchromeList = tierData.where((Ring element) => element.category == "Cobalt Chrome" && element.tier != 22).toList();
        break;
      case "otherdamascuslist":
        otherdamascusList = tierData.where((Ring element) => element.category == "Damascus" && element.tier != 22).toList();
        break;
      case "othertungstenceramiclist":
        othertungstenceramicList = tierData.where((Ring element) => element.category == "Tungsten Ceramic" && element.tier != 22).toList();
      //print(othertungstenceramicList);
        break;
      case "otherzirconiumlist":
        otherzirconiumList = tierData.where((Ring element) => element.category == "Zirconium" && element.tier != 22).toList();
        break;
      case "otherhardwoodlist":
        otherhardwoodList = tierData.where((Ring element) => element.category == "Hard Wood" && element.tier != 22).toList();
        break;
      case "otherotherlist":
        otherotherList = tierData.where((Ring element) => (
            element.category == "Mokume" ||
            element.category == "Elysium" ||
            element.category == "Ceramic" ||
            element.category == "Precious Metal" ||
            element.category == "Goodyear" ||
            element.category == "Platinum" ||
            element.category == "MossyOak" ||
            element.category == "Fable" ||
            element.category == "Fable Camo" ||
            element.category == "Stainless Steel"
        )  && element.tier != 22).toList();
        break;
      case "accessories":
        accessories = tierData.where((Ring element) => element.tier == 22).toList();
        break;
      default:

        handleCategories(id);
    }
    startTimer(id);
  }

  void handleCategories(id){
    List tempTierList;
    switch(tierselected) {
      case 0:  break;
      case 1: tempTierList = [1]; break;
      case 2: tempTierList = [1,2]; break;
      case 3: tempTierList = [1,2,3]; break;
      case 4: tempTierList = [1,2,3,4]; break;
      case 5: tempTierList = [1,2,3,4]; break;
    }

    meteoriteList.clear();
    camoList.clear();
    titaniumList.clear();
    carbonfiberList.clear();
    cobaltchromeList.clear();
    damascusList.clear();
    tungstenceramicList.clear();
    zirconiumList.clear();

    for (var t in tempTierList) {

      switch(id) {

        case "meteoritelist":

          meteoriteList.addAll(tierData.where((Ring element) => element.category == "Meteorite" && element.tier == t).toList());
          break;
        case "camolist":
          camoList.addAll(tierData.where((Ring element) => (element.category == "Camo" || element.category == "King's Camo") && element.tier == t).toList());
          break;
        case "titaniumlist":
          titaniumList.addAll(tierData.where((Ring element) => element.category == "Titanium" && element.tier == t).toList());
          break;
        case "carbonfiberlist":
          carbonfiberList.addAll(tierData.where((Ring element) => element.category == "Carbon Fiber" && element.tier == t).toList());
          break;
        case "cobaltchromelist":
          cobaltchromeList.addAll(tierData.where((Ring element) => element.category == "Cobalt Chrome" && element.tier == t).toList());
          break;
        case "damascuslist":
          damascusList.addAll(tierData.where((Ring element) => element.category == "Damascus" && element.tier == t).toList());
          break;
        case "tungstenceramiclist":
          tungstenceramicList.addAll(tierData.where((Ring element) => element.category == "Tungsten Ceramic" && element.tier == t).toList());
          break;
        case "zirconiumlist":
          zirconiumList.addAll(tierData.where((Ring element) => element.category == "Zirconium" && element.tier == t).toList());
          break;
        default:
          break;
      }
    }
  }

  /*void onCombosLoaded(String responseText) {
    combosMapList = JSON.decode(responseText);
    combos = combosMapList.map((Map element) => new Combo.fromMap(element)).toList();
  }*/

  void searchForBarcode() {
    barcodedata = $["barcodeinput"].value;

    if (barcodedata == "100000") {
      thecombo = "Basics A";
      isCombo = true;
      setCombos();
      addCombo(1);
    }
    if (barcodedata == "100001") {
      thecombo = "Basics B";
      isCombo = true;
      setCombos();
      addCombo(2);
    }
    if (barcodedata == "100002") {
      thecombo = "Engraved Set A";
      isCombo = true;
      setCombos();
      addCombo(3);

    }
    if (barcodedata == "100003") {
      thecombo = "Hardwood 10";
      isCombo = true;
      setCombos();
      addCombo(4);
    }
    if (barcodedata == "100004") {
      thecombo = "Elysium 8";
      isCombo = true;
      setCombos();
      addCombo(5);
    }
    /*if (barcodedata == "100005") {
      thecombo = "Core Collection";
      isCombo = true;
      setCombos();
      addCombo(0);
    }*/
    if (barcodedata == "100006") {
      thecombo = "Elysium 5";
      isCombo = true;
      setCombos();
      addCombo(6);
    }

    Ring currentBarcode;

    if (!isCombo) {
      int barcodeint = int.parse(barcodedata);
      hidecombomessage = true;
      currentBarcode = tierData.firstWhere((Ring element) => element.id == barcodeint, orElse: () => null);
      if (currentBarcode == null) {
        $["barcodeinput"].value = "";
        hideNoBarcodeFound = false;
        hidebarcodeRing = true;
        hidecombomessage = true;
        //print("No item was found.");
        return;
      } else {
        hideNoBarcodeFound = true;
      }
      Map temp = {'SKU' : currentBarcode.SKU, 'finish' : currentBarcode.finish};


      removeRing(null, temp, null);

      if (currentBarcode  != null) {
        barcodeRing = currentBarcode;
        if (barcodeRing.cleared != true) {
          hidebarcodeRing = false;
        }
      } else {
        hidebarcodeRing = true;
      }

    } else {
      hidebarcodeRing = true;
      hidecombomessage = false;
    }
    /*if (barcodeRing.cleared == true) {
      hidebarcodeRing = true;
    }*/
    $["barcodeinput"].value = "";
    async((_) => $["barcodeinput"].focus());
    /*async((_) {
      //scrollIt();
    //scrolls to the bottom of the barcode scans but it's problematic
      int itemlast = barcodeRings.length;
      $["barcodeRings"].scrollToItem(itemlast);
    });*/
    isCombo = false;
  }

  /*void setTier() {

    var tierSelected = $['menu-id'].selected;

    switch (tierSelected) {
      case 0: contentLabel = "No Tier"; break;
      case 1: contentLabel = "Tier 4 Guaranteed"; break;
      case 2: contentLabel = "Tier 4"; break;
      case 3: contentLabel = "Tier 3"; break;
      case 4: contentLabel = "Tier 2"; break;
      case 5: contentLabel = "Tier 1"; break;
    }

    //print(contentLabel);
    if (contentLabel == "Tier 1") {
      tier = 1;

      guaranteed = false;
      listclass = "regulartier";
      hideguarantee = true;
      //currentTier = tierData.where((Ring element) => element.tier == 1).toList();
      if (keepCost) {
        tier4GCost = tempCost;
      } else {
        tier4GCost = tier1;
      }
    }

    if (contentLabel == "Tier 2") {
      if (tierTwo.isEmpty) {
        openLoading = true;
        tierTwo = tierData.where((Ring element) => element.tier == 1 || element.tier == 2).toList();
        //startTimer();
      }
      tier = 2;
      guaranteed = false;
      listclass = "regulartier";
      hideguarantee = true;

      if (keepCost) {
        tier4GCost = tempCost;
      } else {
        tier4GCost = tier2;
      }
    }

    if (contentLabel == "Tier 3") {
      if (tierThree.isEmpty) {
        openLoading = true;
        tierThree = tierData.where((Ring element) => element.tier == 1 || element.tier == 2 || element.tier == 3).toList();
        //startTimer();
      }
      tier = 3;
      guaranteed = false;
      listclass = "regulartier";
      hideguarantee = true;

      if (keepCost) {
        tier4GCost = tempCost;
      } else {
        tier4GCost = tier3;
      }
    }

    if (contentLabel == "Tier 4") {
      if (tierFour.isEmpty) {
        openLoading = true;
        tierFour = tierData.where((Ring element) => element.tier == 1 || element.tier == 2 || element.tier == 3 || element.tier == 4).toList();
        //startTimer();
      }
      tier = 4;
      guaranteed = false;
      listclass = "regulartier";
      hideguarantee = true;

      if (keepCost) {
        tier4GCost = tempCost;
      } else {
        tier4GCost = tier4;
      }
    }

    if (contentLabel == "Tier 4 Guaranteed") {
      tier = 4;
      guaranteed = true;
      listclass = "guaranteedtier";
      hideguarantee = false;

      if (keepCost) {
        tier4GCost = tempCost;
      } else {
        tier4GCost = tier4G;
      }
    }

    if (contentLabel == "No Tier") {
      tier = 0;
      guaranteed = false;
      listclass = "regulartier";
      hideguarantee = true;

      if (keepCost) {
        tier4GCost = tempCost;
      } else {
        tier4GCost = 0;
      }
    }
    if (!loadingfromDB) {

      addToDB();
    }
    setTierRingsToCleared();
    setSubTotalCost();


  }*/

  void tierItUp() {
    //print(tierselected);
    List<Ring> theRingsSelectedInTheTier;
    tierLoaded = false;
    removed.clear();
    //print("removed $removed");
    finalRemoved.clear();
    //print("finalRemoved $finalRemoved");
    for (var t in tierData) {
      if (t.added == "Remove" && t.tier != 0 && t.tier != 22) {
        Map temp = {
            'SKU' : t.SKU, 'finish' : t.finish
        };
        removeRing(null, temp, null);
      }
    }
    List temp = tierData.where((Ring element) => element.added == "Remove").toList();
    //print("Here's the list: $temp");

    switch (tierselected) {
      case 1:
        //print("tier 1 should load");
        tier = 1;
        contentLabel = "Tier 1";
        guaranteed = false;
        theRingsSelectedInTheTier = tierData.where((Ring element) => element.tier == 1).toList();
        parseTierItUp(theRingsSelectedInTheTier);

        tierLoaded = true;
        tier4GCost = 0;
        break;
      case 2:
        //print("tier 2 should load");
        tier = 2;
        contentLabel = "Tier 2";
        guaranteed = false;
        theRingsSelectedInTheTier = tierData.where((Ring element) => element.tier == 1 || element.tier == 2).toList();
        parseTierItUp(theRingsSelectedInTheTier);
        tierLoaded = true;

        tier4GCost = 0;
        break;
      case 3:
        //print("tier 3 should load");
        tier = 3;
        contentLabel = "Tier 3";
        guaranteed = false;
        theRingsSelectedInTheTier = tierData.where((Ring element) => element.tier == 1 || element.tier == 2 || element.tier == 3).toList();
        parseTierItUp(theRingsSelectedInTheTier);
        tierLoaded = true;

        tier4GCost = 0;
        break;
      case 4:
        //print("tier 4 should load");
        tier = 4;
        contentLabel = "Tier 4";
        guaranteed = false;
        theRingsSelectedInTheTier = tierData.where((Ring element) => element.tier == 1 || element.tier == 2 || element.tier == 3 || element.tier == 4).toList();
        parseTierItUp(theRingsSelectedInTheTier);
        tierLoaded = true;

        tier4GCost = 0;
        break;
      case 5:
        //print("tier 4G should load");
        tier = 5;
        contentLabel = "Tier 4 Guaranteed";
        guaranteed = true;
        theRingsSelectedInTheTier = tierData.where((Ring element) => element.tier == 1 || element.tier == 2 || element.tier == 3 || element.tier == 4).toList();
        parseTierItUp(theRingsSelectedInTheTier);

        tierLoaded = true;
        tier4GCost = 844;
        break;
      case 0:
        //print("tier 0 should load");
        tier = 0;
        contentLabel = "No Tier";
        guaranteed = false;
        theRingsSelectedInTheTier = [];
        parseTierItUp(theRingsSelectedInTheTier);

        tierLoaded = false;

        tier4GCost = 0;
        break;
    }
    addToDB();
  }

  parseTierItUp(theRingsSelectedInTheTier) {
    //print("Tier It Up, Baby!");
    /*for (var t in theRingsSelectedInTheTier) {
      //print(t.SKU);
      //print(t.finish);
    }*/

    for (var t in theRingsSelectedInTheTier) {
      Map temp = {'SKU' : t.SKU, 'finish' : t.finish};
      //print("temp $temp");
      removeRing(null, temp, null);
    }
    //print(theRingsSelectedInTheTier);
  }

  void setTierRingsToCleared() {
    for (Ring t in tierData) {
      if (tier == 0) {
        if (t.tier == 1 || t.tier == 2 || t.tier == 3 || t.tier == 4) {
          t.cleared = true;
          t.added = "Add";
          t.icon = "add";
        }
      }
      if (tier == 1) {
        if (t.tier == 2 || t.tier == 3 || t.tier == 4) {
          t.cleared = true;
          t.added = "Add";
          t.icon = "add";
        }
        if (t.tier == 1) {
          t.cleared = false;
          t.added = "Remove";
          t.icon = "clear";
        }
      }
      if (tier == 2) {
          if (t.tier == 3 || t.tier == 4) {
            t.cleared = true;
            t.added = "Add";
            t.icon = "add";
          }
          if (t.tier == 1 || t.tier == 2) {
            t.cleared = false;
            t.added = "Remove";
            t.icon = "clear";
          }
        }
      if (tier == 3) {
          if (t.tier == 4) {
            t.cleared = true;
            t.added = "Add";
            t.icon = "add";
          }
          if (t.tier == 1 || t.tier == 2 || t.tier == 3) {
            t.cleared = false;
            t.added = "Remove";
            t.icon = "clear";
          }
        }
      if (tier == 4) {
        if (t.tier == 1 || t.tier == 2 || t.tier == 3 || t.tier == 4) {
          t.cleared = false;
          t.added = "Remove";
          t.icon = "clear";
        }
      }
    }
  }

  void closeCustomNotification() {
    //print("Closing customDisplayAdded");
    customDisplayAdded = false;
  }

  //void clearTiers() {
    //openIt = false;

    /*if (!loadingfromDB) {
      selected = 0;
      $['menu-id2'].selected = 0;
      List<Ring> currentAdded = tierData.where((Ring element) => element.cleared == false).toList();

        for (Ring r in currentAdded) {
          if (r.tier != 0 || r.tier != 22) {
            r.cleared = true;
            r.icon = "add";
            r.added = "Add";
          }
      }


      removed.clear();
      finalRemoved = removed;


      currentTierSelection = $["menu-id"].selected;

      keepCost = false;


    }*/
    //setTier();
    //tierInfo = $["menu-id"].selected;

  //}

  /*void cancelTierChange() {
    doNotDoIt = true;
    $["menu-id"].selected = currentTierSelection;
    keepCost = true;
    openIt = false;
    openIt2 = false;
  }*/

  void addToDB() {
    print("addToDB hit");
    List master = [{"order_idx" : order_id, "tier" : tier, "client_idx" : client_id}];

    List customDisp = [{"acrylic" : acrylic, "top" : topSwatch, "side" : sideSwatch}];
    //print("Here you go schmoe");
    //print(customDisp);

    if (!loadingfromDB) {
      //print("actually adding to db");
      dbmaster.open()
      .then((_) => dbmaster.nuke())
      .then((_) => dbmaster.save(master, "master"));

      dbrings.open()
      .then((_) => dbrings.nuke())
      .then((_) => dbrings.save(finalRemoved, "removed"));

      dbotherrings.open()
      .then((_) => dbotherrings.nuke())
      .then((_) => dbotherrings.save(added, "added"));

      dbaccessories.open()
      .then((_) => dbaccessories.nuke())
      .then((_) => dbaccessories.save(finalAddedItem, "addeditem"));

      dbcustomdisplay.open()
      .then((_) => dbcustomdisplay.nuke())
      .then((_) => dbcustomdisplay.save(customDisp, "customdisplay"));

      dbcustomrings.open()
      .then((_) => dbcustomrings.nuke())
      .then((_) => dbcustomrings.save(typedSkus, "typedskus"));

      dbstockbalances.open()
      .then((_) => dbstockbalances.nuke())
      .then((_) => dbstockbalances.save(stockBalances, "stockbalances"));

      dbordernotes.open()
      .then((_) => dbordernotes.nuke())
      .then((_) => dbordernotes.save(orderNotes, "orderNotes"));

      //print("order notes: $orderNotes");
    }
  }

  void handleOrderNotes() {
    //print("hello");
    orderNotes = $["notes"].value;
    addToDB();
  }

  void doIt() {
    //print("doIt hit");
    if (masterld == null || masterld == 500 && removedld.isEmpty && addedld.isEmpty && addeditemld.isEmpty && typedskusld.isEmpty && stockbalancesld.isEmpty && ordernotesld.isEmpty) {
      loadingfromDB = false;
      return;

    } else {
      if (firstpass) {
      openLoadingWarning = true;
        firstpass = false;
      }
    }
  }



  void doIt2() {
  async((_) {
    List<Map> customer = [];
    List<Map> removed = [];
    List<Map> added = [];
    List<Map> accessories = [];
    List<Map> custom = [];
    List<Map> stockbalances = [];
    List<Map> orderdata = [{"notes" : ordernotesld}];

    for (var r in removedld) {
      removed.add({
        'SKU' : r['SKU'], 'finish' : r['finish']
      });
    }
    for (var a in addedld) {
      added.add({
        'SKU' : a['SKU'], 'finish' : a['finish'], 'notes' : a['notes']
      });
    }
    for (var a in addeditemld) {
      accessories.add({
        'SKU' : a['SKU'], 'finish' : a['finish'], 'notes' : a['notes']
      });
    }
    print("The Custom Display should be: $customdisplayld");

    if ( customdisplayld[0]["acrylic"] != null) {
      acrylic = customdisplayld[0]["acrylic"];
      Swatch currentAcrylic = swatchData.where((Swatch element) => element.name == acrylic && element.type == "acrylic").first;
      currentAcrylic.added = true;
    }
    if ( customdisplayld[0]["top"] != null) {
      topSwatch = customdisplayld[0]["top"];
      Swatch currentTop = swatchData.where((Swatch element) => element.name == topSwatch && element.type == "top").first;
      currentTop.added = true;
    }
    if ( customdisplayld[0]["side"] != null) {
      sideSwatch = customdisplayld[0]["side"];
      Swatch currentSide = swatchData.where((Swatch element) => element.name == sideSwatch && element.type == "side").first;
      currentSide.added = true;
    }

    for (var t in typedskusld) {
      custom.add({
        'sku' : t['sku'], 'finish' : t['finish'], 'price' : t['price']
      });
    }
    for (var s in stockbalancesld) {
      stockbalances.add({
        'id' : s['id'], 'price' : s['price']
      });
    }
    List master = [{"order_idx" : masterld[0]["order_idx"].toString(),"tier" : masterld[0]["tier"].toString(),"client_idx" : masterld[0]["client_idx"].toString()}];
    Map toSend = {
      "customer" : customer,
      "master" : master,
      "removed" : removed,
      "added" : added,
      "accessories" : accessories,
      "custom" : custom,
      "stockbalances" : stockbalances,
      "orderdata" : orderdata
    };

    print(toSend);

    fillTheOrder(toSend);

    createCustomCost();

    createSBCost();
  });
    //print("you got here at least");
    openLoadingWarning = false;
    hideLoadButton = true;
    async((_) => loadingfromDB = false);
    async((_) => $["barcodeinput"].focus());
  }

  void loadIndexedDBs() {
      //print("loadIndexedDBs hit");
      loadingfromDB = true;
      var elem;
      dbmaster.open()
      .then((_) {
        dbmaster.all()
        .listen((value) => masterld = value)
        .onDone(() {
          load2();

        });
      })

      .catchError((e) => elem = e.toString());

  }
  void load2() {
    var elem;
    dbrings.open()
    .then((_) {
      dbrings.all()
      .listen((value) => removedld = value)
      .onDone(() {
        load3();

      });
    })

    .catchError((e) => elem = e.toString());
  }
  void load3() {
    var elem;
    dbotherrings.open()
    .then((_) {
      dbotherrings.all()
      .listen((value) => addedld = value)
      .onDone(() {
        load4();

      });
    })

    .catchError((e) => elem = e.toString());
  }

  void load4() {
    var elem;
    dbaccessories.open()
    .then((_) {
      dbaccessories.all()
      .listen((value) => addeditemld = value)
      .onDone(() {
        load42();

      });
    })

    .catchError((e) => elem = e.toString());
  }

  void load42() {
    var elem;
    dbcustomdisplay.open()
    .then((_) {
      dbcustomdisplay.all()
      .listen((value) => customdisplayld = value)
      .onDone(() {
        load5();

      });
    })

    .catchError((e) => elem = e.toString());
  }

  void load5() {
    var elem;
    dbcustomrings.open()
    .then((_) {
      dbcustomrings.all()
      .listen((value) => typedskusld = value)
      .onDone(() {
        load6();

      });
    })

    .catchError((e) => elem = e.toString());
  }

  void load6() {
    var elem;
    dbstockbalances.open()
    .then((_) {
      dbstockbalances.all()
      .listen((value) => stockbalancesld = value)
      .onDone(() {

        load7();
      });
    })

    .catchError((e) => elem = e.toString());

  }

  void load7() {
    var elem;
    dbordernotes.open()
    .then((_) {
      dbordernotes.all()
      .listen((value) => ordernotesld = value)
      .onDone(() {
        //print(ordernotesld);
        orderNotes = ordernotesld;

        doIt();
      });
    })

    .catchError((e) => elem = e.toString());

  }

  void closeLoadWarning() {
    openLoadingWarning = false;
    loadingfromDB = false;
    orderNotes = "";
    addToDB();
    async((_) => $["barcodeinput"].focus());
  }

  void removeAdd(currentCleared) {
    if (tierLoaded) {
      removed.add({"SKU" : currentCleared.SKU, "finish" : currentCleared.finish, "price" :currentCleared.price});
    }
    added.removeWhere((item) => item["SKU"] == currentCleared.SKU && item["finish"] == currentCleared.finish);
    otherRingCost -= currentCleared.price;
  }
  void addRemove(currentCleared) {
    removed.removeWhere((item) => item["SKU"] == currentCleared.SKU);
    added.add({"SKU" : currentCleared.SKU, "finish" : currentCleared.finish, "price" : currentCleared.price, "tier" : currentCleared.tier, "notes" : currentCleared.notes});
    otherRingCost += currentCleared.price;
  }

  void removeRing(Event event, var detail, Element target) {

    String ringSku = event == null ? detail['SKU'] : (detail['item'] as CoreItem).dataset['sku'];
    String ringFinish = event == null ? detail['finish'] : (detail['item'] as CoreItem).dataset['finish'];

    Ring currentCleared = tierData.where((Ring element) => element.SKU == ringSku && element.finish == ringFinish).first;

    currentCleared.cleared = !currentCleared.cleared;

    if (currentCleared.icon == "clear") {
      currentCleared.icon = "add";
      currentCleared.added = "Add";
      //hidebarcodeRing = true;
      barcodenote = "REMOVED!";
    } else
    if (currentCleared.icon == "add") {
      currentCleared.icon = "clear";
      currentCleared.added = "Remove";
      barcodenote = "ADDED!";
    }

    if (currentCleared.cleared == true) {
      if (tier == 4 || tier == 5) {
        if (currentCleared.tier == 1 || currentCleared.tier == 2 || currentCleared.tier == 3 || currentCleared.tier == 4) {
          /*print("hippy skippy yippee $currentCleared");
          showRemoveRingWarning = true;*/
          removeAdd(currentCleared);
        }
      }
      if (tier == 3) {
        if (currentCleared.tier == 1 || currentCleared.tier == 2 || currentCleared.tier == 3) {
          removeAdd(currentCleared);
        }
        if (currentCleared.tier == 4) {

          added.removeWhere((item) => item["SKU"] == currentCleared.SKU && item["finish"] == currentCleared.finish);
          otherRingCost -= currentCleared.price;
        }
      }
      if (tier == 2) {
        if (currentCleared.tier == 1 || currentCleared.tier == 2) {
          removeAdd(currentCleared);
        }
        if (currentCleared.tier == 3  || currentCleared.tier == 4) {
          added.removeWhere((item) => item["SKU"] == currentCleared.SKU && item["finish"] == currentCleared.finish);
          otherRingCost -= currentCleared.price;
        }
      }
      if (tier == 1) {
        if (currentCleared.tier == 1) {
          if (currentCleared.cleared = true) {
            removeAdd(currentCleared);
          }
        }
        if (currentCleared.tier == 2 || currentCleared.tier == 3  || currentCleared.tier == 4) {
          added.removeWhere((item) => item["SKU"] == currentCleared.SKU && item["finish"] == currentCleared.finish);
          otherRingCost -= currentCleared.price;
        }
      }
      if (tier == 0) {
        if (currentCleared.tier == 1 || currentCleared.tier == 2 || currentCleared.tier == 3  || currentCleared.tier == 4) {
          added.removeWhere((item) => item["SKU"] == currentCleared.SKU && item["finish"] == currentCleared.finish);
          otherRingCost -= currentCleared.price;
        }
      }
      if (currentCleared.tier == 0) {
        added.removeWhere((item) => item["SKU"] == currentCleared.SKU && item["finish"] == currentCleared.finish);
        otherRingCost -= currentCleared.price;
      }
      if (currentCleared.tier == 22) {
        /*if (currentCleared.SKU.contains("DISPLAY")) {
          displayAdded = false;
        }*/
        if (currentCleared.SKU.contains("CUSTOM DISPLAY")) {
          print("custom display removed");
          customDisplayAdded = false;
          hideCustomDisplay = true;
        }

        addeditem.removeWhere((item) => item["SKU"] == currentCleared.SKU && item["finish"] == currentCleared.finish);
        if (currentCleared.price != null) {
          otherItemsCost -= currentCleared.price;
        }
      }
    } else {

      if (tier == 4 || tier == 5) {
        if (currentCleared.tier == 1 || currentCleared.tier == 2 || currentCleared.tier == 3 || currentCleared.tier == 4) {
          addRemove(currentCleared);
        }
      }
      if (tier == 3) {
        if (currentCleared.tier == 1 || currentCleared.tier == 2 || currentCleared.tier == 3) {
          addRemove(currentCleared);
        }
        if (currentCleared.tier == 4) {
          added.add({"SKU" : currentCleared.SKU, "finish" : currentCleared.finish, "price" : currentCleared.price, "tier" : currentCleared.tier, "notes" : currentCleared.notes});
          otherRingCost += currentCleared.price;
        }
      }
      if (tier == 2) {
        if (currentCleared.tier == 1 || currentCleared.tier == 2) {
          addRemove(currentCleared);
        }
        if (currentCleared.tier == 3  || currentCleared.tier == 4) {
          added.add({"SKU" : currentCleared.SKU, "finish" : currentCleared.finish, "price" :currentCleared.price, "tier" : currentCleared.tier, "notes" : currentCleared.notes});
          otherRingCost += currentCleared.price;
        }
      }
      if (tier == 1) {
        if (currentCleared.tier == 1) {
          addRemove(currentCleared);
        }
        if (currentCleared.tier == 2 || currentCleared.tier == 3  || currentCleared.tier == 4) {
          added.add({"SKU" : currentCleared.SKU, "finish" : currentCleared.finish, "price" :currentCleared.price, "tier" : currentCleared.tier, "notes" : currentCleared.notes});
          otherRingCost += currentCleared.price;
        }
      }
      if (tier == 0) {
        if (currentCleared.tier == 1 || currentCleared.tier == 2 || currentCleared.tier == 3  || currentCleared.tier == 4) {
          added.add({"SKU" : currentCleared.SKU, "finish" : currentCleared.finish, "price" :currentCleared.price, "tier" : currentCleared.tier, "notes" : currentCleared.notes});
          otherRingCost += currentCleared.price;
        }
      }
      if (currentCleared.tier == 0) {
        added.add({"SKU" : currentCleared.SKU, "finish" : currentCleared.finish, "price" :currentCleared.price, "tier" : currentCleared.tier, "notes" : currentCleared.notes});
        otherRingCost += currentCleared.price;
      }
      if (currentCleared.tier == 22) {
        /*if (currentCleared.SKU.contains("DISPLAY")) {
          displayAdded = true;
        }*/
        if (currentCleared.SKU.contains("CUSTOM DISPLAY")) {
          //print("test");
          customDisplayAdded = true;
          hideCustomDisplay = false;
          selected = 12;
          print("custom display added");
        }
        addeditem.add({"SKU" : currentCleared.SKU, "finish" : currentCleared.finish, "price" :currentCleared.price, "notes" : currentCleared.notes});
        if (currentCleared.price != null) {
          otherItemsCost += currentCleared.price;
        }
      }
      hideLoadButton = true;
    }



    async((_) => $["barcodeinput"].focus());
    finalRemoved = removed;
    if (tier == 0) {
      finalAdded = [];
      finalAddedPlus = added;
    }
    if (tier == 1) {
      finalAdded = added.where((List element) => element['tier'] == 1);
      finalAddedPlus = added.where((List element) => element['tier'] == 0 || element['tier'] == 2 || element['tier'] == 3 || element['tier'] == 4);
    }
    if (tier == 2) {
      finalAdded = added.where((List element) => element['tier'] == 1 || element['tier'] == 2);
      finalAddedPlus = added.where((List element) => element['tier'] == 0 || element['tier']== 3 || element['tier'] == 4);
    }
    if (tier == 3) {
      finalAdded = added.where((List element) => element['tier'] == 1 || element['tier'] == 2 || element['tier'] == 3);
      finalAddedPlus = added.where((List element) => element['tier'] == 0 || element['tier'] == 4);
    }
    if (tier == 4 || tier == 5) {
      finalAdded = added.where((List element) => element['tier'] == 1 || element['tier'] == 2 || element['tier'] == 3  || element['tier'] == 4);
      finalAddedPlus = added.where((List element) => element['tier'] == 0);
    }

    //print("added is $added");
    //print("finalAdded is $finalAdded");
    finalAddedItem = addeditem;
    setSubTotalCost();



    addToDB();

    if (finalAdded.isNotEmpty) {
      hideRingsInOrder = false;
    } else {
      hideRingsInOrder = true;
    }
    if (finalAddedPlus.isNotEmpty) {
      hideOtherRingsInOrder = false;
    } else {
      hideOtherRingsInOrder = true;
    }
    if (finalRemoved.isNotEmpty) {
      hideRemovedItems = false;
    } else {
      hideRemovedItems = true;
    }
    if (finalAddedItem.isNotEmpty) {
      hideOtherItemsInOrder = false;
    } else {
      hideOtherItemsInOrder = true;
    }
    //sortFinalAdded();
    //barcodeRing.removeWhere((Ring element) => element.SKU == currentCleared.SKU && element.finish == currentCleared.finish);

  }

  bool checkremoved(currentCleared) {
    for (var r in removed) {
      if (r['SKU'] == currentCleared.SKU) {
        removed.remove(r);
        return false;
      }
    }
    return true;
  }
  void sortFinalAdded() {
    //print(finalAdded);
    finalAdded.sort((Map a, Map b) {
      if (a["tier"] < b["tier"]) {
        return 1;
      }
      else if (a["tier"] > b["tier"]) {
        return -1;
      }
      return 0;
    });
  }

  void clearRing(Event event, var detail, Element target) {
    var sku = target.dataset["sku"];
    var finish = target.dataset["finish"];
    Map temp = {'SKU' : sku, 'finish' : finish};
    removeRing(null, temp, null);
  }
  void zoomRing(Event event, var detail, Element target) {
    ringZoomData = target.dataset["sku"];
    String ringFinishData = target.dataset["finish"];

    Ring currentZoom = tierData.where((Ring element) => element.SKU == ringZoomData && element.finish == ringFinishData).first;
    ringZoomImage = currentZoom.image;
    saveSelected = selected;
    hideZoom = false;
  }

  void closeZoom(){
    hideZoom = true;
    async((_) => $["barcodeinput"].focus());
  }


  /*void loadOtherRingsForBarcode() {
    //print("Loading other tabs baby!");

  }*/

  void phpDataLoadedold(Event event, var detail, Element target) {
    List<Map> mapList2 = detail['response'];

    //print("mapList 2 $mapList2");

  }

  void phpDataLoaded(Event event, var detail, Element target) {

    mapList = detail['response'];

    //print("mapList $mapList");

    tierData = mapList.map((Map element) => new Ring.fromMap(element)).toList();
    //print("hidy  ho $tierData");
    for (var t in tierData) {

        t.cleared = !t.cleared;
        t.added = "Add";
        t.icon = "add";

    }
    /*currentTier = tierData.where((Ring element) => element.tier == 1 || element.tier == 2 || element.tier == 3 || element.tier == 4).toList();
    tierOne = tierData.where((Ring element) => element.tier == 1).toList();
    tierTwo = tierData.where((Ring element) => element.tier == 1 || element.tier == 2).toList();
    tierThree = tierData.where((Ring element) => element.tier == 1 || element.tier == 2 || element.tier == 3).toList();
    tierFour = tierData.where((Ring element) => element.tier == 1 || element.tier == 2 || element.tier == 3 || element.tier == 4).toList();*/

    //tierFourHolder = tierData.where((Ring element) => element.tier == 1 || element.tier == 2 || element.tier == 3 || element.tier == 4).toList();
    tier = 0;
    guaranteed = false;
    listclass = "regulartier";
    hideguarantee = true;

    //updatedOrderImages();

    openLoading = false;
    openLogIn = true;

    chooseMenuItem = $['menu-id1'].selected;
    //print("menu item chosen $chooseMenuItem");

  }

  void coreOverlayDone() {
    //print("It's done!");
    async((_) => $["pin"].focus());
  }


  //void othernewTab([Event event, var detail, Element target]) {
    //handleSelection(selectedLabel);
/*    if (othersubselected == 1) {
      if (othermeteoriteList.isEmpty) {
        othermeteoriteList = tierData.where((Ring element) => element.category == "Meteorite" && element.tier != 22).toList();
      }
    }
    if (othersubselected == 2) {
      if (othercamoList.isEmpty) {
        othercamoList = tierData.where((Ring element) => (element.category == "Camo" || element.category == "King's Camo")  && element.tier != 22).toList();
      }
    }
    if (othersubselected == 3) {
      if (othertitaniumList.isEmpty) {
        othertitaniumList = tierData.where((Ring element) => element.category == "Titanium" && element.tier != 22).toList();
      }
    }
    if (othersubselected == 4) {
      if (othercarbonfiberList.isEmpty) {
        othercarbonfiberList = tierData.where((Ring element) => element.category == "Carbon Fiber" && element.tier != 22).toList();
      }
    }
    if (othersubselected == 5) {
      if (othercobaltchromeList.isEmpty) {
        othercobaltchromeList = tierData.where((Ring element) => element.category == "Cobalt Chrome" && element.tier != 22).toList();
      }
    }
    if (othersubselected == 6) {
      if (otherdamascusList.isEmpty) {
        otherdamascusList = tierData.where((Ring element) => element.category == "Damascus" && element.tier != 22).toList();
      }
    }
    if (othersubselected == 7) {
      if (othertungstenceramicList.isEmpty) {
        othertungstenceramicList = tierData.where((Ring element) => element.category == "Tungsten Ceramic" && element.tier != 22).toList();
      }
    }
    if (othersubselected == 8) {
      if (otherzirconiumList.isEmpty) {
        otherzirconiumList = tierData.where((Ring element) => element.category == "Zirconium" && element.tier != 22).toList();
      }
    }
    if (othersubselected == 9) {
      if (otherotherList.isEmpty) {
        otherotherList = tierData.where((Ring element) => (
            element.category == "Mokume" ||
            element.category == "Elysium" ||
            element.category == "Ceramic" ||
            element.category == "Precious Metal" ||
            element.category == "Goodyear" ||
            element.category == "Hard Wood" ||
            element.category == "Platinum" ||
            element.category == "MossyOak" ||
            element.category == "Fable" ||
            element.category == "Fable Camo" ||
            element.category == "Stainless Steel"
        )  && element.tier != 22).toList();
      }
    }*/
  //}

  /*void newTab([Event event, var detail, Element target]) {

    if (subselected == 1) {
      if (meteoriteList.isEmpty) {
        meteoriteList = tierData.where((Ring element) => element.category == "Meteorite" && element.tier != 0).toList();
        async((_) => categoryLoadedList[METEORITE] = true);
      }
    }
    if (subselected == 2) {
      if (camoList.isEmpty) {
        camoList = tierData.where((Ring element) => (element.category == "Camo" || element.category == "King's Camo") && element.tier != 0).toList();
      }
    }
    if (subselected == 3) {
      if (titaniumList.isEmpty) {
        titaniumList = tierData.where((Ring element) => element.category == "Titanium" && element.tier != 0).toList();
      }
    }
    if (subselected == 4) {
      if (carbonfiberList.isEmpty) {
        carbonfiberList = tierData.where((Ring element) => element.category == "Carbon Fiber" && element.tier != 0).toList();
      }
    }
    if (subselected == 5) {
      if (cobaltchromeList.isEmpty) {
        cobaltchromeList = tierData.where((Ring element) => element.category == "Cobalt Chrome" && element.tier != 0).toList();
      }
    }
    if (subselected == 6) {
      if (damascusList.isEmpty) {
        damascusList = tierData.where((Ring element) => element.category == "Damascus" && element.tier != 0).toList();
      }
    }
    if (subselected == 7) {
      if (tungstenceramicList.isEmpty) {
        tungstenceramicList = tierData.where((Ring element) => element.category == "Tungsten Ceramic" && element.tier != 0).toList();
      }
    }
    if (subselected == 8) {
      if (zirconiumList.isEmpty) {
        zirconiumList = tierData.where((Ring element) => element.category == "Zirconium" && element.tier != 0).toList();
      }
    }

  }*/

  void loginLoaded(Event event, var detail, Element target) {

    mapListLogin = detail['response'];
    loginData = mapListLogin.map((Map element) => new User.fromMap(element)).toList();

    loginList = loginData.toList();
    /*for (User u in loginData) {

    }*/
  }

  displayWarning () {
    showDisplayWarning = !showDisplayWarning;
  }

  void submitOrder() {

    barcodeload = true;
    orderimagesload = true;
    /*newTab(null, {
        "isSelected": true
    });*/

    tempSelected = selected;

    hideZoom = true;
    hideSubmitButton = true;
    hideButtons = false;
    hideMenus = true;
    updatedOrderImages();
    selected = 3;
    scroll();
    //hideScrollButton = true;
    if (stockBalances.isNotEmpty) {
      hideStockBalance = false;
    }
  }

  void updatedOrderImages() {

      if (contentLabel == "No Tier") {
        hideguaranteedinreview = true;
        orderImages = toObservable(tierData.where((Ring element) => element.tier == 100).toList());
      }

      if (contentLabel == "Tier 1") {
        hideguaranteedinreview = true;
        orderImages = toObservable(tierData.where((Ring element) => element.cleared == false && (element.tier == 1)).toList());
      }

      if (contentLabel == "Tier 2") {
        hideguaranteedinreview = true;
        orderImages = toObservable(tierData.where((Ring element) => element.cleared == false && (element.tier == 1 || element.tier == 2)).toList());
      }

      if (contentLabel == "Tier 3") {
        hideguaranteedinreview = true;
        orderImages = toObservable(tierData.where((Ring element) => element.cleared == false && (element.tier == 1 || element.tier == 2 || element.tier == 3)).toList());
      }

      if (contentLabel == "Tier 4") {
        hideguaranteedinreview = true;
        orderImages = toObservable(tierData.where((Ring element) => element.cleared == false && (element.tier == 1 || element.tier == 2 || element.tier == 3 || element.tier == 4)).toList());
      }

      if (contentLabel == "Tier 4 Guaranteed") {
        hideguaranteedinreview = false;
        orderImages = toObservable(tierData.where((Ring element) => element.cleared == false && (element.tier == 1 || element.tier == 2 || element.tier == 3 || element.tier == 4)).toList());
      }

      //orderAccessories = accessories.where((Ring element) => element.cleared == false).toList();
      orderAccessories.clear();
      for (var a in finalAddedItem) {
        orderAccessories.add(tierData.where((Ring element) => element.SKU == a['SKU'] && element.finish == a['finish']).first);
      }
      //print(orderAccessories);
      orderOtherRings.clear();
      orderOtherRingsPlus.clear();
      for (var f in finalAdded) {
        orderOtherRings.add(tierData.where((Ring element) => element.SKU == f["SKU"] && element.finish == f["finish"]).first);
      }
      for (var f in finalAddedPlus) {
        orderOtherRingsPlus.add(tierData.where((Ring element) => element.SKU == f["SKU"] && element.finish == f["finish"]).first);
      }

  }

  void cancelSubmit() {
    selected = tempSelected;
    scroll();
    hideSubmitButton = false;
    hideButtons = true;
    hideMenus = false;
    hideScrollButton = false;
  }
  @observable String dateNewCss = "fieldokay";
  @observable String storeNameNewCss = "fieldokay";
  @observable String lastNameNewCss = "fieldokay";
  @observable String firstNameNewCss = "fieldokay";
  @observable String addressNewCss = "fieldokay";
  @observable String cityNewCss = "fieldokay";
  @observable String stateNewCss = "fieldokay";
  @observable String zipNewCss = "fieldokay";
  @observable String phoneNewCss = "fieldokay";
  @observable String emailNewCss = "fieldokay";
  @observable String termsNewCss = "fieldokay";
  @observable String dateCss = "fieldokay";
  @observable String storeNameCss = "fieldokay";
  @observable String lastNameCss = "fieldokay";
  @observable String firstNameCss = "fieldokay";
  @observable String addressCss = "fieldokay";
  @observable String cityCss = "fieldokay";
  @observable String stateCss = "fieldokay";
  @observable String zipCss = "fieldokay";
  @observable String phoneCss = "fieldokay";
  @observable String emailCss = "fieldokay";
  @observable String termsCss = "fieldokay";
  bool checkFields() {
    if (partnerSelected == 0) {
      //print("hit checking for empty values");
      if ($['dateNew'].value.isEmpty) {
        dateNewCss = "fieldempty";
        return false;
      } else {
        dateNewCss = "fieldokay";
      }
      if ($['storeNameNew'].value.isEmpty) {
        storeNameNewCss = "fieldempty";
        return false;
      } else {
        storeNameNewCss = "fieldokay";
      }
      if ($['lastNameNew'].value.isEmpty) {
        lastNameNewCss = "fieldempty";
        return false;
      } else {
        lastNameNewCss = "fieldokay";
      }
      if ($['firstNameNew'].value.isEmpty) {
        firstNameNewCss = "fieldempty";
        return false;
      } else {
        firstNameNewCss = "fieldokay";
      }
      if ($['addressNew'].value.isEmpty) {
        addressNewCss = "fieldempty";
        return false;
      } else {
        addressNewCss = "fieldokay";
      }
      if ($['cityNew'].value.isEmpty) {
        cityNewCss = "fieldempty";
        return false;
      } else {
        cityNewCss = "fieldokay";
      }
      if ($['stateNew'].value.isEmpty) {
        stateNewCss = "fieldempty";
        return false;
      } else {
        stateNewCss = "fieldokay";
      }
      if ($['zipNew'].value.isEmpty) {
        zipNewCss = "fieldempty";
        return false;
      } else {
        zipNewCss = "fieldokay";
      }
      if ($['phoneNew'].value.isEmpty) {
        phoneNewCss = "fieldempty";
        return false;
      } else {
        phoneNewCss = "fieldokay";
      }
      if ($['emailNew'].value.isEmpty) {
        emailNewCss = "fieldempty";
        return false;
      } else {
        emailNewCss = "fieldokay";
      }
      if ($['termsNew'].value.isEmpty) {
        termsNewCss = "fieldempty";
        return false;
      } else {
        termsNewCss = "fieldokay";
      }
    }
    if (partnerSelected == 1) {
      //print("hit checking for empty values");
      if ($['date'].value.isEmpty ) {
        dateCss = "fieldempty";
        return false;
      } else {
        dateCss = "fieldokay";
      }
      var clientselected = $['clientResults'].selection;
      if (clientselected == null) {
        storeNameCss = "fieldempty";
        hideStoreNameWarning = false;
        return false;

      } else {
        hideStoreNameWarning = true;
        storeNameCss = "fieldokay";
      }
      if ($['lastName'].value.isEmpty) {
        lastNameCss = "fieldempty";
        return false;
      } else {
        lastNameCss = "fieldokay";
      }
      if ($['firstName'].value.isEmpty) {
        firstNameCss = "fieldempty";
        return false;
      } else {
        firstNameCss = "fieldokay";
      }
      if ($['address'].value.isEmpty) {
        addressCss = "fieldempty";
        return false;
      } else {
        addressCss = "fieldokay";
      }
      if ($['city'].value.isEmpty) {
        cityCss = "fieldempty";
        return false;
      } else {
        cityCss = "fieldokay";
      }
      if ($['state'].value.isEmpty) {
        stateCss = "fieldempty";
        return false;
      } else {
        stateCss = "fieldokay";
      }
      if ($['zip'].value.isEmpty) {
        zipCss = "fieldempty";
        return false;
      } else {
        zipCss = "fieldokay";
      }
      if ($['phone'].value.isEmpty) {
        phoneCss = "fieldempty";
        return false;
      } else {
        phoneCss = "fieldokay";
      }
      if ($['email'].value.isEmpty) {
        emailCss = "fieldempty";
        return false;
      } else {
        emailCss = "fieldokay";
      }
      if ($['terms'].value.isEmpty) {
        termsCss = "fieldempty";
        return false;
      } else {
        termsCss = "fieldokay";
      }
    }
    return true;
  }

  void signatureSubmit() {

    if (!checkFields()) {
      showCannotHaveBlank = true;
      return;
    }


    hideOtherButtons = true;
    hideCloseSignatureButton = false;
    Map email = {};

    if (partnerSelected == 0) {
      //print("next step hit...writing to sb");
      lastName = $['lastNameNew'].value;
      email["email"] = $['emailNew'].value;
      //sb.writeln("New Partner<br>");
      //sb.writeln("Date: " + $['dateNew'].value + "<br>");
      //sb.writeln("Store Name: " + $['storeNameNew'].value + "<br>");
      //sb.writeln("Last Name: " + $['lastNameNew'].value + "<br>");
      //sb.writeln("First Name: " + $['firstNameNew'].value + "<br>");
      //sb.writeln("Address: " + $['addressNew'].value + "<br>");
      //sb.writeln("City: " + $['cityNew'].value + "<br>");
      //sb.writeln("State: " + $['stateNew'].value + "<br>");
      //sb.writeln("Zip: " + $['zipNew'].value + "<br>");
      //sb.writeln("Phone: " + $['phoneNew'].value + "<br>");
      //sb.writeln("e-mail: " + $['emailNew'].value + "<br>");
      //sb.writeln("Terms: " + $['termsNew'].value + "<br>");
      //sb.writeln("Notes: " + $['notesNew'].value + "<br>");
    }
    if (partnerSelected == 1) {
      lastName = $['lastName'].value;
      email["email"] = $['email'].value;
      //sb.writeln("Existing Partner<br>");
      //sb.writeln("Date: " + $['date'].value + "<br>");
      //sb.writeln("Store Name: " + $['storeName'].value + "<br>");
      //sb.writeln("Last Name: " + $['lastName'].value + "<br>");
      //sb.writeln("First Name: " + $['firstName'].value + "<br>");
      //sb.writeln("Address: " + $['address'].value + "<br>");
      //sb.writeln("City: " + $['city'].value + "<br>");
      //sb.writeln("State: " + $['state'].value + "<br>");
      //sb.writeln("Zip: " + $['zip'].value + "<br>");
      //sb.writeln("Phone: " + $['phone'].value + "<br>");
      //sb.writeln("e-mail: " + $['email'].value + "<br>");
      //sb.writeln("Terms: " + $['terms'].value + "<br>");
      //sb.writeln("Notes: " + $['notes'].value + "<br>");
    }
    //sb.writeln("Sales Rep: $currentUser<br>");
    //sb.writeln("Sales Rep e-mail: $currentUserEmail<br>");
    //sb.writeln("Your shipping costs are \$$shippingCosts<br>");
    //sb.writeln("Order Total: \$$totalPlusShipping<br>");
    hideSignature = false;
    selected = 6;
    hideScrollButton = true;
    finalHidden = true;
    scroll();

    //new stuff
    upload();

    //old stuff
    //boundData = ""; //sb.toString();
    //print(boundData);
    //var temp;

    //Map lastNameMap = {"lastName" :  lastName};

    //email["repEmail"] = currentUserEmail;
    //var lastnamedata = JSON.encode(lastNameMap);

    /*HttpRequest.request('$pathToPhp/lastname.php', method: 'POST', mimeType: 'application/json', sendData: lastnamedata).catchError((obj) {
      //print(obj);
    }).then((HttpRequest val) {
      //print('response: ${val.responseText} $lastnamedata');
    }, onError: (e) => print("error"));*/
    async((_){
      var firstname;
      var lastname;
      var storename;
      if (partnerSelected == 0) {
        firstname = $['firstNameNew'].value;
        lastname = $['lastNameNew'].value;
        storename = $['storeNameNew'].value;
      }
      if (partnerSelected == 1) {
        firstname = $['firstName'].value;
        lastname = $['lastName'].value;
        storename = store_name;
      }

      //print(partnerSelected);

      sendMap = {"repEmail" : currentUserEmail, "firstName" : firstname, "lastName" : lastname, "storeName" : storename};
      var data = JSON.encode(sendMap);
      HttpRequest.request('$pathToPhp/reminder.php', method: 'POST', mimeType: 'application/json', sendData: data).catchError((obj) {

        //print(obj);
      }).then((HttpRequest val) {
        print('${val.responseText}');
      }, onError: (e) => print("error"));
    });

  }


  void closeSignature() {
    hideCloseSignatureButton = true;
    String fileName;
    if (partnerSelected == 0) {
      fileName = $['lastNameNew'].value;
    }
    if (partnerSelected == 1) {
      fileName = $['lastName'].value;
    }
    pathToPngFile = "$pathToSignatures$FILE_PRE_FIX$fileName$FILE_TYPE";
    //print(pathToPngFile);
    ImageElement image = new ImageElement(src: pathToPngFile);

    imageLoadSub = image.onLoad.listen(onData, onError: imageLoadError, cancelOnError: true);
    image.onError.listen(imageLoadError);
  }

  onData(Event e) {
    upload();
    imageLoadSub.cancel();
  }

  imageLoadError(Event e) {
    ImageElement image2 = new ImageElement(src: "$pathToSignatures$FILE_PRE_FIX$FILE_TYPE");
    imageLoadSub = image2.onLoad.listen(dataSuccessTwo, onError: image2LoadError, cancelOnError: true);
    image2.onError.listen(image2LoadError);
  }

  dataSuccessTwo(Event e) {
    lastName = "temp";
    upload();
    imageLoadSub.cancel();
  }

  image2LoadError(Event e) {
    hideSignatureRequired = false;
  }



   void upload() {
     //selected = 7;
     //scroll();
     //hideSignature = true;
     if (partnerSelected == 0) {
      orderName = $['firstNameNew'].value + " " + lastName;
     }
     if (partnerSelected == 1) {
       orderName = $['firstName'].value + " " + lastName;
     }
     uploadit = true;
     saveOrderToPHP();
   }

  void uploadAway() {

    if (partnerSelected == 0) {
      orderemail = $['emailNew'].value;
    }
    if (partnerSelected == 1) {
      orderemail = $['email'].value;
    }
    async((_) {
      //print("The Order ID string being sent is: $orderID");
      sendMap = {"body" : boundData, "lastName" : lastName, "email" : orderemail, "repEmail" : currentUserEmail, "orderID" : orderID};
      var data = JSON.encode(sendMap);
      HttpRequest.request('$pathToPhp/email_order.php', method: 'POST', mimeType: 'application/json', sendData: data).catchError((obj) {

        //print(obj);
      }).then((HttpRequest val) {
        //print('The data to email response is: ${val.responseText}');
      }, onError: (e) => print("error"));
    });

    tierInfo = 500;
    finalRemoved = [];
    finalAdded = [];
    finalAddedPlus = [];
    finalAddedItem = [];
    typedSkus = [];
    stockBalances = [];
    addToDB();
  }

  void emailManually() {
    if (partnerSelected == 0) {
      orderemail = $['emailNew'].value;
    }
    if (partnerSelected == 1) {
      orderemail = $['email'].value;
    }
    openEmailedNotice = true;


  }

  void warning() {
    hideSignature = !hideSignature;
    backwarning = !backwarning;
  }
  void back() {
    hideSignature = true;
    backwarning = false;
    selected = 3;
    scroll();
    hideButtons = false;
    hideOtherButtons = true;
  }

  void back2() {
    selected = 4;
    scroll();
  }

  void termsWarning() {
    showTermsWarning = !showTermsWarning;
  }
  void continueSubmit() {
    //print ("continueSubmitHit");

    for (var a in finalAddedItem) {
      //print(a);
      if (a["SKU"].contains("DISPLAY")) {
        displayAdded = true;
      }
    }

    if (!displayAdded) {
      displayWarning();
      return;
    }

    if (contentLabel == "Tier 4 Guaranteed") {
      if ($["guaranteecheck"].checked == false) {

        termsWarning();
        return;
      }
    }
    hideSignature = true;
    selected = 4;
    scroll();
    hideButtons = true;
    hideOtherButtons = false;

    /*List tier = [];
    for (var o in orderImages) {
      tier.add(tierData.where((Ring element) => element.SKU == o.SKU && element.finish == o.finish).first);
    }*/

    List temp;
    //sb.writeln("This is an order for the following tier(s):<br>");
    //sb.writeln("$contentLabel - ");
    /*sb.write("\$$tier4GCost<br>");*/
    //sb.write("with the following rings:<br>");
    /*for (var t in tier) {
      //sb.writeln(t.SKU);
      //sb.writeln(t.finish);
      //sb.writeln(t.price);
      //sb.writeln("<br>");
    }*/

    if (finalAdded != null || finalAdded != []) {

      //sb.writeln("<br>");
      //sb.writeln("The following rings have been added:<br>");
      for (var f in finalAdded) {
        //sb.writeln(f['SKU']);
        //sb.writeln(f['finish']);
        //sb.writeln("\$");
        //sb.write(f['price']);
        //sb.writeln("<br>");
      }
    }
    if (finalRemoved != null || finalRemoved != []) {
      //temp = finalRemoved.toList(); ***
      //sb.writeln("<br>");
      //sb.writeln("The following rings have been removed from the selected tier:<br>");
      for (var f in finalRemoved) {
        //sb.writeln(f['SKU']);
        //sb.writeln(f['finish']);
        //sb.writeln("<br>");
      }
    }
    if (finalAddedItem != null || finalAddedItem != []) {

      //sb.writeln("<br>");
      //sb.writeln("The following other items have been added:<br>");
      for (var f in finalAddedItem) {
        //sb.writeln(f['SKU']);
        //sb.writeln(f['finish']);
        //sb.writeln("\$");
        //sb.write(f['price']);
        //sb.writeln("<br>");
      }
    }
    if (typedSkus != null) {
      temp = typedSkus.toList();
      //sb.writeln("<br>");
      //sb.writeln("The following custom items have been added:<br>");
      for (var i = 0; i < temp.length; i++) {
        //sb.writeln(temp[i]["sku"]);
        //sb.writeln(" - \$");
        //sb.writeln(temp[i]["price"]);
        //sb.writeln("<br>");
      }
    }
    if (stockBalances.isNotEmpty) {
      temp = stockBalances.toList();
      //sb.writeln("<br>");
      //sb.writeln("The following stock balance has been added.<br>");
      //sb.writeln("Stock balance must be returned to Lashbrook within 10 business days of receipt of this product. Amount not to exceed:<br>");
      for (var i = 0; i < temp.length; i++) {
        //sb.writeln(temp[i]["id"]);
        //sb.writeln(" - \$");
        //sb.writeln(temp[i]["price"]);
        //sb.writeln("<br>");
      }
      //sb.writeln("If stock is not returned within 10 business days of receipt of this product, invoice will be amended to full amount.<br>");
    }
    if (guaranteed) {
      //sb.writeln("<h2>Guaranteed Sale Program</h2>");
      //sb.writeln("<p><b>Offer:</b>");
      //sb.writeln("<p>1. If a store purchases a Tier 4 and The Knot, Lashbrook will guarantee at least a one-time turn of the investment during the first year that they have the product in the case.  If the store fails to sell \$15,000, at wholesale, from the case and/or in special orders, Lashbrook will buy back product in an amount equal to the shortfall.");
      //sb.writeln("<br>2. Total Investment:   \$14,997");
      //sb.writeln("<br>3. 30/60/90 (Three payments of \$4999)");
      //sb.writeln("<br>4. No substitutions to the Tier 4.");
      //sb.writeln("<br>5. No stock balancing, unless initiated by Lashbrook, during the first year.</p>");

      //sb.writeln("<p><b>The following requirements must be met in order to qualify for buyback:</b>");
      //sb.writeln("<br>1. Payment terms must be met within a 10 day grace period.");
      //sb.writeln("<br>2. Store personnel must do Lashbrook training within 30 days of receipt of merchandise.");
      //sb.writeln("<br>3. Store must provide the information necessary for proper Knot promotion within ten business days of each request.");
      //sb.writeln("<br>4. Product must be properly displayed.");
      //sb.writeln("<br>5. Store will have 60 days from end of 12 month period to notify us that they want a buyback.</p>");

      //sb.writeln("<p><b>Lashbrook buyback commitment:</b>");
      //sb.writeln("<br>1. If conditions are met, Lashbrook will buy back the Lashbrook product that the jeweler chooses, also with 30/60/90 terms.  For example, if a jeweler sells only \$9,000 at wholesale during the first year, he may choose \$6000 of product to sell back and Lashbrook will pay \$2000/month for three months.</p>");
    }
    //sb.writeln("<br>");
    //sb.writeln("Your sub-total is:<br>");
    //sb.writeln("\$"+subTotalCost.toString() + "<br>");


    if (inRange(subTotalCost, 0, 3001)) {
      shippingCosts = 20;
    }
    if (inRange(subTotalCost, 3000, 6001)) {
      shippingCosts = 35;
    }
    if (inRange(subTotalCost, 6000, 10001)) {
      shippingCosts = 50;
    }
    if (subTotalCost > 10000) {
      shippingCosts = 75;
    }

    totalPlusShipping = subTotalCost + shippingCosts;

  }

  void logIn(Event event, var detail, Element target) {

    failedLogin = "The username or password you entered is incorrect. Please try again.";
  }

  void typeInASku() {
    showTypeSku = !showTypeSku;
  }

  void typedSkuOpened() {
    async((_) => $['customSku'].focus());
  }

  void stockBalanceOpened() {
    async((_) => $['stockBalancePrice'].focus());
  }

  void handleStockBalanceKeyEvent(KeyboardEvent event) {

    //String data = $['storeName'].value;

    KeyEvent keyEvent = new KeyEvent.wrap(event);
    if (keyEvent.keyCode == KeyCode.ENTER) {
      event.preventDefault();
      submitStockBalance();
    }
    //print("key pressed");

  }
  void handleTypedSkuKeyEvent(KeyboardEvent event) {

    //String data = $['storeName'].value;

    KeyEvent keyEvent = new KeyEvent.wrap(event);
    if (keyEvent.keyCode == KeyCode.ENTER) {
      event.preventDefault();
      submitTypeSku();
    }
    //print("key pressed");

  }
  void stockBalance() {
    showStockBalance = !showStockBalance;
  }

  void closeTypeSku() {
    showTypeSku = false;
  }
  void closeStockBalance() {
    showStockBalance = false;
  }

  void submitTypeSku() {
    customSku = $['customSku'].value;
    customFinish = $['customFinish'].value;
    customSkuPrice = $['customSkuPrice'].value;
    if (customSkuPrice.isEmpty || customSku.isEmpty) {
      warningtext = "Fields may not be empty";
      return;
    }
    int tempCSPrice = int.parse(customSkuPrice);

    typedSkus.add({
        'sku' : customSku, 'finish' : customFinish, 'price' : tempCSPrice
    });
    addToDB();

    if (typedSkus.isNotEmpty) {
      hideCustomSkus = false;
    }

    createCustomCost();

    $['customSku'].value = null;
    $['customFinish'].value = null;
    $['customSkuPrice'].value = null;

    hideLoadButton = true;
  }

  void submitStockBalance() {
    sbid = stockBalances.length + 1;
    customStockBalancePrice = $['stockBalancePrice'].value;

    if (customStockBalancePrice.isEmpty) {
      warningtext = "Field may not be empty";
      return;
    }
    int tempSBPrice = int.parse(customStockBalancePrice);
    if (tempSBPrice > 0) {
      tempSBPrice *= -1;
    }

    stockBalances.add({
        'id' : sbid, 'price' : tempSBPrice
    });
    addToDB();

    createSBCost();

    $['stockBalancePrice'].value = null;
    if (stockBalances.isNotEmpty) {
      hideStockBalances = false;
    }
    hideLoadButton = true;
  }

  void createCustomCost() {
    customcost = 0;
    for (Map m in typedSkus) {
      customcost += m["price"];

    }
    setSubTotalCost();
    closeTypeSku();
  }
  void createSBCost() {
    sbcost = 0;
    for (Map m in stockBalances) {
      sbcost += m["price"];

    }
    setSubTotalCost();
    closeStockBalance();
  }

  void removeTypedSku(Event event, var detail, Element target) {
    var tempSku = target.dataset['sku'];
    var tempFinish = target.dataset['finish'];

    typedSkus.removeWhere((Map element) => element['sku'] == tempSku && element['finish'] == tempFinish);
    createCustomCost();
    if (typedSkus.isEmpty) {
      hideCustomSkus = true;
    }
  }

  void removeStockBalance(Event event, var detail, Element target) {
    int temp = int.parse(target.dataset['id']);
    stockBalances.removeWhere((Map element) => element['id'] == temp);
    createSBCost();
    if (stockBalances.isEmpty) {
      hideStockBalances = true;
    }
  }

  void checkPinInput(){
    //print($['pin'].value);
    String temp = $['pin'].value;
    int length = temp.length;
    //print(length);
    try {
      checkPin = [temp[0], temp[1], temp[2], temp[3]];

    } catch(exception, stackTrace) {
      return;
    }
    for (User p in loginData) {
      if (checkPin.toString() == p.pin.toString()) {
        unlockApp();
      }
    }
  }

  void unlockApp() {
    openLogIn = false;
    hideCoverApp = true;
    hideSubmitButton = false;
    hideSaveButton = false;
    User tempCurrentUser = loginData.where((User element) => element.pin.toString() == checkPin.toString()).first;

    currentUser = tempCurrentUser.toString();

    currentUserEmail = tempCurrentUser.email.toString();
    hideScrollButton = false;
    loadIndexedDBs();
    async((_) => $["barcodeinput"].focus());
    //getWidthHeight();

  }

  void numpadAction(Event event, var detail, Element target) {
    int tempnum = int.parse(target.dataset["num"]);

    if (checkPin.length < 4) {
      checkPin.add(tempnum);
      pin1 = "*";
      if (checkPin.length == 2) {
        pin2 = "*";
      }
      if (checkPin.length == 3) {
        pin3 = "*";
      }
      if (checkPin.length == 4) {
        pin4 = "*";
        for (User p in loginData) {
          if (checkPin.toString() == p.pin.toString()) {
            unlockApp();
          }
        }
        failedText = "Failed. Incorrect code. Please try again.";
        checkPin.clear();
        pin1 = "";
        pin2 = "";
        pin3 = "";
        pin4 = "";
      }
    }
  }

  void getWidthHeight() {
    //var myWidth = window.innerWidth;
    var windowHeight = window.innerHeight;
    if (small == true) {
      height = windowHeight - 57;
    } else {
      height = windowHeight;
    }
    //print("Height is $height");
  }

  void filter() {
    String s = search.toUpperCase();
    searchList.clear();
    if (s.contains(" ")) {
      //print("hippee skippy");
      List split = s.split(" ");
      //print(split.length);
      if (split.length == 2) {
        searchList = tierData.where((Ring element) =>
          (element.SKU.toUpperCase().contains(split[0]) || element.finish.toUpperCase().contains(split[0]) || element.id.toString().contains(split[0]) || element.category.toUpperCase().contains(split[0])) &&
          (element.SKU.toUpperCase().contains(split[1]) || element.finish.toUpperCase().contains(split[1]) || element.id.toString().contains(split[1]) || element.category.toUpperCase().contains(split[1]))
        ).toList();
      }
      if (split.length == 3) {
        searchList = tierData.where((Ring element) =>
          (element.SKU.toUpperCase().contains(split[0]) || element.finish.toUpperCase().contains(split[0]) || element.id.toString().contains(split[0]) || element.category.toUpperCase().contains(split[0])) &&
          (element.SKU.toUpperCase().contains(split[1]) || element.finish.toUpperCase().contains(split[1]) || element.id.toString().contains(split[1]) || element.category.toUpperCase().contains(split[1])) &&
         (element.SKU.toUpperCase().contains(split[2]) || element.finish.toUpperCase().contains(split[2]) || element.id.toString().contains(split[2]) || element.category.toUpperCase().contains(split[2]))
        ).toList();
      }
      if (split.length == 4) {
        searchList = tierData.where((Ring element) =>
          (element.SKU.toUpperCase().contains(split[0]) || element.finish.toUpperCase().contains(split[0]) || element.id.toString().contains(split[0]) || element.category.toUpperCase().contains(split[0])) &&
          (element.SKU.toUpperCase().contains(split[1]) || element.finish.toUpperCase().contains(split[1]) || element.id.toString().contains(split[1]) || element.category.toUpperCase().contains(split[1])) &&
          (element.SKU.toUpperCase().contains(split[2]) || element.finish.toUpperCase().contains(split[2]) || element.id.toString().contains(split[2]) || element.category.toUpperCase().contains(split[2])) &&
          (element.SKU.toUpperCase().contains(split[3]) || element.finish.toUpperCase().contains(split[3]) || element.id.toString().contains(split[3]) || element.category.toUpperCase().contains(split[3]))
        ).toList();
      }
      //print(searchList);
    } else {
      searchList = tierData.where((Ring element) => element.SKU.toUpperCase().contains(s) || element.finish.toUpperCase().contains(s) || element.id.toString().contains(s) || element.category.toUpperCase().contains(s)).toList();
    }
    if (searchList.isEmpty) {
      hideNotFound = false;
    } else {
      hideNotFound = true;
    }
  }

  /*void parseTiersforFilter(s) {
    switch (subselected) {
      case ALL: currentTier = tierData.where((Ring element) => element.tier != 0 && element.tier != 22 && element.SKU.contains(s)).toList(); break;
      case METEORITE: meteoriteList = tierData.where((Ring element) => element.category == "Meteorite" && element.tier != 0 && element.SKU.contains(s)).toList(); break;
      case CAMO: camoList = tierData.where((Ring element) => element.category == "Camo" && element.tier != 0 && element.SKU.contains(s)).toList(); break;
      case TITANIUM: titaniumList = tierData.where((Ring element) => element.category == "Titanium" && element.tier != 0 && element.SKU.contains(s)).toList(); break;
      case CARBONFIBER: carbonfiberList = tierData.where((Ring element) => element.category == "Carbon Fiber" && element.tier != 0 && element.SKU.contains(s)).toList(); break;
      case COBALTCHROME: cobaltchromeList = tierData.where((Ring element) => element.category == "Cobalt Chrome" && element.tier != 0 && element.SKU.contains(s)).toList(); break;
      case DAMASCUS: damascusList = tierData.where((Ring element) => element.category == "Damascus" && element.tier != 0 && element.SKU.contains(s)).toList(); break;
      case TUNGSTENCERAMIC: tungstenceramicList = tierData.where((Ring element) => element.category == "Tungsten Ceramic" && element.tier != 0 && element.SKU.contains(s)).toList(); break;
      case ZIRCONIUM: zirconiumList = tierData.where((Ring element) => element.category == "Zirconium" && element.tier != 0 && element.SKU.contains(s)).toList(); break;
    }

  }*/

  /*void parseOtherforFilters(s) {
    if (selectedLabel == "All Rings" && othersubselected == ALLALL) {
      otherRingsAll = tierData.where((Ring element) => element.tier != 22 && element.SKU.contains(s)).toList();
    }
    switch (othersubselected) {
      case OTHERCAMO: othercamoList = tierData.where((Ring element) => element.category == "Camo" && element.SKU.contains(s)).toList(); break;
      case OTHERMETEORITE: othermeteoriteList = tierData.where((Ring element) => element.category == "Meteorite" && element.SKU.contains(s)).toList(); break;
      case OTHERTITANIUM: othertitaniumList = tierData.where((Ring element) => element.category == "Titanium" && element.SKU.contains(s)).toList(); break;
      case OTHERCARBONFIBER: othercarbonfiberList = tierData.where((Ring element) => element.category == "Carbon Fiber" && element.SKU.contains(s)).toList(); break;
      case OTHERCOBALTCHROME: othercobaltchromeList = tierData.where((Ring element) => element.category == "Cobalt Chrome" && element.SKU.contains(s)).toList(); break;
      case OTHERDAMASCUS: otherdamascusList = tierData.where((Ring element) => element.category == "Damascus" && element.SKU.contains(s)).toList(); break;
      case OTHERTUNGSTENCERAMIC: othertungstenceramicList = tierData.where((Ring element) => element.category == "Tungsten Ceramic" && element.SKU.contains(s)).toList(); break;
      case OTHERZIRCONIUM: otherzirconiumList = tierData.where((Ring element) => element.category == "Zirconium" && element.SKU.contains(s)).toList(); break;
      case OTHEROTHER: otherotherList = tierData.where((Ring element) => (element.category == "Mokume" || element.category == "Elysium" || element.category == "Ceramic" || element.category == "Precious Metal" || element.category == "Goodyear" || element.category == "Stainless Steel")  && element.tier == 0 && element.SKU.contains(s)).toList(); break;
    }

  }*/

  /*void parseAccessoriesforFilter(s) {
    if (selected == 1) {
      accessories = tierData.where((Ring element) => element.category == "Accessories" && element.SKU.contains(s)).toList();
    }
  }*/
  /*void reset() {
    openIt2 = true;
  }*/
  void cancelStartOver() {
    openIt2 = false;
  }
  /*void addTier() {
    hide2ndTier = true;
  }*/

  showGuarantee() {
    showguaranteed = true;
  }

  closeGuarantee() {
    showguaranteed = false;
  }

  changePartner([Event event, var detail, Element target]) {

    if (partnerSelected == 1) {
      hideExistingPartner = false;
      loadClients();

    }
    if (partnerSelected == 0) {
      hideExistingPartner = true;

    }
  }


  void setSubTotalCost() {
    subTotalCost = otherItemsCost + otherRingCost + customcost + sbcost;
  }


  /*void onDataLoaded2(Event event, var detail, Element target) {
    List<Map> mapList2 = detail['response'];
    var data = mapList2.map((Map element) => new Person.fromMap(element)).toList();
  }*/




  void scrollIt() {
    /*for (var i = 1; i < 21; i++) {
      $["list$i"].scrollToItem(1);
    }*/
    $["tierone"].scrollToItem(1);
    $["tiertwo"].scrollToItem(1);
    $["tierthree"].scrollToItem(1);
    $["tierfour"].scrollToItem(1);
    $["tierfourg"].scrollToItem(1);
    $["meteoritelist"].scrollToItem(1);
    $["camolist"].scrollToItem(1);
    $["titaniumlist"].scrollToItem(1);
    $["carbonfiberlist"].scrollToItem(1);
    $["cobaltchromelist"].scrollToItem(1);
    $["damascuslist"].scrollToItem(1);
    $["tungstenceramiclist"].scrollToItem(1);
    $["zirconiumlist"].scrollToItem(1);
    $["otherringsall"].scrollToItem(1);
    $["corecollectionlist"].scrollToItem(1);
    $["othermeteoritelist"].scrollToItem(1);
    $["othercamolist"].scrollToItem(1);
    $["othertitaniumlist"].scrollToItem(1);
    $["othercarbonfiberlist"].scrollToItem(1);
    $["othercobaltchromelist"].scrollToItem(1);
    $["otherdamascuslist"].scrollToItem(1);
    $["othertungstenceramiclist"].scrollToItem(1);
    $["otherzirconiumlist"].scrollToItem(1);
    $["otherhardwoodlist"].scrollToItem(1);
    $["otherotherlist"].scrollToItem(1);
    //$["barcodeRings"].scrollToItem(1);
    $["searchlist"].scrollToItem(1);
    scroll();
  }

  void scroll() {
    $['scaffoldid'].scroller.scrollTop = 0;
  }
  void scrollIt2() {
    $['headerPanel'].scroller.scrollTop = 0;
  }

  void openChooseOrder() {
   selected = 9;
    scroll();
  }

  void loadFromPHP() {
    var request = HttpRequest.getString(pathToPhpLoad).then(onPHPDataLoaded);
  }

  void onPHPDataLoaded(String responseText) {
    var jsonString = JSON.decode(responseText);

    for (var j in jsonString) {
      /*if (j["completed"] == "0") {*/
        orderNames.add({"id" : int.parse(j["order_idx"]), "name" : j["order_name"]});
      /*}*/
    }
    orderNames.sort((Map a, Map b) {
      if (a["id"] < b["id"]) {
        return 1;
      }
      else if (a["id"] > b["id"]) {
        return -1;
      }

      return 0;
    });
    //print(orderNames);
    openChooseOrder();

  }

  void openSaveOrderDialog() {
    viewSaveOrderDialog = true;

  }

  void saveOrderDialogOpen() {
    async((_) => $['orderName'].focus());
  }

  void closeSaveOrderDialog() {
    viewSaveOrderDialog = false;
  }

  void closeSelectOrderDialog() {
    selected = 8;
    scroll();
  }

  void getOrderIdx() {

    var temp = JSON.encode($['loadOrderID'].selected);
    //print("The id is $temp");


    HttpRequest.request('$pathToLoadOrder/getOrderIdx.php', method: 'POST', mimeType: 'application/json', sendData: temp).catchError((obj) {
      //print(obj);
    }).then((HttpRequest val) {
      //print('response: ${val.responseText}');
      var order = JSON.decode(val.responseText);
      print(order);
      if (order['customer'].isEmpty && order['master'].isEmpty && order['removed'].isEmpty && order['added'].isEmpty && order['accessories'].isEmpty && order['custom'].isEmpty && order['stockbalances'].isEmpty && order['orderdata'].isEmpty) {
        print("no order");
        return;
      }

      fillTheOrder(order);

      //***
      order_id = order['master'][0]['order_idx'];
      client_id = order['master'][0]['client_idx'];
      addToDB();
      scroll();
      hideLoadButton = true;
      selected = 8;
    }, onError: (e) => print("error"));



    //hideloader = true;
  }

  void fillTheOrder(order) {
    //print(order);
    loadingfromDB = true;
    print(order["accessories"]);
    List testForAccessories = order["accessories"];
    // set the tier

    if (testForAccessories.isNotEmpty) {
      for (var o in order["accessories"]) {
        if (o["SKU"] == "CUSTOM DISPLAY") {
          goToAccessories();
        }
      }
    }


    tier = int.parse(order['master'][0]['tier']);
    //print("tier should be $tier");



    /*switch (tier) {
      case 0:
        tierselected = 0;
        for (var a in order['added']) {
          var temp = {"SKU" : a["SKU"], "finish" : a["finish"]};
          removeRing(null, temp, null);
        }
        break;
      case 1:
        tierselected = 1;
        for (var a in order['added']) {
          if (a["tier"] == 0 || a["tier"] == 22 || a["tier"] == 2 || a["tier"] == 3 || a["tier"] == 4) {
            var temp = {"SKU" : a["SKU"], "finish" : a["finish"]};
            removeRing(null, temp, null);
          }
        }
        break;
      case 2:
        tierselected = 2;
        for (var a in order['added']) {
          if (a["tier"] == 0 || a["tier"] == 22 || a["tier"] == 3 || a["tier"] == 4) {
            var temp = {"SKU" : a["SKU"], "finish" : a["finish"]};
            removeRing(null, temp, null);
          }
        }
        break;
      case 3:
        tierselected = 3;
        for (var a in order['added']) {
          if (a["tier"] == 0 || a["tier"] == 22 || a["tier"] == 4) {
            var temp = {"SKU" : a["SKU"], "finish" : a["finish"]};
            removeRing(null, temp, null);
          }
        }
        break;
      case 4:
        tierselected = 4;
        for (var a in order['added']) {
          if (a["tier"] == 0 || a["tier"] == 22) {
            var temp = {"SKU" : a["SKU"], "finish" : a["finish"]};
            removeRing(null, temp, null);
          }
        }
        break;
      case 5:
        tierselected = 5;
        for (var a in order['added']) {
          if (a["tier"] == 0 || a["tier"] == 22) {
            var temp = {"SKU" : a["SKU"], "finish" : a["finish"]};
            removeRing(null, temp, null);
          }
        }
        break;
    }*/


    //tierItUp();

    switch (tier) {
      case 1:
      //print("tier 1 should load");
        tier = 1;
        contentLabel = "Tier 1";
        guaranteed = false;

        tierLoaded = true;
        tier4GCost = 0;
        break;
      case 2:
      //print("tier 2 should load");
        tier = 2;
        contentLabel = "Tier 2";
        guaranteed = false;

        tierLoaded = true;

        tier4GCost = 0;
        break;
      case 3:
      //print("tier 3 should load");
        tier = 3;
        contentLabel = "Tier 3";
        guaranteed = false;
        tierLoaded = true;

        tier4GCost = 0;
        break;
      case 4:
      //print("tier 4 should load");
        tier = 4;
        contentLabel = "Tier 4";
        guaranteed = false;
        tierLoaded = true;

        tier4GCost = 0;
        break;
      case 5:
      //print("tier 4G should load");
        tier = 5;
        contentLabel = "Tier 4 Guaranteed";
        guaranteed = true;

        tierLoaded = true;
        tier4GCost = 844;
        break;
      case 0:
      //print("tier 0 should load");
        tier = 0;
        contentLabel = "No Tier";
        guaranteed = false;

        tierLoaded = false;

        tier4GCost = 0;
        break;
    }

    // load the rings
    async((_) {
      if (order['added'].isNotEmpty) {
        for (var a in order['added']) {
            var temp = {"SKU" : a["SKU"], "finish" : a["finish"]};
            removeRing(null, temp, null);
            Ring currentRing = tierData.where((Ring element) => element.SKU == temp["SKU"] && element.finish == temp["finish"]).first;
            //print(a["notes"]);
            currentRing.notes = a["notes"];
            fillNotes(temp);
        }
      }
      if (order['removed'].isNotEmpty) {
        for (var r in order['removed']) {
          var temp = {"SKU" : r["SKU"], "finish" : r["finish"]};
          //removeRing(null, temp, null);


          removed.add({"SKU" : r['SKU'], "finish" : r['finish'], "price" : r['price']});
        }
        finalRemoved = removed;
        hideRemovedItems = false;

      }

      if (order['accessories'].isNotEmpty) {
        for (var o in order['accessories']) {
          var temp = {"SKU" : o["SKU"], "finish" : o["finish"]};
          removeRing(null, temp, null);
          Ring currentAccessory = tierData.where((Ring element) => element.SKU == temp["SKU"] && element.finish == temp["finish"]).first;
          currentAccessory.notes = o["notes"];
          fillNotes(temp);
        }
      }
      if (order['custom'].isNotEmpty) {

        for (var t in order['custom']) {

          String stringPrice = t['price'].toString();
          //print("test");
          int intPrice = int.parse(stringPrice);
          typedSkus.add({
            'sku' : t['sku'], 'finish' : t['finish'], 'price' : intPrice
          });

        }
        //print("Typed Skus $typedSkus");
        hideCustomSkus = false;
        createCustomCost();
      }

      if (order['stockbalances'].isNotEmpty) {
        //print("stockbalances: ${order['stockbalances']}");

        for (var s in order['stockbalances']) {
          String stringPrice = s['price'].toString();
          String stringId = s['id'].toString();
          int intPrice = int.parse(stringPrice);
          int intId = int.parse(stringId);
          stockBalances.add({
            'id' : intId, 'price' : intPrice
          });
        }
        //print("Stock Balances: $stockBalances");
        hideStockBalances = false;
        createSBCost();
      }

      //print(order['customer']);
      //fill out the client data - not working...fix it!! also causing a range error
      if (order['customer'].isNotEmpty) {

          $['storeNameNew'].value = order['customer'][0]['storeName'];
          $['lastNameNew'].value = order['customer'][0]['lastName'];
          $['firstNameNew'].value = order['customer'][0]['firstName'];
          $['addressNew'].value = order['customer'][0]['address'];
          $['cityNew'].value = order['customer'][0]['city'];
          $['stateNew'].value = order['customer'][0]['state'];
          $['zipNew'].value = order['customer'][0]['zip'];
          $['phoneNew'].value = order['customer'][0]['phone'];
          $['emailNew'].value = order['customer'][0]['email'];
          $['confirmEmailNew'].value = order['customer'][0]['email'];
          $['termsNew'].value = order['orderdata'][0]['terms'];

          //$['lastName'].value = order['customer'][0]['lastName'];
          //$['firstName'].value = order['customer'][0]['firstName'];
          //$['address'].value = order['customer'][0]['address'];
          //$['city'].value = order['customer'][0]['city'];
          //$['state'].value = order['customer'][0]['state'];
          //$['zip'].value = order['customer'][0]['zip'];
          //$['phone'].value = order['customer'][0]['phone'];
          //$['email'].value = order['customer'][0]['email'];
          //$['confirmEmail'].value = order['customer'][0]['email'];
          //$['terms'].value = order['orderdata'][0]['terms'];

          $['storeName'].value = order['customer'][0]['storeName'];
        }
      if (order['orderdata'][0]['notes'] != null) {
        $['notes'].value = order['orderdata'][0]['notes'];
      }
    });

  }


  void saveOrderToPHP() {
    bool completed;
    if (selected == 6) {
      completed = true;
    } else {
      orderName = $['orderName'].value;
      if (orderName.isEmpty) {
        window.alert('You must provide an order name');
        return;
      }
    }


    Map customerInfo;
    Map orderData;
    String dateadd;
    if (partnerSelected == 0) {
      //print("partner selected = 0");
      dateadd = $['dateNew'].value;
      customerInfo = {
          "client_idx" : "none",
          "checked" : "new",
          "storeName" : $['storeNameNew'].value,
          "lastName" : $['lastNameNew'].value,
          "firstName" : $['firstNameNew'].value,
          "address" : $['addressNew'].value,
          "city" : $['cityNew'].value,
          "state" : $['stateNew'].value,
          "zip" : $['zipNew'].value,
          "phone" : $['phoneNew'].value,
          "email" : $['emailNew'].value,
      };
      orderData = {
        "terms" : $['termsNew'].value,
        "notes" : $['notes'].value
      };
    }

    if (partnerSelected == 1) {
      //print("Partner Selected = 1");

      dateadd = $['date'].value;
      String store_name = $['storeName'].value;
      String last_name = $['lastName'].value;
      String first_name = $['firstName'].value;
      String address = $['address'].value;
      String city = $['city'].value;
      String state = $['state'].value;
      String zip = $['zip'].value;
      String phone = $['phone'].value;
      String email = $['email'].value;
      var clientIDX = "";
      if (currentPartner.isNotEmpty) {
        clientIDX = currentPartner[0].client_idx;
      }
      customerInfo = {
          "client_idx" : clientIDX,
          "checked" : "existing",
          "storeName" : store_name,
          "lastName" : last_name,
          "firstName" : first_name,
          "address" : address,
          "city" : city,
          "state" : state,
          "zip" : zip,
          "phone" : phone,
          "email" : email,

      };
      orderData = {
        "terms" : $['terms'].value,
        "notes" : $['notes'].value
      };
    }
    Map customDisplay;
    //print("Last Name that will be uploaded is:" + customerInfo["lastName"]);
    if (customDisplayAdded == true) {
      customDisplay = {
        "top" : topSwatch,
        "side" : sideSwatch,
        "acrylic" : acrylic
      };
    }

    var data =
    {
        "completed" : completed,
        "date" : dateadd,
        "customer_info" : customerInfo,
        "order_data" : orderData,
        "order_name" : orderName,
        "tier" : tier,
        "rings_removed" : finalRemoved,
        "rings_added" : added,
        "accessories" : finalAddedItem,
        "customrings" : typedSkus,
        "stockbalances" : stockBalances,
        "rep" : currentUser,
        "new" : 1,
        "display" : customDisplay
    };

    var datasend = JSON.encode(data);

    HttpRequest.request(pathToPhpAdd, method: 'POST', mimeType: 'application/json', sendData: datasend).catchError((obj) {
      //print(obj);
    }).then((HttpRequest val) {
      //print('The response that gets the ID is: ${val.responseText}');
      print(val.responseText);
      orderID = JSON.decode(val.responseText);


    }, onError: (e) => print("error"));
    closeSaveOrderDialog();
  }

  /*void swapCombo(Event event, var detail, Element target) {
    CoreItem item = detail["item"];
    chosenCombo = item.value;
    //print(chosenCombo);
  }*/

  void addCombo([int comboIn]) {
    print("combo selected is $comboselected");
    print(comboIn);
    if (comboIn == 1 || comboIn == 2 || comboIn == 3 || comboIn == 4 || comboIn == 5 || comboIn == 6) {
      print("skiddly");
      comboselected = comboIn;
    }
    print("combo selected after is $comboselected");
    switch (comboselected) {
      case 0:
      print("zero");

        for (var a in core_collection) {
          Map temp = {'SKU' : a.SKU, 'finish' : a.finish};
          removeRing(null, temp, null);
          if (isCombo) {
            Ring currentRing = tierData.firstWhere((Ring element) => element.SKU == a.SKU && element.finish == a.finish);
            barcodeRing = currentRing;
          }
        }
        break;
      case 1:
      //print("zero");
        for (var a in basics_a) {
          Map temp = {'SKU' : a.SKU, 'finish' : a.finish};
          removeRing(null, temp, null);
          if (isCombo) {
            Ring currentRing = tierData.firstWhere((Ring element) => element.SKU == a.SKU && element.finish == a.finish);
            barcodeRing = currentRing;
          }
        }
        break;
      case 2:
      //print("one");
        for (var b in basics_b) {
          Map temp = {'SKU' : b.SKU, 'finish' : b.finish};
          removeRing(null, temp, null);
          if (isCombo) {
            Ring currentRing = tierData.firstWhere((Ring element) => element.SKU == b.SKU && element.finish == b.finish);
            barcodeRing = currentRing;
          }
        }
        break;
      case 3:
      //print("two");
        for (var c in engraved_set_a) {
          Map temp = {'SKU' : c.SKU, 'finish' : c.finish};
          removeRing(null, temp, null);
          if (isCombo) {
            Ring currentRing = tierData.firstWhere((Ring element) => element.SKU == c.SKU && element.finish == c.finish);
            barcodeRing = currentRing;
          }
        }
        break;
      case 4:
      //print("three");
        for (var d in hardwood_10) {
          Map temp = {'SKU' : d.SKU, 'finish' : d.finish};
          removeRing(null, temp, null);
          if (isCombo) {
            Ring currentRing = tierData.firstWhere((Ring element) => element.SKU == d.SKU && element.finish == d.finish);
            barcodeRing = currentRing;
          }
        }
        break;
      case 5:
      //print("four");
        for (var e in elysium_8) {
          Map temp = {'SKU' : e.SKU, 'finish' : e.finish};
          removeRing(null, temp, null);
          if (isCombo) {
            Ring currentRing = tierData.firstWhere((Ring element) => element.SKU == e.SKU && element.finish == e.finish);
            barcodeRing = currentRing;
          }
        }
        break;
      case 6:
      //print("four");
        for (var e in elysium_5) {
          Map temp = {'SKU' : e.SKU, 'finish' : e.finish};
          removeRing(null, temp, null);
          if (isCombo) {
            Ring currentRing = tierData.firstWhere((Ring element) => element.SKU == e.SKU && element.finish == e.finish);
            barcodeRing = currentRing;
          }
        }
        break;
    }
  }

  void loadClients() {
    if (clientResponse == [] || clientResponse == "" || clientResponse == null || clientResponse.isEmpty) {
      openLoading = true;
      var request = HttpRequest.getString(pathToGetClient).then(onClientsLoaded);
    }
  }

  void onClientsLoaded(String response) {
      //print(response);
      mapList = JSON.decode(response);

      testFuture();
  }



  void autoFillPartner(Event event, var detail, Element target) {
    //print($["clientResults"].selection);
    store_name =  detail.item.dataset['store'];
    currentPartner = clientResponse.where((Client element) => element.store_name == store_name).toList();
    for (var c in clientResponse) {
      if (c.selected == true && c.store_name != store_name) {
        c.selected = false;
      }
    }
    currentPartner[0].selected = true;
    //print($['clientResults'].selected);
    hideExistingCustomer = false;
  }

  void handleSearch(KeyboardEvent event) {
    KeyEvent keyEvent = new KeyEvent.wrap(event);
    if (keyEvent.keyCode == KeyCode.ENTER) {
      event.preventDefault();
      filter();
    }
  }

  void handleKeyEvent(KeyboardEvent event) {

    //String data = $['storeName'].value;

    KeyEvent keyEvent = new KeyEvent.wrap(event);
    if (keyEvent.keyCode == KeyCode.ENTER) {
      event.preventDefault();
      searchNames();
    }
    //print("key pressed");

  }
  void handleSaveOrderKeyEvent(KeyboardEvent event) {

    //String data = $['storeName'].value;

    KeyEvent keyEvent = new KeyEvent.wrap(event);
    if (keyEvent.keyCode == KeyCode.ENTER) {
      event.preventDefault();
      saveOrderToPHP();
    }
    //print("key pressed");

  }

  Future searchNames() async {
    String data = $['storeName'].value;
    await setClientList(data);
    await closeLoading();
  }

  Future setClientList(data) async {
    clientList = clientResponse.where((Client element) => element.store_name.toUpperCase().contains(data.toUpperCase())).toList();
    //print(clientList);
  }

  Future testFuture() async {
      await getClientResponse();
      await closeLoading();
  }


  void getClientResponse() {
    clientResponse = mapList.map((Map element) => new Client.fromMap(element)).toList();
    //print("Client Response Loaded");
  }

  void closeLoading() {
    $['storeName'].focus();
    openLoading = false;
    //print("Loading closed");
  }

  void goToAccessories() {
    selected = 1;

    $['menu-id1'].selected = -1;

    $['menu-id3'].selected = -1;
    $['menu-id4'].selected = -1;


    scroll();
    hideSubmitButton = false;
    hideButtons = true;
    hideMenus = false;
    hideScrollButton = false;
    $['menu-id2'].selected = 0;
    hideAllMenu = true;
    hideTierMenu = true;

    if (accessories.isEmpty) {
      openLoading = true;
      accessories = tierData.where((Ring element) => element.tier == 22).toList();

      openLoading = false;
    }
    showDisplayWarning = false;
  }

  void clearSearch() {
    searchList = [];
    $['filter'].value = "";
    filter();
    $['filter'].focus();
  }

  void cancelSig() {
    selected = 4;
    hideCloseSignatureButton = true;
    hideOtherButtons = false;
  }

  void handleNotes(Event event, var detail, Element target) {
    String ringChangeSku =  target.dataset['sku'];
    String ringChangeFinish =  target.dataset['finish'];
    //print(ringChangeSku);
    //print(ringChangeFinish);
    Ring ringToChange = tierData.where((Ring element) => element.SKU == ringChangeSku && element.finish == ringChangeFinish).first;
    //print(ringToChange);

    if (ringToChange.tier != 22 && ringToChange.cleared == false) {

      added.removeWhere((item) => item["SKU"] == ringToChange.SKU && item["finish"] == ringToChange.finish);

      added.add({"SKU" : ringToChange.SKU, "finish" : ringToChange.finish, "price" : ringToChange.price, "tier" : ringToChange.tier, "notes" : ringToChange.notes});
    }
    if (ringToChange.tier == 22 && ringToChange.cleared == false) {

      addeditem.removeWhere((item) => item["SKU"] == ringToChange.SKU && item["finish"] == ringToChange.finish);

      addeditem.add({"SKU" : ringToChange.SKU, "finish" : ringToChange.finish, "price" : ringToChange.price, "tier" : ringToChange.tier, "notes" : ringToChange.notes});
    }
    if (tier == 0) {
      finalAdded = [];
      finalAddedPlus = added;
    }
    if (tier == 1) {
      finalAdded = added.where((List element) => element['tier'] == 1);
      finalAddedPlus = added.where((List element) => element['tier'] == 0 || element['tier'] == 2 || element['tier'] == 3 || element['tier'] == 4);
    }
    if (tier == 2) {
      finalAdded = added.where((List element) => element['tier'] == 1 || element['tier'] == 2);
      finalAddedPlus = added.where((List element) => element['tier'] == 0 || element['tier']== 3 || element['tier'] == 4);
    }
    if (tier == 3) {
      finalAdded = added.where((List element) => element['tier'] == 1 || element['tier'] == 2 || element['tier'] == 3);
      finalAddedPlus = added.where((List element) => element['tier'] == 0 || element['tier'] == 4);
    }
    if (tier == 4 || tier == 5) {
      finalAdded = added.where((List element) => element['tier'] == 1 || element['tier'] == 2 || element['tier'] == 3  || element['tier'] == 4);
      finalAddedPlus = added.where((List element) => element['tier'] == 0);
    }
    finalAddedItem = addeditem;
    addToDB();
  }

  void fillNotes(temp) {

    Ring ringToChange = tierData.where((Ring element) => element.SKU == temp["SKU"] && element.finish == temp["finish"]).first;
    //print(ringToChange);

    if (ringToChange.tier != 22 && ringToChange.cleared == false) {

      added.removeWhere((item) => item["SKU"] == ringToChange.SKU && item["finish"] == ringToChange.finish);

      added.add({"SKU" : ringToChange.SKU, "finish" : ringToChange.finish, "price" : ringToChange.price, "tier" : ringToChange.tier, "notes" : ringToChange.notes});
    }
    if (ringToChange.tier == 22 && ringToChange.cleared == false) {

      addeditem.removeWhere((item) => item["SKU"] == ringToChange.SKU && item["finish"] == ringToChange.finish);

      addeditem.add({"SKU" : ringToChange.SKU, "finish" : ringToChange.finish, "price" : ringToChange.price, "tier" : ringToChange.tier, "notes" : ringToChange.notes});
    }
    if (tier == 0) {
      finalAdded = [];
      finalAddedPlus = added;
    }
    if (tier == 1) {
      finalAdded = added.where((List element) => element['tier'] == 1);
      finalAddedPlus = added.where((List element) => element['tier'] == 0 || element['tier'] == 2 || element['tier'] == 3 || element['tier'] == 4);
    }
    if (tier == 2) {
      finalAdded = added.where((List element) => element['tier'] == 1 || element['tier'] == 2);
      finalAddedPlus = added.where((List element) => element['tier'] == 0 || element['tier']== 3 || element['tier'] == 4);
    }
    if (tier == 3) {
      finalAdded = added.where((List element) => element['tier'] == 1 || element['tier'] == 2 || element['tier'] == 3);
      finalAddedPlus = added.where((List element) => element['tier'] == 0 || element['tier'] == 4);
    }
    if (tier == 4 || tier == 5) {
      finalAdded = added.where((List element) => element['tier'] == 1 || element['tier'] == 2 || element['tier'] == 3  || element['tier'] == 4);
      finalAddedPlus = added.where((List element) => element['tier'] == 0);
    }
    finalAddedItem = addeditem;
    addToDB();
  }

  void okayToEmail() {
    //print("emailed");

    sendMap = {"orderemail" : orderemail, "repemail" : currentUserEmail, "orderID" : orderID};
    var data = JSON.encode(sendMap);
    //print("data: $data");
    HttpRequest.request(pathToEmailManually, method: 'POST', mimeType: 'application/json', sendData: data).catchError((obj) {

      //print(obj);
    }).then((HttpRequest val) {
      openEmailedNotice = false;
      //print('The data to email response is: ${val.responseText}');
    }, onError: (e) => print("error"));
  }

  void cancelEmail() {
    openEmailedNotice = false;
  }

  void swatchLoaded(Event event, var detail, Element target) {
    print("got here");
    List<Map> swatchMapList = detail['response'];

    swatchData = swatchMapList.map((Map element) => new Swatch.fromMap(element)).toList();
    topSwatchData = swatchData.where((Swatch element) => element.type == "top").toList();
    sideSwatchData = swatchData.where((Swatch element) => element.type == "side").toList();
    acrylicData = swatchData.where((Swatch element) => element.type == "acrylic").toList();
    print(topSwatchData);

  }

  void handleCustom(Event event, var detail, Element target) {

    var swatchname = target.dataset['name'];
    var swatchtype = target.dataset['type'];
    var currentSwatch = swatchData.where((Swatch element) => element.name == swatchname && element.type == swatchtype).first;



    if (currentSwatch.type == "top") {
      for (var s in swatchData) {
        if (s.type == "top") {
          s.added = false;
        }
      }
      topSwatch = currentSwatch.name;
      customTop = "display_top_${currentSwatch.url.toLowerCase()}.png";
    }
    if (currentSwatch.type == "side") {
      for (var s in swatchData) {
        if (s.type == "side") {
          s.added = false;
        }
      }
      sideSwatch = currentSwatch.name;
      customBase = "${currentSwatch.url}.jpg";
    }
    if (currentSwatch.type == "acrylic") {
      for (var s in swatchData) {
        if (s.type == "acrylic") {
          s.added = false;
        }
      }
      acrylic = currentSwatch.name;
      acrylicTop = "display_acrylic_${currentSwatch.name.toLowerCase()}400.png";
    }

    currentSwatch.added = true;

    print(currentSwatch);
    print(currentSwatch.added);
    addToDB();
  }

  void closeCustom() {
    selected = 1;
  }

  void changeCustomDisplay() {
    selected = 12;
  }

  void sortByCollection(Event event, var detail, Element target) {
    var listToSort = target.dataset['collection'];
    print(listToSort);
    print(otherotherList);

    void doTheCollectionSort(collection) {
      collection.sort((x, y) {
        if (x.combo == "" && y.combo == "") {
          return 0;
        }
        if (x.combo == "" && y.combo != "") {
          return 1;
        }
        if (x.combo != "" && y.combo == "") {
          return -1;
        }
        return x.combo.compareTo(y.combo);
      });
    }

    switch(listToSort) {
      case "all":
        doTheCollectionSort(otherRingsAll);
        break;
      case "corecollection":
        doTheCollectionSort(corecollectionList);
        break;
      case "meteorite":
        doTheCollectionSort(othermeteoriteList);
        break;
      case "camo":
        doTheCollectionSort(othercamoList);
        break;
      case "titanium":
        doTheCollectionSort(othertitaniumList);
        break;
      case "carbonfiber":
        doTheCollectionSort(othercarbonfiberList);
        break;
      case "cobaltchrome":
        doTheCollectionSort(othercobaltchromeList);
        break;
      case "damascus":
        doTheCollectionSort(otherdamascusList);
        break;
      case "tungstenceramic":
        doTheCollectionSort(othertungstenceramicList);
        break;
      case "zirconium":
        doTheCollectionSort(otherzirconiumList);
        break;
      case "hardwood":
        doTheCollectionSort(otherhardwoodList);
        break;
      case "other":
        doTheCollectionSort(otherotherList);
        break;

    }
    scrollIt();
  }


}






