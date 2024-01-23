import 'package:flutter/material.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/doctor_list_model.dart';
import 'package:momona_healthcare/network/doctor_list_repository.dart';
import 'package:momona_healthcare/utils/colors.dart';
import 'package:momona_healthcare/utils/common.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class MultiSelectDoctorDropDown extends StatefulWidget {
  List<String>? selectedServicesId;

  MultiSelectDoctorDropDown({this.selectedServicesId});

  @override
  _MultiSelectDoctorDropDownState createState() => _MultiSelectDoctorDropDownState();
}

class _MultiSelectDoctorDropDownState extends State<MultiSelectDoctorDropDown> {
  TextEditingController search = TextEditingController();

  List<DoctorList> searchDoctorList = [];

  List<DoctorList> doctorList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void getData() async {
    appStore.setLoading(true);

    await getDoctorList(clinicId: isReceptionist() ? getIntAsync(USER_CLINIC) : "" as int?).then((value) {
      doctorList.addAll(value.doctorList!);
      searchDoctorList.addAll(value.doctorList!);
      doctorList.forEach((element) {
        if (widget.selectedServicesId!.contains(element.iD.toString())) {
          element.isCheck = true;
        }
      });
      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  List<DoctorList> getSelectedData() {
    List<DoctorList> selected = [];

    doctorList.forEach((value) {
      if (value.isCheck == true) {
        selected.add(value);
      }
    });
    setState(() {});
    return selected;
  }

  init() async {
    getData();
  }

  onSearchTextChanged(String text) async {
    doctorList.clear();

    if (text.isEmpty) {
      doctorList.addAll(searchDoctorList);
      setState(() {});
      return;
    }
    searchDoctorList.forEach((element) {
      if (element.display_name!.toLowerCase().contains(text)) doctorList.add(element);
    });
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appStore.isDarkModeOn ? Colors.black : Colors.white,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 60),
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  height: 4,
                  width: 30,
                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(defaultRadius)),
                ).center(),
                8.height,
                Row(
                  children: [
                    Text(locale.lblSelectDoctor, style: boldTextStyle(size: 18)).expand(),
                    IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () {
                        finish(context, getSelectedData());
                      },
                    )
                  ],
                ),
                Divider(),
                8.height,
              ],
            ),
            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey.withOpacity(0.2)),
              child: TextField(
                onChanged: onSearchTextChanged,
                autofocus: false,
                textInputAction: TextInputAction.go,
                controller: search,
                style: boldTextStyle(size: 20),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  hintText: locale.lblSearch,
                  hintStyle: secondaryTextStyle(size: 20),
                  prefixIcon: Icon(Icons.search, size: 25, color: primaryColor),
                ),
              ),
            ),
            ListView.builder(
              itemCount: doctorList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                DoctorList data = doctorList[index];
                return Theme(
                  data: ThemeData(unselectedWidgetColor: primaryColor),
                  child: CheckboxListTile(
                    value: data.isCheck,
                    title: Text(data.display_name.validate(), maxLines: 2, overflow: TextOverflow.ellipsis, style: primaryTextStyle()),
                    onChanged: (v) {
                      data.isCheck = !data.isCheck;
                      if (v!) {
                        widget.selectedServicesId!.add(data.iD.toString());
                      } else {
                        widget.selectedServicesId!.remove(data.iD.toString());
                      }
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ],
        ).visible(!appStore.isLoading, defaultWidget: LoaderWidget()),
      ),
    );
  }
}
