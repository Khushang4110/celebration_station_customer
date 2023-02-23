import 'dart:convert';
import 'package:celebrattion_station_customer/dashboard/bottomNavBar/bottom_nav_bar.dart';
import 'package:celebrattion_station_customer/dashboard/bottomNavBar/tabs/eventCalender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/loder.dart';
import '../Utils/colors_utils.dart';
import '../dashboard/CustomDrawer.dart';
import '../services/shared_preference.dart';
import 'custom_widget/custom_appbar.dart';
import 'custom_widget/dialogs/location_dialog.dart';

class OurService extends StatefulWidget {
  const OurService({Key? key}) : super(key: key);

  @override
  State<OurService> createState() => _HomeState();
}

class _HomeState extends State<OurService> {
  List services = [];
  var cityId;
  String? state, city, stateId;

  @override
  void initState() {
    super.initState();
    this.fetchServices();
  }

  fetchServices() async {
    String? id = await Preferances.getString("id");
    String? token = await Preferances.getString("token");
    String? type = await Preferances.getString("type");
    String? cityid = await Preferances.getString("cityName");
    Loader.showLoader();
    try {
      Response response = await post(
        //Uri.parse('https://reqres.in/api/login'),
        Uri.parse('https://celebrationstation.in/get_ajax/get_all_services/'),
        headers: {
          'Client-Service': 'frontend-client',
          'Auth-Key': 'simplerestapi4qw',
          'User-ID': id.toString(),
          'token': token.toString(),
          'type': type.toString()
        },
        body: {},
      );
      if (response.statusCode == 200) {
        var items = jsonDecode(response.body)['users'];
        setState(() {
          services = items;
          cityId = cityid;
        });
        Loader.hideLoader();
        print("Services Fetched");
        print("CityIDD==${cityId}");
      } else {
        setState(() {
          services = [];
        });
        Loader.hideLoader();
        print("Error");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          "asset/images/logo.png",
          height: 60,
        ),
        leading: Builder(builder: (context) {
          return IconButton(
            iconSize: 30,
            icon: Icon(
              Icons.menu,
              color: Colors.grey,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        actions: [
          IconButton(
              iconSize: 30,
              onPressed: () {
                LocationDailog.show(context).then((value) {
                  setState(() async {
                    state = value.state;
                    city = value.city;
                    stateId = value.stateId;
                  });
                });
              },
              icon: Icon(
                Icons.location_on,
                color: ColorUtils.grey,
              )),
          /*state != null && city != null
              ? Text("${city!.replaceAll('"', '').toString()}", style: TextStyle(color: Colors.black),)
              : SizedBox.shrink()*/
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Center(
              child: Text(
                "Our Services",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Center(
              child: getBody(),
            ),
          ],
        ),
      ),

      /*Expanded(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Center(
              child: Text(
                "Our Services",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ),
      ),*/
    );
  }

  Widget getBody() {
    return SizedBox(
      height: 550,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
          itemCount: services.length,
          itemBuilder: (context, index) {
            return getCard(services[index]);
          }),
    );
  }

  Widget getCard(index) {
    var serviceName = index['GAS_NAME'];
    var serviceId = index['GAS_ID'];
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
          height: 50, //height of button
          width: double.infinity, //width of button
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.lime[200], //background color of button
              elevation: 3,
              shape: RoundedRectangleBorder( //to set border radius to button
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
            onPressed: () {
              if(cityId.toString() == "null"){
                LocationDailog.show(context).then((value) {
                  setState(() async {
                    state = value.state;
                    city = value.city;
                    stateId = value.stateId;
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        BottomNavBar(index: 1)), (Route<dynamic> route) => false);
                  });
                });
                Fluttertoast.showToast(
                  msg: 'Please set your State and City first',
                  //msg: cityId.toString(),
                  backgroundColor: Colors.grey,
                );
              }else{
                //LocationDailog.show(context);
                /*Fluttertoast.showToast(
                  //msg: 'Please set your State and City first',
                  msg: cityId.toString(),
                  backgroundColor: Colors.grey,
                );*/
                Navigator.push(context, MaterialPageRoute(builder: (context) => EventCalendarScreen(serviceId: serviceId)));
              }
            },
            child: Text(serviceName.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.black
              ),
            ),
          )
      ),
    );
  }

}

