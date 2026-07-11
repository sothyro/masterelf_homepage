import '../l10n/app_localizations.dart';

/// Localized option lists and PDF field labels for the site inspection form.
extension InspectionFormL10n on AppLocalizations {
  List<String> get inspectionSolarTerms => [
        solarTerm01, solarTerm02, solarTerm03, solarTerm04,
        solarTerm05, solarTerm06, solarTerm07, solarTerm08,
        solarTerm09, solarTerm10, solarTerm11, solarTerm12,
        solarTerm13, solarTerm14, solarTerm15, solarTerm16,
        solarTerm17, solarTerm18, solarTerm19, solarTerm20,
        solarTerm21, solarTerm22, solarTerm23, solarTerm24,
      ];

  List<String> get inspectionLunarDates => [
        lunarDay01, lunarDay02, lunarDay03, lunarDay04, lunarDay05,
        lunarDay06, lunarDay07, lunarDay08, lunarDay09, lunarDay10,
        lunarDay11, lunarDay12, lunarDay13, lunarDay14, lunarDay15,
        lunarDay16, lunarDay17, lunarDay18, lunarDay19, lunarDay20,
        lunarDay21, lunarDay22, lunarDay23, lunarDay24, lunarDay25,
        lunarDay26, lunarDay27, lunarDay28, lunarDay29, lunarDay30,
      ];

  List<String> get inspectionFlyingStars => [
        flyingStar1, flyingStar2, flyingStar3, flyingStar4, flyingStar5,
        flyingStar6, flyingStar7, flyingStar8, flyingStar9,
      ];

  List<String> get inspectionXuanKongPeriods => [
        inspectionPeriod7, inspectionPeriod8, inspectionPeriod9Option,
      ];

  List<String> get inspectionHouseGuaOptions => [
        inspectionHouseKan, inspectionHouseKun, inspectionHouseZhen, inspectionHouseXun,
        inspectionHouseQian, inspectionHouseDui, inspectionHouseGen, inspectionHouseLi,
      ];

  List<String> get inspectionHouseGroups => [
        inspectionHouseGroupEast, inspectionHouseGroupWest,
      ];

  List<String> get inspectionClientRoles => [
        inspectionRoleOwner, inspectionRoleMainTenant, inspectionRoleCeo, inspectionRoleManager,
      ];

  List<String> get inspectionFiveElements => [
        inspectionElementWood, inspectionElementFire, inspectionElementEarth,
        inspectionElementMetal, inspectionElementWater,
      ];

  List<String> get inspectionPersonalGroups => [
        inspectionPersonalGroupEast, inspectionPersonalGroupWest,
      ];

  List<String> get inspectionBusinessGoalOptions => [
        inspectionGoalWealth, inspectionGoalCustomerFlow, inspectionGoalStability,
        inspectionGoalStaffHarmony, inspectionGoalHealth, inspectionGoalOther,
      ];

  List<String> get inspectionChallengeOptions => [
        inspectionChallengeFinancial, inspectionChallengeHealth, inspectionChallengeStaff,
        inspectionChallengeLegal, inspectionChallengeRelationship, inspectionChallengeCustomerFlow,
        inspectionGoalOther,
      ];

  List<String> get inspectionDateSelectionActivities => [
        inspectionActivityGrandOpening, inspectionActivityRenovation, inspectionActivityMovingIn,
        inspectionActivitySignInstall, inspectionActivityContract, inspectionActivityPurchases,
        inspectionGoalOther,
      ];

  List<String> get inspectionDoorConfigurations => [
        inspectionDoorOpensInward, inspectionDoorOpensOutward,
        inspectionDoorSliding, inspectionDoorAutomatic,
      ];

  List<String> get inspectionEntranceIssueOptions => [
        inspectionIssueBeamAboveDoor, inspectionIssueThroughFlow, inspectionIssueToStaircase,
        inspectionIssueToToilet, inspectionIssueNarrowEntrance, inspectionIssueNone,
      ];

  List<String> get inspectionEntranceAssessments => [
        inspectionEntranceFavorable, inspectionEntranceAcceptable, inspectionEntranceRemedial,
      ];

  List<String> get inspectionNaturalLightOptions => [
        inspectionLightAbundant, inspectionLightModerate, inspectionLightDim,
      ];

  List<String> get inspectionAirCirculationOptions => [
        inspectionAirGood, inspectionAirModerate, inspectionAirPoor,
      ];

  List<String> get inspectionFloorPlanShapes => [
        inspectionShapeSquare, inspectionShapeL, inspectionShapeIrregular, inspectionShapeTriangular,
      ];

  List<String> get inspectionFavorableNeutralUnfavorable => [
        inspectionFavorable, inspectionNeutral, inspectionUnfavorable,
      ];

  List<String> get inspectionToiletImpactOptions => [
        inspectionToiletAcceptable, inspectionToiletPoor,
      ];

  List<String> get inspectionToiletIssueOptions => [
        inspectionToiletAtCenter, inspectionToiletAtWealth, inspectionToiletNoIssues,
      ];

  List<String> get inspectionElementSupportOptions => [
        inspectionQualityStrong, inspectionModerate, inspectionQualityWeak, inspectionQualityConflicting,
      ];

  /// Field-key → localized label map for PDF export.
  Map<String, String> buildInspectionPdfFieldLabels() => {
        'inspectorName': inspectionInspectorName,
        'inspectionDate': inspectionDate,
        'timeOfArrival': inspectionTimeOfArrival,
        'weatherConditions': inspectionWeatherConditions,
        'projectName': inspectionProjectName,
        'address': inspectionAddress,
        'districtSangkat': inspectionDistrictSangkat,
        'googleMapsLink': inspectionGoogleMapsLink,
        'projectType': inspectionProjectType,
        'projectTypeOther': inspectionOtherSpecify,
        'constructionStatus': inspectionConstructionStatus,
        'estimatedCompletionYear': inspectionEstimatedCompletionYear,
        'numberOfFloors': inspectionNumberOfFloors,
        'numberOfUnits': inspectionNumberOfUnits,
        'renovationDates': inspectionRenovationDates,
        'structuralChanges': inspectionStructuralChanges,
        'renovationDetails': inspectionRenovationDetails,
        'constructionPhase': inspectionConstructionPhase,
        'phaseDetails': inspectionPhaseDetails,
        'frontageWidth': inspectionFrontageWidth,
        'depthLength': inspectionDepthLength,
        'totalSiteArea': inspectionTotalSiteArea,
        'unitWidth': inspectionUnitWidth,
        'unitDepth': inspectionUnitDepth,
        'unitArea': inspectionUnitArea,
        'floorToCeilingHeight': inspectionFloorToCeilingHeight,
        'equipmentUsed': inspectionEquipmentUsed,
        'equipmentOther': inspectionOtherEquipment,
        'facingReading1': inspectionFacingReading1,
        'facingReading2': inspectionFacingReading2,
        'facingReading3': inspectionFacingReading3,
        'averageFacing': inspectionAverageFacing,
        'converted24Mountains': inspectionConverted24Mountains,
        'facingCardinal': inspectionFacingCardinal,
        'sittingDirection': inspectionSittingDirection,
        'magneticInterferenceNotes': inspectionMagneticInterferenceNotes,
        'buildingCompletionYear': inspectionBuildingCompletionYear,
        'xuanKongPeriod': inspectionXuanKongPeriod,
        'convertedToTrigram': inspectionConvertedToTrigram,
        'houseGua': inspectionHouseGua,
        'mainEntranceSector': inspectionMainEntranceSector,
        'solarTerm': inspectionSolarTerm,
        'lunarDate': inspectionLunarDate,
        'clientFullName': inspectionClientFullName,
        'clientRole': inspectionClientRole,
        'clientBirthDate': inspectionBirthDate,
        'clientBirthTime': inspectionBirthTime,
        'clientPlaceOfBirth': inspectionPlaceOfBirth,
        'dayMaster': inspectionDayMaster,
        'personalGua': inspectionPersonalGuaLabel,
        'shengQiDirection': inspectionShengQiDirection,
        'tianYiDirection': inspectionTianYiDirection,
        'yanNianDirection': inspectionYanNianDirection,
        'fuWeiDirection': inspectionFuWeiDirection,
        'mainDoorPosition': inspectionMainDoorPosition,
        'receptionSector': inspectionReceptionSector,
        'receptionFlyingStar': inspectionReceptionFlyingStar,
        'officeSector': inspectionOfficeSector,
        'officeFlyingStar': inspectionOfficeFlyingStar,
        'toiletSectorInternal': inspectionToiletSectorInternal,
        'toiletFlyingStar': inspectionToiletFlyingStar,
        'staircaseSector': inspectionStaircaseSector,
        'staircaseFlyingStar': inspectionStaircaseFlyingStar,
        'room1Sector': inspectionRoom1Sector,
        'room1FlyingStar': inspectionRoom1FlyingStar,
        'kitchenLocation': inspectionKitchenLocation,
        'bathroomLocation': inspectionBathroomLocation,
        'drainageDirection': inspectionDrainageDirection,
        'estimatedReportDeliveryDate': inspectionEstimatedReportDeliveryDate,
      };
}
