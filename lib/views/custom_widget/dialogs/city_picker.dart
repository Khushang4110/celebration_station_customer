import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../Utils/colors_utils.dart';
import '../../../model/city_model.dart';
import '../../../model/get_city_list_model.dart';
import '../../../services/api_services.dart';
import '../primary_textfield.dart';

class CityPickerDailog extends StatefulWidget {
  final String stateId;
  const CityPickerDailog({
    super.key,
    required this.stateId,
  });

  static Future<CityModel> show(BuildContext context, String stateId) async {
    return await showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CityPickerDailog(stateId: stateId),
    );
  }

  @override
  State<CityPickerDailog> createState() => _StatePickerDailogState();
}

class _StatePickerDailogState extends State<CityPickerDailog> {
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;

  List<CityModel> _city = [];
  List<CityModel> _cityResponse = [];

  @override
  void initState() {
    super.initState();
    fetchState();
  }

  Future<void> fetchState() async {
    GetCityListModel? response = await ApiService().getCityList(widget.stateId);
    if (response != null) {
      if (response != null) {
        _city = response.district
            .map((e) => CityModel.fromJson(e.toJson()))
            .toList();
        _cityResponse = response.district
            .map((e) => CityModel.fromJson(e.toJson()))
            .toList();
        setState(() {});
      }
    } else {
      print("first select state");
    }
  }

  Future<void> _onSearchHandler(String query) async {
    if (query.isNotEmpty) {
      _isSearching = true;
      _city = _isSearching ? searchCountry(query) : _city;
    } else {
      _city.clear();
      _city = _cityResponse;
      _isSearching = false;
    }
    setState(() {});
  }

  List<CityModel> searchCountry(String query) {
    return _cityResponse
        .where(
            (e) => e.districtName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Dialog(
        insetPadding: EdgeInsets.all(20.h),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 20.h,
          ),
          child: Column(
            children: [
              PrimaryTextField(
                controller: _searchController,
                onChanged: _onSearchHandler,
                hintText: 'Search State',
                color: ColorUtils.lightGreyColor,
                suffix: _isSearching
                    ? InkWell(
                        onTap: () {
                          _searchController.clear();
                          _isSearching = false;
                          _city.clear();
                          _city = _cityResponse;
                          setState(() {});
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.clear,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : null,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _city.length,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  itemBuilder: (context, index) {
                    CityModel cityModel = _city[index];
                    return _CountryStateListTile(
                      cityModel: cityModel,
                      onTap: () {
                        Navigator.pop(context, cityModel);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountryStateListTile extends StatelessWidget {
  final CityModel cityModel;
  final VoidCallback onTap;
  const _CountryStateListTile({
    required this.cityModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: 12.h, vertical: 18.h),
              decoration: BoxDecoration(
                  color: ColorUtils.lightGreyColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                cityModel.districtName ?? '',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ));
  }
}
