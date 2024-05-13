import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/qualification_model.dart';
import 'package:kivicare_flutter/screens/doctor/screens/add_qualification_screen.dart';
import 'package:kivicare_flutter/screens/receptionist/components/qualification_item_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class QualificationWidget extends StatefulWidget {
  List<Qualification> qualificationList;
  bool showAdd;
  final Function(List<Qualification>)? callBack;
  QualificationWidget({required this.qualificationList, this.callBack, this.showAdd = true});

  @override
  _QualificationWidgetState createState() => _QualificationWidgetState();
}

class _QualificationWidgetState extends State<QualificationWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(locale.lblQualification, style: boldTextStyle(color: context.primaryColor, size: 18)).expand(),
            if (widget.showAdd)
              TextButton(
                onPressed: () async {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: AddQualificationScreen(
                          onSubmit: (qualificationData) {
                            widget.qualificationList.add(qualificationData);
                            widget.callBack?.call(widget.qualificationList);
                            setState(() {});
                          },
                        ),
                      );
                    },
                  );
                },
                child: Text(locale.lblAddNewQualification, style: secondaryTextStyle()),
              )
          ],
        ),
        Divider(color: context.dividerColor, height: 0),
        8.height,
        if (widget.qualificationList.validate().isNotEmpty)
          AnimatedListView(
            shrinkWrap: true,
            itemCount: widget.qualificationList.validate().length,
            itemBuilder: (context, index) {
              Qualification element = widget.qualificationList.validate()[index];

              return QualificationItemWidget(
                data: element,
                showAdd: widget.showAdd,
                onEdit: () async {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    constraints: BoxConstraints(maxHeight: context.height() / 2),
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: AddQualificationScreen(
                          qualification: element,
                          onSubmit: (qualificationData) {
                            element = qualificationData;
                            widget.qualificationList[index] = qualificationData;
                            widget.callBack?.call(widget.qualificationList);
                            setState(() {});
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          )
        /* else
          NoDataFoundWidget(iconSize: 100, text: locale.lblNoQualificationsFound).center(),*/
      ],
    );
  }
}
