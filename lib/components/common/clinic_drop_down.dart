import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/loader_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/clinic_list_model.dart';
import 'package:kivicare_flutter/model/login_response_model.dart';
import 'package:kivicare_flutter/network/clinic_repository.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class ClinicDropDown extends StatefulWidget {
  void Function(Clinic? clinic) onSelected;
  bool isValidate;
  Clinic? clinic;
  final int? clinicId;

  ClinicDropDown({required this.onSelected, this.isValidate = false, this.clinic, this.clinicId});

  @override
  _ClinicDropDownState createState() => _ClinicDropDownState();
}

class _ClinicDropDownState extends State<ClinicDropDown> {
  final AsyncMemoizer<ClinicListModel> _memoizer = AsyncMemoizer();

  Clinic? clinic;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    clinic = widget.clinic;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ClinicListModel>(
      future: _memoizer.runOnce(() => getClinicList()),
      builder: (_, snap) {
        if (snap.hasData) {
          if (widget.clinicId != null) {
            snap.data!.clinicData!.forEach((element) {
              if (element.clinic_id.toInt() == widget.clinicId) {
                clinic = element;
              }
              appointmentAppStore.setSelectedClinic(clinic);
            });
          }
          return DropdownButtonFormField<Clinic>(
            icon: SizedBox.shrink(),
            isExpanded: true,
            value: clinic,
            dropdownColor: context.cardColor,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            items: snap.data!.clinicData!
                .map(
                  (element) => DropdownMenuItem(
                    value: element,
                    child: Text("${element.clinic_name} ", style: primaryTextStyle()),
                  ),
                )
                .toList(),
            decoration: inputDecoration(
              context: context,
              labelText: locale.lblSelectClinic,
            ).copyWith(suffixIcon: ic_arrow_down.iconImage(size: 10, color: context.iconColor).paddingAll(14)),
            onChanged: (value) {
              clinic = value;
              widget.onSelected.call(value);
              setState(() {});
              LiveStream().emit(CHANGE_DATE, true);
            },
            validator: widget.isValidate
                ? (v) {
                    if (v == null) return locale.lblClinicIsRequired;
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
