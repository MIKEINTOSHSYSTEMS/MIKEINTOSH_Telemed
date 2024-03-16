import 'package:momona_healthcare/main.dart';
import 'package:momona_healthcare/model/encounter_model.dart';
import 'package:momona_healthcare/model/encounter_type_model.dart';
import 'package:momona_healthcare/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

List<EncounterType> getEncounterOtherTypeList({required String encounterType, required EncounterModel encounterData}) {
  switch (encounterType) {
    case PROBLEM:
      return encounterData.problem.validate();
    case OBSERVATION:
      return encounterData.observation.validate();
    case NOTE:
      return encounterData.note.validate();
    default:
      return [];
  }
}

(List<EncounterType> encounterOtherTypeList, {String? emptyText}) getEncounterOtherTypeListData({required String encounterType, required EncounterModel encounterData}) {
  switch (encounterType) {
    case PROBLEM:
      return (encounterData.problem.validate(), emptyText: encounterData.problem.validate().isEmpty ? locale.lblNoProblemFound.capitalizeEachWord() : null);
    case OBSERVATION:
      return (encounterData.observation.validate(), emptyText: encounterData.observation.validate().isEmpty ? locale.lblNoObservationsFound.capitalizeEachWord() : null);
    case NOTE:
      return (encounterData.note.validate(), emptyText: encounterData.note.validate().isEmpty ? locale.lblNoNotesFound.capitalizeEachWord() : null);
    default:
      return ([], emptyText: '');
  }
}
