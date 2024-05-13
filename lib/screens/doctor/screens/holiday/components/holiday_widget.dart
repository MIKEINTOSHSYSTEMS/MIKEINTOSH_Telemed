import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kivicare_flutter/components/image_border_component.dart';
import 'package:kivicare_flutter/components/status_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/holiday_model.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

class HolidayWidget extends StatelessWidget {
  final HolidayData data;

  HolidayWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    int totalDays = getDateDifference(data.holidayStartDate.validate(), eDate: data.holidayEndDate.validate(), isForHolidays: true) + 1;
    int pendingDays = getDateDifference(data.holidayStartDate.validate());
    List<DateTime> dates = getDatesBetweenTwoDates(DateFormat(SAVE_DATE_FORMAT).parse(data.holidayStartDate.validate()), DateFormat(SAVE_DATE_FORMAT).parse(data.holidayEndDate.validate()));

    String today = DateFormat(SAVE_DATE_FORMAT).format(DateTime.now());
    bool isPending = getDateDifference(data.holidayEndDate.validate()) < 0;
    bool isOnLeave = dates.map((date) => DateFormat(SAVE_DATE_FORMAT).format(date)).contains(today);

    return Container(
      width: context.width() / 2 - 24,
      decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor, border: Border.all(color: context.dividerColor)),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageBorder(src: data.userProfileImage.validate(), height: 34, nameInitial: isDoctor() ? data.userName.validate(value: 'D')[0] : data.userName.validate(value: 'C')[0]),
                      8.width,
                      Marquee(
                        child: Text(isDoctor() ? data.userName.validate().prefixText(value: 'Dr. ') : data.userName.validate(), style: boldTextStyle(size: 16)),
                      ).expand(),
                    ],
                  ),
                  8.height,
                  Text('${data.startDate.validate()}', style: primaryTextStyle(size: 14)),
                  Text('—', style: primaryTextStyle()),
                  Text('${data.endDate.validate()}', style: primaryTextStyle(size: 14)),
                  10.height,
                  if (isOnLeave)
                    Text(isReceptionist() ? data.userName.split(' ').first.validate() + " " + locale.lblIsOnLeave : locale.lblTodayIsHoliday, style: boldTextStyle(size: 14, color: appPrimaryColor))
                  else
                    Text(locale.lblAfter + ' ${pendingDays == 0 ? '1' : pendingDays.abs()} ' + locale.lblDays, style: boldTextStyle(size: 14)).visible(isPending),
                  if (!isOnLeave)
                    Text(
                      locale.lblWasOffFor + ' $totalDays ' + locale.lblDays,
                      style: boldTextStyle(size: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).visible(!isPending),
                ],
              ).expand(),
            ],
          ).paddingAll(16),
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: StatusWidget(
              status: '',
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              borderRadius: radiusOnly(topLeft: defaultRadius, bottomLeft: defaultRadius),
              backgroundColor: getHolidayStatusColor(isPending, isOnLeave).withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
