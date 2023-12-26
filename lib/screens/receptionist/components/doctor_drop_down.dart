import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/doctor_list_model.dart';
import 'package:kivicare_flutter/network/doctor_list_repository.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class DoctorDropDown extends StatefulWidget {
  void Function(DoctorList? doctorCont) onSelected;
  bool isValidate;
  DoctorList? doctorCont;
  final int? doctorId;
  final int? clinicId;

  DoctorDropDown({required this.onSelected, this.isValidate = false, this.doctorCont, this.doctorId, this.clinicId});

  @override
  _DoctorDropDownState createState() => _DoctorDropDownState();
}

class _DoctorDropDownState extends State<DoctorDropDown> {
  final AsyncMemoizer<DoctorListModel> _memoizer = AsyncMemoizer();

  DoctorList? doctorCont;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    doctorCont = widget.doctorCont;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DoctorListModel>(
      future: _memoizer.runOnce(() => getDoctorList(clinicId: widget.clinicId)),
      builder: (_, snap) {
        if (snap.hasData) {
          if (widget.doctorId != null) {
            snap.data!.doctorList!.forEach((element) {
              if (element.iD == widget.doctorId) {
                doctorCont = element;
              }
            });
          }

          return DropdownButtonFormField<DoctorList>(
            isExpanded: true,
            value: doctorCont,
            icon: SizedBox.shrink(),
            dropdownColor: context.cardColor,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            items: snap.data!.doctorList
                .validate()
                .map(
                  (element) => DropdownMenuItem(
                    value: element,
                    child: Text("${element.display_name.validate()} (${element.specialties.validate()})", style: primaryTextStyle()),
                  ),
                )
                .toList(),
            decoration: inputDecoration(
              context: context,
              labelText: locale.lblSelectDoctor,
            ).copyWith(suffixIcon: ic_arrow_down.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
            onChanged: (value) {
              doctorCont = value;
              widget.onSelected.call(value);
              setState(() {});
            },
            validator: widget.isValidate
                ? (v) {
                    if (v == null) return locale.lblDoctorIsRequired;
                    return null;
                  }
                : (v) {
                    return null;
                  },
          );
        }
        return snapWidgetHelper(snap, loadingWidget: LoaderWidget(size: loaderSize));
      },
    );
  }
}
