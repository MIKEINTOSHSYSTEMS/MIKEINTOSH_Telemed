import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/view_all_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/screens/patient/components/news_dashboard_widget.dart';
import 'package:kivicare_flutter/screens/patient/models/news_model.dart';
import 'package:nb_utils/nb_utils.dart';

class DashBoardFragmentNewsComponent extends StatelessWidget {
  final List<NewsData> newsList;
  DashBoardFragmentNewsComponent({required this.newsList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: locale.lblExpertsHealthTipsAndAdvice,
          subLabel: locale.lblArticlesByHighlyQualifiedDoctors,
          list: newsList.validate(),
          viewAllShowLimit: 2,
          onTap: () => patientStore.setBottomNavIndex(2),
        ),
        8.height,
        Wrap(
          runSpacing: 16,
          spacing: 16,
          children: List.generate(
            newsList.take(3).length,
            (index) => NewsDashboardWidget(newsData: newsList[index]),
          ),
        )
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}
