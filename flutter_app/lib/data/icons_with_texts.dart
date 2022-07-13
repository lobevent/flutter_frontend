import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/styles/icons.dart';
import 'package:flutter_frontend/presentation/core/styles/icons.dart';
import 'package:flutter_frontend/presentation/core/styles/icons.dart';
import 'package:flutter_frontend/presentation/core/styles/icons.dart';
import 'package:flutter_frontend/presentation/core/styles/icons.dart';

class IconsWithTexts{
  static const Map<EventStatus, Map<String, IconData>> uesWithIcons = {

    EventStatus.attending: {AppStrings.attending: AppIcons.attending},


    EventStatus.notAttending: {AppStrings.notAttending: AppIcons.notAttending},


    EventStatus.interested: {AppStrings.interested: AppIcons.interested},


    EventStatus.invited: {AppStrings.invited: AppIcons.invited},

    EventStatus.confirmAttending: {AppStrings.there: AppIcons.there},

  };
}