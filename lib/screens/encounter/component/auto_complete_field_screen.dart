import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/no_data_found_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/network/prescription_repository.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

class AutoCompleteFieldScreen extends StatefulWidget {
  final String encounterId;
  final bool isFrequency;
  final String? name;
  final Function(String name) onTap;

  const AutoCompleteFieldScreen({Key? key, this.name, required this.encounterId, required this.isFrequency, required this.onTap}) : super(key: key);

  @override
  State<AutoCompleteFieldScreen> createState() => _AutoCompleteFieldScreenState();
}

class _AutoCompleteFieldScreenState extends State<AutoCompleteFieldScreen> {
  Future<List<String>>? future;

  TextEditingController prescriptionCont = TextEditingController();

  String? selectedValues;
  FocusNode nameFocus = FocusNode();

  bool isFirstTime = true;
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    isUpdate = widget.name != null;
    appStore.setLoading(true);
    future = getPrescriptionNameAndFrequencyAPI(id: '', isFrequency: widget.isFrequency).then((value) {
      appStore.setLoading(false);
      if (isUpdate) {
        if (widget.name.validate().isNotEmpty) {
          prescriptionCont.text = value.where((element) => element == widget.name).first;
        }
      }

      setState(() {});
      return value;
    }).catchError((e) {
      appStore.setLoading(false);
      throw e;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget getBody() {
    return FutureBuilder<List<String>>(
      future: future,
      builder: (context, snap) {
        if (snap.hasData) {
          if (snap.requireData.isEmpty) {
            return AppTextField(
              textFieldType: TextFieldType.OTHER,
              controller: prescriptionCont,
              onChanged: (newValue) {
                prescriptionCont.text = newValue;
                widget.onTap.call(newValue);
              },
              onFieldSubmitted: (value) {
                prescriptionCont.text = value;
                widget.onTap.call(value);
              },
              decoration: inputDecoration(context: context, labelText: widget.isFrequency ? locale.lblFrequency : locale.lblName),
            );
          }
          return RawAutocomplete<String>(
            onSelected: widget.onTap,
            textEditingController: prescriptionCont,
            focusNode: nameFocus,
            optionsViewBuilder: (context, onSelected, options) {
              return Material(
                color: Colors.transparent,
                child: Blur(
                  borderRadius: radius(),
                  child: AnimatedScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    mainAxisSize: MainAxisSize.min,
                    listAnimationType: isFirstTime ? listAnimationType : ListAnimationType.None,
                    children: options.map(
                      (opt) {
                        return InkWell(
                          onTap: () {
                            onSelected(opt);
                          },
                          child: Container(
                            width: context.width(),
                            decoration: boxDecorationDefault(color: context.primaryColor),
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.only(right: 26, top: 4, bottom: 4),
                            child: Text(opt, style: boldTextStyle(color: Colors.white)),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              );
            },
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isNotEmpty) {
                isFirstTime = false;
                setState(() {});
              }

              List<String> matches = <String>[];
              if (snap.requireData.isNotEmpty)
                snap.requireData.forEach((element) {
                  if (!matches.contains(element)) matches.add(element);
                });

              int index = matches.indexWhere((element) => element.toLowerCase().contains(textEditingValue.text.toLowerCase()));

              matches[index] = matches[index];

              return matches;
            },
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
              return AppTextField(
                textFieldType: TextFieldType.OTHER,
                focus: focusNode,
                controller: textEditingController,
                onTap: () {
                  prescriptionCont.text = textEditingController.text;
                  widget.onTap.call(textEditingController.text);
                },
                onFieldSubmitted: (value) {
                  prescriptionCont.text = value;
                  widget.onTap.call(textEditingController.text);
                },
                decoration: inputDecoration(context: context, labelText: widget.isFrequency ? locale.lblFrequency : locale.lblName),
              );
            },
          );
        }
        return snapWidgetHelper(
          snap,
          errorWidget: NoDataFoundWidget(text: errorMessage),
          loadingWidget: AppTextField(
            textFieldType: TextFieldType.NAME,
            onTap: () {
              widget.onTap.call(prescriptionCont.text);
            },
            onFieldSubmitted: (p0) {
              widget.onTap.call(prescriptionCont.text);
            },
            decoration: inputDecoration(context: context, labelText: widget.isFrequency ? locale.lblFrequency : locale.lblName),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }
}
