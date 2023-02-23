import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../Utils/colors_utils.dart';
import '../../../services/shared_preference.dart';
import '../../../utils/loder.dart';
import '../../../views/custom_widget/custom_appbar.dart';
import '../../../views/custom_widget/dialogs/location_dialog.dart';
import '../../../views/notification/notificationList.dart';
import '../../CustomDrawer.dart';
import '../bottom_nav_bar.dart';

class OurServices extends StatefulWidget {
  const OurServices({Key? key}) : super(key: key);

  @override
  State<OurServices> createState() => _OurServicesState();
}

class _OurServicesState extends State<OurServices> {
  List? images = [];
  bool isLoading = false;
  List getEvent = [];
  List getCancelEvent = [];
  var count = 0;
  var year = DateFormat('yyyy').format(DateTime.now());
  var month = DateFormat('MM').format(DateTime.now());
  CarouselController buttonCarouselController = CarouselController();
  int _selectedSliderIndex = 0;
  String? state, city, stateId;

  initState() {
    super.initState();
    getImages();
    getBookingDetails();
    getCancleBookingDetails();
  }

  Future<void> getImages() async {
    setState(() {
      isLoading = true;
    });
    try {
      Loader.showLoader();
      String? id = await Preferances.getString("id");
      String? token = await Preferances.getString("token");
      String? type = await Preferances.getString("type");
      String? profileStatus = await Preferances.getString("PROFILE_STATUS");
      Response response = await post(
        Uri.parse('https://celebrationstation.in/get_ajax/get_slidder'),
        headers: {
          'Client-Service': 'frontend-client',
          'Auth-Key': 'simplerestapi',
          'User-ID': id.toString(),
          'token': token.toString(),
          'type': type.toString()
        },
        body: {},
      );
      if (response.statusCode == 200) {
        var items = jsonDecode(response.body)['detail'];
        setState(() {
          images = items;
          isLoading = false;
        });
        Loader.hideLoader();
        print("Images Fetched");
      } else {
        setState(() {
          images = [];
          isLoading = false;
        });
        Loader.hideLoader();
        print("Error");
      }
    } catch (e) {
      Loader.hideLoader();
      print(e.toString());
    }
  }

  getBookingDetails() async{
    Loader.showLoader();
    try{
      String? id = await Preferances.getString("id");
      String? token = await Preferances.getString("token");
      String? type = await Preferances.getString("type");
      String? profileStatus = await Preferances.getString("PROFILE_STATUS");
      Response response= await post(
        //Uri.parse('https://reqres.in/api/login'),
        Uri.parse('https://celebrationstation.in/get_ajax/get_booking_balance/'),
        headers: {
          'Client-Service':'frontend-client',
          'Auth-Key':'simplerestapi',
          'User-ID': id.toString(),
          'token': token.toString(),
          'type': type.toString()
        },
        body: {
          'year' : year,
          'loginid':id?.replaceAll('"', '').replaceAll('"', '').toString(),
        },
      );
      if(response.statusCode==200){
        var items = jsonDecode(response.body)['\$booking'];
        setState(() {
          getEvent = items;
        });
        Loader.hideLoader();
        print("Booking List Fetched");
      }else{
        setState(() {
          getEvent = [];
        });
        Loader.hideLoader();
        print("Error");
      }
    }catch(e){
      print(e.toString());
    }
  }

  getCancleBookingDetails() async{
    Loader.showLoader();
    try{
      String? id = await Preferances.getString("id");
      String? token = await Preferances.getString("token");
      String? type = await Preferances.getString("type");
      String? profileStatus = await Preferances.getString("PROFILE_STATUS");
      Response response= await post(
        //Uri.parse('https://reqres.in/api/login'),
        Uri.parse('https://celebrationstation.in/get_ajax/get_cancelled_booking_month_details/'),
        headers: {
          'Client-Service':'frontend-client',
          'Auth-Key':'simplerestapi',
          'User-ID': id.toString(),
          'token': token.toString(),
          'type': type.toString()
        },
        body: {
          'year' : year,
          'loginid':id?.replaceAll('"', '').replaceAll('"', '').toString(),
          'month' : month
        },
      );
      if(response.statusCode==200){
        var items = jsonDecode(response.body)['\$booking'];
        setState(() {
          getCancelEvent = items;
        });
        Loader.hideLoader();
        print("Booking List Fetched");
      }else{
        setState(() {
          getCancelEvent = [];
        });
        Loader.hideLoader();
        print("Error");
      }
    }catch(e){
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
        margin: EdgeInsets.all(20),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              width: double.infinity,
              child: CarouselSlider.builder(
                  carouselController: buttonCarouselController,
                  itemCount: images!.length != null ? images!.length : 0,
                  itemBuilder: (BuildContext context, int itemIndex,
                      int pageViewIndex) =>
                      Padding(
                          padding: EdgeInsets.only(right: 3.w, left: 3.w),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                    image: NetworkImage(
                                      'https://celebrationstation.in/uploads/' +
                                          images![itemIndex]['IMAGE_URL'],
                                    ),
                                    fit: BoxFit.cover)),
                          )),
                  options: CarouselOptions(
                    onPageChanged: (index, _) {
                      setState(() {
                        _selectedSliderIndex = index;
                      });
                    },
                    aspectRatio: 12 / 8,
                    viewportFraction: 1,
                    initialPage: 0,
                    autoPlay: false,
                    enableInfiniteScroll: false,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  )),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                  images!.length,
                      (index) => Indicator(
                      isActive: _selectedSliderIndex == index ? true : false),
                )
              ],
            ),
            // SizedBox(
            //   height: 200,
            //   width: double.infinity,
            //   child: Carousel(
            //     images: [
            //       for (var i = 0; i < images!.length; i++) ...[
            //         Image.network('https://celebrationstation.in/uploads/' +
            //             images![i]['IMAGE_URL'])
            //       ]
            //     ],
            //     //images.map((e) => Image.network('https://celebrationstation.in/uploads/'+images[e]['IMAGE_URL'])).toList(),
            //     showIndicator: true,
            //     autoplay: true,
            //     autoplayDuration: Duration(seconds: 2),
            //     borderRadius: false,
            //     moveIndicatorFromBottom: 180.0,
            //     overlayShadow: true,
            //     overlayShadowColors: Colors.black,
            //     overlayShadowSize: 0.4,
            //     indicatorBgPadding: 5,
            //   ),
            // ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Our Services",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: SizedBox(
                  height: 50, //height of button
                  width: double.infinity, //width of button
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lime[200], //background color of button
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        //to set border radius to button
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return BottomNavBar(
                              index: 1,
                            ); //EditProfile(userId: '${id}', token: '${token}', type: '${type}',);
                          }));
                    },
                    child: const Text(
                      "Add Booking",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black),
                    ),
                  )),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: SizedBox(
                  height: 50, //height of button
                  width: double.infinity, //width of button
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lime[200], //background color of button
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        //to set border radius to button
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Confirm Booking : ${getEvent.length}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black),
                    ),
                  )),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: SizedBox(
                  height: 50, //height of button
                  width: double.infinity, //width of button
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lime[200], //background color of button
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        //to set border radius to button
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Pending Booking : 0",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black),
                    ),
                  )),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: SizedBox(
                  height: 50, //height of button
                  width: double.infinity, //width of button
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lime[200], //background color of button
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        //to set border radius to button
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {},
                    child:  Text(
                      "Canceled Booking : ${getCancelEvent.length}" ,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final bool isActive;
  const Indicator({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      height: 10.0,
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      width: isActive ? 10.0 : 10.0,
      decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.black,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.black, width: 2.0)),
    );
  }
}
