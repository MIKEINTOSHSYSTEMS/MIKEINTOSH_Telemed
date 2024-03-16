import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:momona_healthcare/components/loader_widget.dart';
import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/drop_down_options_class.dart';
import 'package:momona_healthcare/network/dashboard_repository.dart';
import 'package:momona_healthcare/screens/doctor/components/monthly_chart_component.dart';
import 'package:momona_healthcare/screens/doctor/components/weekly_chart_component.dart';
import 'package:momona_healthcare/screens/doctor/components/yearly_chart_component.dart';
import 'package:momona_healthcare/utils/app_common.dart';
import 'package:momona_healthcare/utils/app_widgets.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:momona_healthcare/model/upcoming_appointment_model.dart';

class ShowAppointmentChartScreen extends StatefulWidget {
  const ShowAppointmentChartScreen({Key? key}) : super(key: key);

  @override
  State<ShowAppointmentChartScreen> createState() => _ShowAppointmentChartScreenState();
}

class _ShowAppointmentChartScreenState extends State<ShowAppointmentChartScreen> {
  DropDownOptionsClass? dropdownValue;
  DropDownOptionsClass? dropdownValueSpecific;

  List<WeeklyAppointment> appointmentsCount = [];

  List<DropDownOptionsClass>? dropDownList = [];
  List<DropDownOptionsClass>? yearsList = getYearsList();
  List<DropDownOptionsClass>? weeksList = getWeeksList();

  @override
  void initState() {
    super.initState();
    init();
    getCounts();
  }

  void init() async {
    dropdownValue = statsOptions.first;
    dropDownList = weeksList;
    dropdownValueSpecific = weeksList!.firstWhere((element) => element.isCurrentWeek);

    setState(() {});
  }

  Future<void> getCounts() async {
    appStore.setLoading(true);
    Map request;

    if (dropdownValue!.value == StatsFilters.weekly) {
      request = {"filter_by": "weekly", "specific_filter": 49, "start_date": dropdownValueSpecific?.startDate, "end_date": dropdownValueSpecific?.endDate};
    } else {
      request = {
        "filter_by": dropdownValue!.value,
        "specific_filter": dropdownValueSpecific!.value.toLowerCase(),
      };
    }
    await getAppointmentCountAPI(request: request).then((value) {
      appointmentsCount = value;
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast('${locale.lblError}: ${e.toString()}', print: true);
    });
  }

  @override
  void dispose() {
    getDisposeStatusBarColor();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblAppointmentCount, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            16.height,
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(color: context.cardColor, borderRadius: radius()),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<DropDownOptionsClass>(
                        borderRadius: BorderRadius.circular(defaultRadius),
                        dropdownColor: context.cardColor,
                        icon: Icon(Icons.arrow_drop_down),
                        elevation: 8,
                        isExpanded: true,
                        style: primaryTextStyle(),
                        onChanged: (DropDownOptionsClass? newValue) {
                          dropdownValue = newValue;

                          if (newValue!.value == StatsFilters.monthly) {
                            dropDownList = getMonthsList;
                            dropdownValueSpecific = getMonthsList.firstWhere((element) => element.value == DateTime.now().month.toString());
                          } else if (newValue.value == StatsFilters.yearly) {
                            dropDownList = yearsList;
                            dropdownValueSpecific = yearsList!.firstWhere((element) => element.value == DateTime.now().year.toString());
                          } else if (newValue.value == StatsFilters.weekly) {
                            init();
                          }
                          getCounts();
                          setState(() {});
                        },
                        items: statsOptions.validate().map<DropdownMenuItem<DropDownOptionsClass>>((DropDownOptionsClass value) {
                          return DropdownMenuItem<DropDownOptionsClass>(
                            value: value,
                            child: Text(value.title, style: primaryTextStyle(), overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        value: dropdownValue,
                      ),
                    ),
                  ),
                ).expand(),
                16.width,
                Container(
                  decoration: BoxDecoration(color: context.cardColor, borderRadius: radius()),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<DropDownOptionsClass>(
                        dropdownColor: context.cardColor,
                        borderRadius: BorderRadius.circular(defaultRadius),
                        icon: Icon(Icons.arrow_drop_down),
                        elevation: 8,
                        isExpanded: true,
                        style: primaryTextStyle(),
                        onChanged: (DropDownOptionsClass? newValue) {
                          dropdownValueSpecific = newValue;
                          getCounts();

                          setState(() {});
                        },
                        items: dropDownList.validate().map<DropdownMenuItem<DropDownOptionsClass>>((DropDownOptionsClass value) {
                          return DropdownMenuItem<DropDownOptionsClass>(
                            value: value,
                            child: Text(value.title, style: primaryTextStyle(), overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        value: dropdownValueSpecific,
                      ),
                    ),
                  ),
                ).expand(),
              ],
            ).paddingSymmetric(horizontal: 16),
            16.height,
            if (dropdownValue!.value == StatsFilters.weekly)
              appointmentsCount.isNotEmpty
                  ? Container(
                      height: 220,
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.only(left: 16, right: 16, top: 24),
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: BorderRadius.all(radiusCircular(defaultRadius)),
                        backgroundColor: context.scaffoldBackgroundColor,
                      ),
                      child: WeeklyChartComponent(weeklyAppointment: appointmentsCount).withWidth(context.width()),
                    )
                  : Container(
                      height: 220,
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.only(left: 16, right: 16, top: 24),
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: BorderRadius.all(radiusCircular(defaultRadius)),
                        backgroundColor: context.scaffoldBackgroundColor,
                      ),
                      child: WeeklyChartComponent(weeklyAppointment: emptyGraphList).withWidth(context.width()),
                    )
            else if (dropdownValue!.value == StatsFilters.monthly)
              appointmentsCount.isNotEmpty
                  ? Container(
                      height: 220,
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.only(left: 16, right: 16, top: 24),
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: BorderRadius.all(radiusCircular(defaultRadius)),
                        backgroundColor: context.scaffoldBackgroundColor,
                      ),
                      child: MonthlyChartComponent(weeklyAppointment: appointmentsCount).withWidth(context.width()),
                    )
                  : Container(
                      height: 220,
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.only(left: 16, right: 16, top: 24),
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: BorderRadius.all(radiusCircular(defaultRadius)),
                        backgroundColor: context.scaffoldBackgroundColor,
                      ),
                      child: MonthlyChartComponent(weeklyAppointment: emptyGraphListMonthly).withWidth(context.width()),
                    )
            else
              appointmentsCount.isNotEmpty
                  ? Container(
                      height: 220,
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.only(left: 16, right: 16, top: 24),
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: BorderRadius.all(radiusCircular(defaultRadius)),
                        backgroundColor: context.scaffoldBackgroundColor,
                      ),
                      child: YearlyChartComponent(weeklyAppointment: appointmentsCount).withWidth(context.width()),
                    )
                  : Container(
                      height: 220,
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.only(left: 16, right: 16, top: 24),
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: BorderRadius.all(radiusCircular(defaultRadius)),
                        backgroundColor: context.scaffoldBackgroundColor,
                      ),
                      child: YearlyChartComponent(weeklyAppointment: emptyGraphListYearly).withWidth(context.width()),
                    ),
            Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading).center())
          ],
        ),
      ),
    );
  }
}
