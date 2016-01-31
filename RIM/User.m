//
//  User.m
//  Max FDP
//
//  Created by Michael Gehringer on 01.09.10.
//  Copyright 2010 Mikelsoft.com. All rights reserved.
//

#import "User.h"


static User *sharedUser = nil;

@implementation User

@synthesize arrayAllCompanyAirports,strSelectedWaypoint;

@synthesize strAverageFF,strAverageISADeviation,strAverageTemperature,strAverageWindComponent,strAverageWindDirection,strAverageWindSpeed,strRouteDescription,strClimbMach,strClimbSpeed,strCruiseCI,strDescendMach,strDescendSpeed,strGreatCircleDistance,strAirDistance,strGroundDistance,strOptimization,strPerformanceFactor,strRouteName;

@synthesize strTripFuel,strContingencyEnrouteAlternate,strContingencyFuel,strContingencyPolicy,strAlternateDuration,strAlternateFuel,strAlternateAirport,arrDestinationAlternates,strFinalReserveDuration,strFinalReserveFuel,strETOPSFuel,strETOPSDuration,strPosExtraFuel,strMaxFuelWeight,strTakeOffEstimatedFuel,strTakeOffEstimatedDuration,strTaxiDuration,strTaxiFuel,strBlockDuration,strBlockFuel,strArrivalDuration,strArrivalFuel,arrFuelAdjustments,strDryOperatingWeight,strLoadWeight,strZeroFuelWeight,strZeroFuelWeightLimit,strTakeOffWeight,strTakeOffWeightOpsLimit,strTakeOffWeightStructLimit,strLandingWeight,strLandingWeightOpsLimit,strLandingWeightStructLimit;

@synthesize strMapCenter,bolCenterMap,dblLatitudeMapCenter,dblLongitudeMapCenter,bolInFlightPos,dblLatitudePPos,dblLongitudePPos,strFlightStatus,bolCalcSSSR;


@synthesize arrayEscapeRoutes,strAircraft,strDirection,arrayEnrouteAirports,strEntityName,arrayEscapeWpts,lookup, lookupAirport,arrAirport,strAircraftType,arrayAlternates,strEntityAirports,strPathDocuments,strPathDirectory,strPath2Title,strPath3Title,strWptTitle,bolWPT,bolPreviewWPT,strWptRegion,strAptRegion,strPathOFP,arrayEnRouteWaypoints,arrayLog,strDeparture,strDestination,strFlightPlanEquipment,strAircraftLog,strDirectionLog,arrayLogDestinationAlternates,strAnnAirport,arrayAllAirports,strOffBlockTime,strTakeOffTime,strLandingTime,strFlightPlanTitle,strOFPHeader,arrayEFF,strATCFltpln,strAlt,strFltplanTitle,intRowWaypoint,arrayBriefingAirport,arrayLogXML,arrayWXAirports,arrayAirportAlternates,strAircraftRegistration,strFlightIdentifier,strTripDuration,strInitialAltitude,strETADestination,strETASchedDestination,arrayAirportDataList,strOFPNumber;

////SunFlight

@synthesize TimeOvhdFROM,TimeOvhdTO,intTimeOvhdFROM,intTimeOvhdTO,dblLatitudeFROM,dblLongitudeFROM,dblLatitudeTO,dblLongitudeTO,strSunrise,strSunset,strLatSunrise,strLatSunset,strLongSunset,strLongSunrise,dateFlight,intFlightTime,timeTimeLandTO,timeTimeTakeOffFROM,intFlightLevel,txtDepAirport,txtDestAirport,bolDepAirport,bolDestAirport,intFlightLevelCorr,bolSunSet,bolSunRise,IntTimeDifference,IntTimeDifferenceDest,TimeOvhdFROMLCL,TimeOvhdTOLCL,bolInFlight,bolPreFlight,strSunsetLCL,strSunriseLCL,dblDistanceNM,TimeSunsetDep,TimeSunriseDep,TimeSunsetDest,TimeSunriseDest,intDayFlightTime,intNightFlightTime,bolDay,strAirportCity,strAirportIATA,strAirportICAO,strAirportName,IntTimeZone,bolCalcPossible,dblLatitudeTOInFlight,dblLongitudeFROMInFlight,dblLongitudeFROMPreFlight,dblLatitudeTOPreFlight,dblLongitudeTOInFlight,dblLatitudeFROMInFlight,dblLongitudeTOPreFlight,dblLatitudeFROMPreFlight,intTimeOvhdTOInFlight,intTimeOvhdTOPreFlight,intTimeOvhdFROMInFlight,intTimeOvhdFROMPreFlight,strTimeZoneName,arrayCoordinates,strTimeDifferenceDep,strTimeDifferenceDest,dblLatitudeSR,dblLatitudeSS,dblLongitudeSR,dblLongitudeSS,strFlightTime,intSunset,intSunrise,intSunriseDep,intSunsetDep,intSunsetDest,intSunriseDest,bolCalcDayNightTime,intTimeOvhdTOLCL,intTimeOvhdFROMLCL,intFajr,intIsha,strFajr,strIsha,strFajrLCL,strIshaLCL,bolIsha,bolFajr,strSunriseDEP,strSunsetDEP,strSunsetDEST,strSunriseDEST,arrayCoordinatesInFlight,dblLatitudeSRInFlight,dblLatitudeSSInFlight,dblLongitudeSRInFlight,dblLongitudeSSInFlight,strLatSunriseInFlight,strLongSunriseInFlight,strLatSunsetInFlight,strLongSunsetInFlight,txtLatFROMInFlight,txtLatTOInFlight,txtLongFROMInFlight,txtLongTOInFlight,strTimeFROM,strTimeTO,bolSunRiseInFlight,bolSunSetInFlight,strSunriseInFlight,strSunsetInFlight,strFlightTransfer,arrayResults,bolFajr2,bolIsha2,bolSunRise2,bolSunSet2,strFajr2,strFajrLCL2,strIsha2,strIshaLCL2,strSunrise2,strSunriseInFlight2,strSunriseLCL2,strSunriseLCLinFlight,strSunriseLCLinFlight2,strSunset2,strSunsetInFlight2,strSunsetLCL2,strSunsetLCLinFlight,strSunsetLCLinFlight2,strLatSunrise2,strLatSunriseInFlight2,strLatSunset2,strLatSunsetInFlight2,strLongSunrise2,strLongSunriseInFlight2,strLongSunset2,strLongSunsetInFlight2,dblLatitudeSR2,dblLatitudeSRInFlight2,dblLatitudeSS2,dblLatitudeSSInFlight2,dblLongitudeSR2,dblLongitudeSRInFlight2,dblLongitudeSS2,dblLongitudeSSInFlight2,bolSunRiseInFlight2,bolSunSetInFlight2,intSection;

/// Max FDP

//@synthesize IntTimeDifference;
@synthesize ReportTime;
@synthesize ReliefRestTime, IntInflightRestTime;
@synthesize BolPilots, BolAcclimatized, BolPreceedingRestless18, BolSectorLess7hrs, IntSectorNumbers;
@synthesize IntsegPilots, IntsegBlockhours, BolswcInFlightRelief, IntsegRestTakenIn, BolsegBunk, BolsegSeat, IntTimeRest, IntSplitDuty, BolswcSplitDuty;
@synthesize BolswcStandby, BolswcSBYRest;
@synthesize SBYBegin, OriginalReportTime, OriginalStandbyTime, IntMaxFDPCorrectionSBY, OriginalActualReportTime, LimitingReportTime, FDPStartTime;
@synthesize DelayActReport, IntsegDelayHours, BolswcDelay, BolDelayMore4;
@synthesize IntTableAacclimatised, IntTableBnonAcclimatised, IntMaxFDP, IntMaxFDPHours, IntMaxFDPMinutes, IntMaxFDPENDHours, IntMaxFDPENDMinutes, IntSTARTFDPHours, IntSTARTFDPMinutes;
@synthesize IntSegCrew, IntSegBodyClock, IntSegLongRange;
@synthesize txtTimeBand, txtStartFDP, txtMaxFDP, txtCorrections, txtCorrectionDiscr, txtNewCorrFDP, txtReducedDiscr, txtEndTimeLCL, txtEndTimeUTC,IntSplitDutyPicker,BolSectorSelected;

// FuelUplift

@synthesize intVolume,intWeight,intDensity,intFactVolume,strVolumetxt,strWeighttxt,intFactWeight,bolMultipleReceipts,specificSG,strDensity,strDensityDecimal,strlblDensity;

#pragma mark -

#pragma mark Singleton Methods

+ (User *)sharedUser {
    
    if(sharedUser == nil){
        
        sharedUser = [[super allocWithZone:NULL] init];
        
    }
    
    return sharedUser;
    
}

+ (id)allocWithZone:(NSZone *)zone {
    
    return [self sharedUser];
    
}

- (id)copyWithZone:(NSZone *)zone {
    
    return self;
    
}

@end
