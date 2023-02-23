import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../Utils/colors_utils.dart';
import '../dashboard/bottomNavBar/tabs/profile/components/profilePic.dart';
import '../model/GetAllProfileModel.dart';
import '../services/api_services.dart';

class ProfileDetailsScreen extends StatefulWidget {
  final String userId;
  final String token;
  final String type;
  const ProfileDetailsScreen(
      {Key? key, required this.userId, required this.token, required this.type})
      : super(key: key);

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  ProfileDetails? profileDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApiService().getProfileRecord(context).then((value) {
      if (value!.message == "ok") {
        print("hhiii");
        setState(() {
          profileDetails = value.detail!;
        });
        print('model:$profileDetails');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: ColorUtils.primaryColor,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'Profile Information',
              style: TextStyle(color: ColorUtils.blackColor),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: BackButton(
              color: ColorUtils.blackColor,
            ),
          ),
          extendBodyBehindAppBar: true,
          body: ListView(
            children: [
              _ProfilePhoto(),
              SizedBox(height: 2.h),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: ColorUtils.whiteColor,
                ),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        "Profile Information",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTextField("Business Name:",'${profileDetails?.bRANCHFIRMNAME ?? ""}'),
                            buildTextField("Owner Name:",'${profileDetails?.bRANCHNAME ?? ""}'),
                            buildTextField("Contact No:",'${profileDetails?.bRANCHUSERNAME ?? ""}'),
                            buildTextField("Email Id: ",'${profileDetails?.bRANCHEMAIL ?? ""}'),
                            buildTextField("State:",'${profileDetails?.sTATENAME ?? ""}'),
                            buildTextField("District:",'${profileDetails?.dISTRICTNAME ?? ""}'),
                            buildTextField("Business type:",'${profileDetails?.gASNAME ?? ""}'),
                            buildTextField("Pincode:",'${profileDetails?.bRANCHPINCODE ?? ""}'),
                            buildTextField("Address:",'${profileDetails?.bRANCHADDRESS ?? ""}'),
                            buildTextField("Whatsapp Number:",'${profileDetails?.bRANCHALTCONTACT ?? ""}'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
  Widget buildTextField(
      String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            labelStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.lime,
            ),
            hintStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }

}

class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          ProfilePic(),
        ],
      ),
    );
  }
}


