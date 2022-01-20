import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';

class IconsWithTexts{
  static const Map<EventStatus, Map<String, IconData>> uesWithIcons = {

    EventStatus.attending: {AppStrings.attending: Icons.check},


    EventStatus.notAttending: {AppStrings.notAttending: Icons.block},


    EventStatus.interested: {AppStrings.interested: Icons.lightbulb},


    EventStatus.invited: {AppStrings.invited: Icons.lightbulb}

  };
}