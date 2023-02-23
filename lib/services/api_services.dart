import 'dart:convert';
import 'package:celebrattion_station_customer/services/shared_preference.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../dashboard/bottomNavBar/bottom_nav_bar.dart';
import '../model/GetAllProfileModel.dart';
import '../model/LoginModel.dart';
import '../model/get_city_list_model.dart';
import '../model/get_state_list_model.dart';
import '../model/mobile_verify_model.dart';
import '../utils/loder.dart';
import '../views/auth/login_screen.dart';
import '../views/updateProfile.dart';
import 'api_endpoint.dart';
import 'dio_client.dart';
import 'package:http/http.dart' as http;

Dio dio = Dio();

class ApiService {
  ApiClient apiClient = ApiClient();

  Future<LoginModel?> login(
    BuildContext context, {
    FormData? data,
  }) async {
    try {
      Loader.showLoader();
      print("login try");
      Response response;
      response = await dio.post(ApiEndPoints.loginApi,
          options: Options(headers: {
            "Client-Service": 'frontend-client',
            'Auth-Key': 'simplerestapi'
          }),
          data: data);
      LoginModel responseData = LoginModel.fromJson(response.data);
      if (responseData.message == "ok") {
        var cookies = response.headers['set-cookie'];
        print("cookies:=${cookies![0].split(';')[0]}");

        debugPrint('login data  ----- > ${response.data}');
        Preferances.setString("id", responseData.id);
        Preferances.setString("token", responseData.token);
        Preferances.setString("type", responseData.type);
        Preferances.setString("PROFILE_STATUS", responseData.pROFILESTATUS);
        Preferances.setString("cookie", cookies[0].split(';')[0]);

        if (responseData.pROFILESTATUS == '0') {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => UpdateProfile(
                        userId: "${responseData.id}",
                        token: "${responseData.token}",
                        type: "${responseData.type}",
                      )),
              (Route<dynamic> route) => false);
        } else if (responseData.pROFILESTATUS == '1') {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const BottomNavBar(
                        index: 0,
                      )),
              (Route<dynamic> route) => false);
        }
        Fluttertoast.showToast(
          msg: 'Login Sucessfully',
          backgroundColor: Colors.grey,
        );
        Loader.hideLoader();
        return responseData;
      } else {
        Fluttertoast.showToast(
          msg: "Invalid Phone Number/Password",
          backgroundColor: Colors.grey,
        );
        Loader.hideLoader();
        throw Exception(response.data);
      }
    } on DioError catch (e) {
      print("dio");
      debugPrint('Dio E  $e');
      debugPrint('Dio E  $e');
      Loader.hideLoader();
    }
  }

  Future updateProfile(
    BuildContext context, {
    FormData? data,
  }) async {
    try {
      Loader.showLoader();

      String? id = await Preferances.getString("id");
      String? token = await Preferances.getString("token");
      String? type = await Preferances.getString("type");
      String? profileStatus = await Preferances.getString("PROFILE_STATUS");
      Response response;
      response = await dio.post(
          "https://celebrationstation.in/post_ajax/update_profile/",
          options: Options(headers: {
            'Client-Service': 'frontend-client',
            'Auth-Key': 'simplerestapi',
            'User-ID': id,
            'Authorization': token,
            'type': type
          }),
          data: data);
      if (response.statusCode == 200) {
        debugPrint('Update profile data  ----- > ${response.data}');
        Loader.hideLoader();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(
                index: 0,
              ),
            ));
        Fluttertoast.showToast(
          msg: 'Updated Sucessfully...',
          backgroundColor: Colors.grey,
        );
      } else {
        Fluttertoast.showToast(
          msg: "invalid",
          backgroundColor: Colors.grey,
        );
        Loader.hideLoader();
        throw Exception(response.data);
      }
    } on DioError catch (e) {
      print("dio");
      debugPrint('Dio E  $e');
      Loader.hideLoader();
    }
  }

  Future<GetAllProfileModel?> getProfileRecord(
    BuildContext context, {
    FormData? data,
  }) async {
    try {
      Loader.showLoader();
      print("try");
      String? id = await Preferances.getString("id");
      String? token = await Preferances.getString("token");
      String? type = await Preferances.getString("type");
      String? profileStatus = await Preferances.getString("PROFILE_STATUS");
      Response response;
      var formData = FormData.fromMap({
        'loginid': id?.replaceAll('"', '').replaceAll('"', '').toString(),
      });
      // Map<String,dynamic> data = {
      //   'loginid': id?.replaceAll('"', '').replaceAll('"', '').toString()};
      // print(formData);
      // print(id);
      response = await dio.post(
          "https://celebrationstation.in/get_ajax/get_profile_record/",
          /*    options: Options(headers: {
            'Client-Service': 'frontend-client',
            'Auth-Key': 'simplerestapi',
            'User-ID': id?.replaceAll('"', '').replaceAll('"', '').toString(),
            'Authorization': token?.replaceAll('"', '').replaceAll('"', '').toString(),
            'type': type?.replaceAll('"', '').replaceAll('"', '').toString()
          }),*/
          data: formData);
      // print("3");
      GetAllProfileModel responseData =
          GetAllProfileModel.fromJson(response.data);
      // print("4");
      if (responseData.message == "ok") {
        //debugPrint('Get Profile data  ----- > ${response.data}');
        //print("4");

        Loader.hideLoader();
        /*Fluttertoast.showToast(
          msg: 'Get Profile Data Sucessfully...',
          backgroundColor: Colors.grey,
        );*/

        return responseData;
      } else {
        Fluttertoast.showToast(
          msg: "Invalid",
          backgroundColor: Colors.grey,
        );
        Loader.hideLoader();

        throw Exception(response.data);
      }
    } on DioError catch (e) {
      print("dio");
      debugPrint('Dio E  $e');
      Loader.hideLoader();
    }
  }

  Future addEnquiry(
    BuildContext context, {
    FormData? data,
  }) async {
    try {
      Loader.showLoader();
      String? id = await Preferances.getString("id");
      String? token = await Preferances.getString("token");
      String? type = await Preferances.getString("type");
      String? profileStatus = await Preferances.getString("PROFILE_STATUS");
      Response response;
      response = await dio.post(ApiEndPoints.addEnquiryApi,
          options: Options(headers: {
            'Client-Service': 'frontend-client',
            'Auth-Key': 'simplerestapi',
            'User-ID': id,
            'Authorization': token,
            'type': type
          }),
          data: data);
      if (response.statusCode == 200) {
        debugPrint('Add Enquiry ----- > ${response.data}');
        Loader.hideLoader();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(
                index: 1,
              ),
            ));
        Fluttertoast.showToast(
          msg: 'Enquiry added sucessfully...',
          backgroundColor: Colors.grey,
        );
      } else {
        Fluttertoast.showToast(
          msg: "invalid",
          backgroundColor: Colors.grey,
        );
        Loader.hideLoader();

        throw Exception(response.data);
      }
    } on DioError catch (e) {
      print("dio");
      debugPrint('Dio E  $e');
      Loader.hideLoader();
    }
  }

  Future<MobileVerifyModel?> mobileVerify(
    BuildContext context, {
    FormData? data,
    String? mobile,
  }) async {
    try {
      Loader.showLoader();
      print("Register check try:=${mobile}");
      Response response;
      response = await dio.post(ApiEndPoints.mobileVerify,
          options: Options(headers: {
            "Client-Service": 'frontend-client',
            'Auth-Key': 'simplerestapi'
          }),
          data: data);

      MobileVerifyModel responseData =
          MobileVerifyModel.fromJson(response.data);
      print("responseData:=${responseData}");
      print("responseData.status:=${responseData.status}");
      if (responseData.message == "ok") {

        print("responseData.bjjhstatus:=${responseData.status}");

        return responseData;
      } else {
        Fluttertoast.showToast(
          msg: "invalid",
          backgroundColor: Colors.grey,
        );

        Loader.hideLoader();
        throw Exception(response.data);
      }
    } on DioError catch (e) {
      print("dio");
      debugPrint('Dio E  $e');
      debugPrint('Dio E  $e');
      Loader.hideLoader();
    }
  }

  Future addAccount(
    BuildContext context, {
    FormData? data,
  }) async {
    try {
      Loader.showLoader();
      String? id = await Preferances.getString("id");
      String? token = await Preferances.getString("token");
      String? type = await Preferances.getString("type");
      String? profileStatus = await Preferances.getString("PROFILE_STATUS");
      Response response;
      response =
          await dio.post("https://celebrationstation.in/post_ajax/add_account/",
              options: Options(headers: {
                'Client-Service': 'frontend-client',
                'Auth-Key': 'simplerestapi',
                'User-ID': id,
                'Authorization': token,
                'type': type
              }),
              data: data);
      if (response.statusCode == 200) {
        debugPrint('Add Account ----- > ${response.data}');
        Loader.hideLoader();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>LoginScreen(),
            ));
        Fluttertoast.showToast(
          msg: 'Registered Sucessfully...',
          backgroundColor: Colors.grey,
        );
      } else {
        Fluttertoast.showToast(
          msg: "invalid",
          backgroundColor: Colors.grey,
        );
        Loader.hideLoader();

        throw Exception(response.data);
      }
    } on DioError catch (e) {
      print("dio");
      debugPrint('Dio E  $e');
      Loader.hideLoader();
    }
  }

  Future<void> paymentStatus(BuildContext context, {FormData? data}) async {
    try {
      Loader.showLoader();
      String? id = await Preferances.getString("id");
      String? token = await Preferances.getString("token");
      String? type = await Preferances.getString("type");
      Response response;
      response = await dio.post(ApiEndPoints.paymnetStatus,
          options: Options(headers: {
            'Client-Service': 'frontend-client',
            'Auth-Key': 'simplerestapi',
            'User-ID': id,
            'Authorization': token,
            'type': type
          }),
          data: data);

      print("responseData:=${response}");
      print("responseData.status:=${response.statusCode}");
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Payment successfully",
          backgroundColor: Colors.grey,
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const BottomNavBar(
                      index: 1,
                    )),
            (Route<dynamic> route) => false);

        // return responseData;
      } else {
        Fluttertoast.showToast(
          msg: "invalid",
          backgroundColor: Colors.grey,
        );

        Loader.hideLoader();
        throw Exception(response.data);
      }
    } on DioError catch (e) {
      print("dio");
      debugPrint('Dio E  $e');
      debugPrint('Dio E  $e');
      Loader.hideLoader();
    }
  }


  Future resetPassword(
      BuildContext context, {
        FormData? data,
      }) async {
    try {
      Loader.showLoader();
      Response response;
      response = await dio.post('https://celebrationstation.in/post_ajax/update_reset_pasword/',
          // options: Options(headers: {
          //   'Client-Service': 'frontend-client',
          //   'Auth-Key': 'simplerestapi',
          //   'User-ID': id,
          //   'Authorization': token,
          //   'type': type
          // }),
          data: data);
      if (response.statusCode == 200) {
        debugPrint('reset Password ----- > ${response.data}');
        Loader.hideLoader();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen(),
            ));
        Fluttertoast.showToast(
          msg: 'Reset Password Sucessfully...',
          backgroundColor: Colors.grey,
        );
      } else {
        Fluttertoast.showToast(
          msg: "invalid",
          backgroundColor: Colors.grey,
        );
        Loader.hideLoader();

        throw Exception(response.data);
      }
    } on DioError catch (e) {
      print("dio");
      debugPrint('Dio E  $e');
      Loader.hideLoader();
    }
  }

  Future receivePayment(
      BuildContext context, {
        FormData? data,
      }) async {
    try {
      Loader.showLoader();
      Response response;
      response = await dio.post('https://celebrationstation.in/post_ajax/update_receive_payment',
          // options: Options(headers: {
          //   'Client-Service': 'frontend-client',
          //   'Auth-Key': 'simplerestapi',
          //   'User-ID': id,
          //   'Authorization': token,
          //   'type': type
          // }),
          data: data);
      if (response.statusCode == 200) {
        debugPrint('reset Password ----- > ${response.data}');
        Loader.hideLoader();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen(),
        ));
        Fluttertoast.showToast(
          msg: 'Reset Password Sucessfully...',
          backgroundColor: Colors.grey,
        );
      } else {
        Fluttertoast.showToast(
          msg: "invalid",
          backgroundColor: Colors.grey,
        );
        Loader.hideLoader();

        throw Exception(response.data);
      }
    } on DioError catch (e) {
      print("dio");
      debugPrint('Dio E  $e');
      Loader.hideLoader();
    }
  }

  Future<GetStateListModel?> getStateList() async {
    String? id = await Preferances.getString("id");
    String? token = await Preferances.getString("token");
    String? type = await Preferances.getString("type");
    try {
      Loader.showLoader();
      Response response;
      response = await dio.post(
        'https://celebrationstation.in/get_ajax/get_all_states/',
        options: Options(headers: {
          'Client-Service': 'frontend-client',
          'Auth-Key': 'simplerestapi',
          'User-ID': id,
          'Authorization': token,
          'type': type
          }
        ),
      );
      if (response.statusCode == 200) {
        GetStateListModel responseData =
        GetStateListModel.fromJson(response.data);
        Loader.hideLoader();
        return responseData;
      } else {
        Loader.hideLoader();
        throw Exception(response.data);
      }
    } on DioError catch (e) {
      Loader.hideLoader();
      debugPrint('Dio E  $e');
    } finally {
      Loader.hideLoader();
    }
  }

  Future<GetCityListModel?> getCityList(String stateId) async {
    try {
      Loader.showLoader();
      Response response;
      FormData formData = FormData.fromMap({"stateid": stateId});
      response = await dio.post('https://celebrationstation.in/get_ajax/get_all_district/',
          options: Options(),
          data: formData);
      if (response.statusCode == 200) {
        GetCityListModel responseData =
        GetCityListModel.fromJson(response.data);
        Loader.hideLoader();
        print("responseData ----- ${responseData}");
        return responseData;
      } else {
        Loader.hideLoader();
        throw Exception(response.data);
      }
    } on DioError catch (e) {
      Loader.hideLoader();
      debugPrint('Dio E  $e');
    } finally {
      Loader.hideLoader();
    }
    return null;
  }

}
