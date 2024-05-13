import 'package:flutter/material.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/user_model.dart';
import 'package:kivicare_flutter/network/doctor_repository.dart';
import 'package:nb_utils/nb_utils.dart';

class SelectedDoctorWidget extends StatefulWidget {
  final int clinicId;
  final int doctorId;

  SelectedDoctorWidget({required this.clinicId, required this.doctorId});

  @override
  State<SelectedDoctorWidget> createState() => _SelectedDoctorWidgetState();
}

class _SelectedDoctorWidgetState extends State<SelectedDoctorWidget> {
  Future<UserModel>? future;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getSelectedDoctorAPI(
      clinicId: widget.clinicId.validate(),
      doctorId: widget.doctorId.validate(),
    ).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
      throw e;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: future,
      builder: (context, snap) {
        return Container(
          decoration: boxDecorationDefault(color: context.cardColor),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${locale.lblDoctor}: ', style: secondaryTextStyle()),
              8.height,
              snap.hasData
                  ? Marquee(
                      child: Text("${snap.data!.displayName.validate()}", style: boldTextStyle(size: 18)),
                    )
                  : Text('${locale.lblLoading} ${locale.lblDoctor}...', style: secondaryTextStyle()),
            ],
          ),
        );
      },
    );
  }
}
