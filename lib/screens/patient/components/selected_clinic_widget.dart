import 'package:flutter/material.dart';
import 'package:momona_healthcare/network/clinic_repository.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/clinic_list_model.dart';

class SelectedClinicComponent extends StatefulWidget {
  final int clinicId;

  SelectedClinicComponent({required this.clinicId});

  @override
  State<SelectedClinicComponent> createState() => _SelectedClinicComponentState();
}

class _SelectedClinicComponentState extends State<SelectedClinicComponent> {
  Future<Clinic>? future;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getSelectedClinicAPI(
      clinicId: widget.clinicId.validate().toString(),
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
    return FutureBuilder<Clinic>(
      future: future,
      builder: (context, snap) {
        return Container(
          decoration: boxDecorationDefault(color: context.cardColor),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${locale.lblClinic}: ', style: secondaryTextStyle()),
              8.height,
              snap.hasData
                  ? Marquee(
                      child: Text("${snap.data!.name.validate()}", style: boldTextStyle(size: 18)),
                    )
                  : Text('${locale.lblLoading} ${locale.lblClinic}...', style: secondaryTextStyle()),
            ],
          ),
        );
      },
    );
  }
}
