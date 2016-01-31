//
//  User.h
//  Max FDP
//
//  Created by Michael Gehringer on 01.09.10.
//  Copyright 2010 Mikelsoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "EFF.h"


@interface User : NSObject {
    NSMutableArray *arrayAllCompanyAirports;

    // Sunrise-Sunset
    BOOL bolCalcSSSR;
    //MapPointFocus
    NSString *strSelectedWaypoint;
    NSString *strFlightStatus;
    NSString *strMapCenter;
    double    dblLatitudeMapCenter;
    double    dblLongitudeMapCenter;
    BOOL bolCenterMap;
    bool bolInFlightPos;
    double    dblLongitudePPos;
    double    dblLatitudePPos;
    // FlightPlanXML
    NSMutableArray *arrayAirportDataList;
    NSMutableArray *arrayBriefingAirport;
    NSMutableArray *arrayEscapeRoutes;
    NSMutableSet *lookup;
    NSArray *arrayEscapeWpts;
    NSMutableArray *arrayEnrouteAirports;
    NSMutableArray *arrayWXAirports;
    NSMutableArray *arrayAlternates;
    NSMutableArray *arrayAirportAlternates;
    
    NSMutableArray *arrayAllAirports;
    NSString *strDirection;
    NSString *strAircraftRegistration;
    NSString *strFlightIdentifier;
    
    NSString *strOFPNumber;
    NSString *strTripDuration;
    
    NSString *strAircraft;
    NSString *strEntityName;
    NSString *strEntityAirports;
    
    // Header RouteInformation
    
    NSString *strPerformanceFactor;
    NSString *strAverageFF;
    NSString *strRouteName;
    NSString *strOptimization;
    NSString *strAverageWindDirection;
    NSString *strAverageWindSpeed;
    NSString *strAverageWindComponent;
    NSString *strAverageTemperature;
    NSString *strAverageISADeviation;
    NSString *strInitialAltitude;
    NSString *strClimbMach;
    NSString *strClimbSpeed;
    NSString *strCruiseCI;
    NSString *strDescendMach;
    NSString *strDescendSpeed;
    NSString *strRouteDescription;
    NSString *strGroundDistance;
    NSString *strAirDistance;
    NSString *strGreatCircleDistance;
    
    // Fuel Times Weights
    
    NSString *strETADestination;
    NSString *strETASchedDestination;
    
    // FuelHeader
    
    NSString *strTripFuel;
    NSString *strContingencyFuel;
    NSString *strContingencyPolicy;
    NSString *strContingencyEnrouteAlternate;
    NSString *strAlternateDuration;
    NSString *strAlternateFuel;
    NSString *strAlternateAirport;
    NSMutableArray *arrDestinationAlternates;
    NSString *strFinalReserveFuel;
    NSString *strFinalReserveDuration;
    NSString *strETOPSFuel;
    NSString *strETOPSDuration;
    NSString *strPosExtraFuel;
    NSString *strMaxFuelWeight;
    NSString *strTakeOffEstimatedFuel;
    NSString *strTakeOffEstimatedDuration;
    NSString *strTaxiFuel;
    NSString *strTaxiDuration;
    NSString *strBlockFuel;
    NSString *strBlockDuration;
    NSString *strArrivalFuel;
    NSString *strArrivalDuration;
    NSMutableArray *arrFuelAdjustments;
    
    // WEIGHTS
    
    NSString *strDryOperatingWeight;
    NSString *strLoadWeight;
    NSString *strZeroFuelWeight;
    NSString *strZeroFuelWeightLimit;
    NSString *strTakeOffWeight;
    NSString *strTakeOffWeightOpsLimit;
    NSString *strTakeOffWeightStructLimit;
    NSString *strLandingWeight;
    NSString *strLandingWeightOpsLimit;
    NSString *strLandingWeightStructLimit;
    
    
    NSMutableArray *objAirport;
    NSString *strPathDocuments;
    NSString *strPathDirectory;
    NSString *strPath2Title;
    NSString *strPath3Title;
    NSString *strWptTitle;
    NSString *strWPTRegion;
    NSString *strAptRegion;
    NSString *strPathOFP;
    bool bolWPT;
    bool bolPreviewWPT;
    NSString *strAnnAirport;
    NSMutableString *strATCFltpln;
    NSString *strAlt;
    NSMutableArray *arrayEFF;
    NSInteger intRowWaypoint;
    NSMutableArray *arrayLogXML;
    
    ///// SunFlight
    
    double    dblLatitudeFROM;
    double    dblLongitudeFROM;
    double    dblLatitudeTO;
    double    dblLongitudeTO;
    
    double    dblLatitudeFROMPreFlight;
    double    dblLongitudeFROMPreFlight;
    double    dblLatitudeTOPreFlight;
    double    dblLongitudeTOPreFlight;
    
    double    dblLatitudeFROMInFlight;
    double    dblLongitudeFROMInFlight;
    double    dblLatitudeTOInFlight;
    double    dblLongitudeTOInFlight;
    
    double    dblDistanceNM;
    
    double    dblLongitudeSR;
    double    dblLatitudeSR;
    double    dblLongitudeSS;
    double    dblLatitudeSS;
    double    dblLongitudeSRInFlight;
    double    dblLatitudeSRInFlight;
    double    dblLongitudeSSInFlight;
    double    dblLatitudeSSInFlight;
    
    
    NSDate   *TimeOvhdFROMLCL;
    NSDate   *TimeOvhdTOLCL;
    NSDate   *TimeOvhdFROM;
    NSDate   *TimeOvhdTO;
    NSDate   *dateFlight;
    NSInteger IntTimeDifference;
    NSInteger IntTimeDifferenceDest;
    NSInteger IntTimeZone;
    
    
    NSDate *TimeSunriseDep;
    NSDate *TimeSunSetDep;
    NSDate *TimeSunriseDest;
    NSDate *TimeSunSetDest;
    
    NSString *txtDepAirport;
    NSString *txtDestAirport;
    NSString *txtLatFROMInFlight;
    NSString *txtLongFROMFlight;
    NSString *txtLatTOInFlight;
    NSString *txtLongTOInFlight;
    NSString *strTimeZoneName;
    NSString *strTimeDifferenceDep;
    NSString *strTimeDifferenceDest;
    
    bool bolDepAirport;
    bool bolDestAirport;
    
    bool bolSunRise;
    bool bolSunSet;
    
    bool bolSunRiseInFlight;
    bool bolSunSetInFlight;
    
    bool bolPreflight;
    bool bolInFlight;
    
    bool bolDay;
    
    bool bolCalcPossible;
    bool bolCalcDayNightTime;
    
    bool bolFajr;
    bool bolIsha;
    
    NSDate   *timeTimeTakeOffFROM;
    NSDate   *timeTimeLandTO;
    NSInteger   intFlightTime;
    NSInteger   intFlightLevel;
    NSInteger   intFlightLevelCorr;
    NSInteger   intDayFlightTime;
    NSInteger   intNightFlightTime;
    NSInteger intSunrise;
    NSInteger intFajr;
    NSInteger intIsha;
    NSInteger intSunset;
    NSInteger intSunriseDep;
    NSInteger intSunsetDep;
    NSInteger intSunriseDest;
    NSInteger intSunsetDest;
    
    NSInteger   intTimeOvhdFROM;
    NSInteger   intTimeOvhdTO;
    NSInteger   intTimeOvhdFROMLCL;
    NSInteger   intTimeOvhdTOLCL;
    
    NSString *strTimeFROM;
    NSString *strTimeTO;
    
    NSInteger   intTimeOvhdFROMPreFlight;
    NSInteger   intTimeOvhdTOPreFlight;
    
    NSInteger   intTimeOvhdFROMInFlight;
    NSInteger   intTimeOvhdTOInFlight;
    
    NSString *strSunrise;
    NSString *strSunriseInFlight;
    NSString *strSunsetInFlight;
    NSString *strFajr;
    NSString *strIsha;
    NSString *strFajrLCL;
    NSString *strIshaLCL;
    NSString *strSunset;
    NSString *strSunriseLCL;
    NSString *strSunsetLCL;
    NSString *strSunriseDEP;
    NSString *strSunsetDEP;
    NSString *strSunriseDEST;
    NSString *strSunsetDEST;
    
    NSString *strLatSunrise;
    NSString *strLongSunrise;
    
    NSString *strLatSunset;
    NSString *strLongSunset;
    
    NSString *strLatSunriseInFlight;
    NSString *strLongSunriseInFlight;
    
    NSString *strLatSunsetInFlight;
    NSString *strLongSunsetInFlight;
    
    NSString *strAirportICAO;
    NSString *strAirportIATA;
    NSString *strAirportCity;
    NSString *strAirportName;
    
    NSString *strFlightTime;
    NSString * strOFPHeader;
    NSMutableArray *arrayCoordinates;
    NSMutableArray *arrayCoordinatesInFlight;
    
    NSInteger intSection;
    
    /// Max FDP
    
    BOOL    BolPilots;
    BOOL	BolAcclimatized;
    BOOL	BolPreceedingRestless18;
    BOOL	BolSectorLess7hrs;
    NSInteger IntSegCrew;
    NSInteger IntSegBodyClock;
    NSInteger IntSegLongRange;
    NSInteger IntSectorNumbers;
    //    NSInteger IntTimeDifference;
    NSDate   *ReportTime;
    NSInteger ReliefRestTime;
    NSInteger IntInflightRestTime;
    NSInteger IntsegPilots;
    NSInteger IntsegBlockhours;
    NSInteger IntsegRestTakenIn;
    BOOL	BolswcInFlightRelief;
    BOOL	BolsegBunk;
    BOOL	BolsegSeat;
    NSInteger IntTimeRest;
    NSInteger IntSplitDuty;
    NSInteger IntSplitDutyPicker;
    BOOL	BolswcStandby;
    BOOL	BolswcSBYRest;
    BOOL	BolswcSplitDuty;
    NSDate	*SBYBegin;
    NSDate	*OriginalReportTime;
    NSDate	*OriginalStandbyTime;
    NSDate	*OriginalActualReportTime;
    NSDate	*LimitingReportTime;
    NSDate	*FDPStartTime;
    NSInteger IntMaxFDPCorrectionSBY;
    NSDate  *DelayActReport;
    NSInteger IntsegDelayHours;
    BOOL	BolswcDelay;
    BOOL	BolDelayMore4;
    NSInteger	IntTableAacclimatised;
    NSInteger	IntTableBnonAcclimatised;
    NSInteger	IntMaxFDP;
    NSInteger	IntMaxFDPHours;
    NSInteger	IntMaxFDPMinutes;
    NSInteger	IntMaxFDPENDHours;
    NSInteger	IntMaxFDPENDMinutes;
    NSInteger	IntSTARTFDPHours;
    NSInteger	IntSTARTFDPMinutes;
    NSString *txtTimeBand;
    NSString *txtStartFDP;
    NSString *txtMaxFDP;
    NSString *txtCorrections;
    NSString *txtCorrectionDiscr;
    NSString *txtNewCorrFDP;
    NSString *txtReducedDiscr;
    NSString *txtEndTimeLCL;
    NSString *txtEndTimeUTC;
    BOOL BolSectorSelected;
    
    // FuelUplift
    
    NSInteger intVolume;
    double intDensity;
    NSInteger intWeight;
    double intFactVolume;
    double intFactWeight;
    bool bolMultipleReceipts;
    NSString *strVolumetxt;
    NSString *strWeighttxt;
    NSString *specificSG;
    NSString *strDensity;
    NSString *strDensityDecimal;
    NSString *strlblDensity;
    
}
@property (nonatomic, strong) NSMutableArray *arrayAllCompanyAirports;



// Sunrise-Sunset
@property (nonatomic)BOOL bolCalcSSSR;
//MapPointFocus
@property (nonatomic, strong)NSString *strSelectedWaypoint;

@property (nonatomic, strong)NSString *strFlightStatus;
@property (nonatomic, strong)NSString *strMapCenter;
@property (nonatomic)double    dblLatitudeMapCenter;
@property (nonatomic)double    dblLongitudeMapCenter;
@property (nonatomic)BOOL bolCenterMap;
@property (nonatomic)double    dblLongitudePPos;
@property (nonatomic)double    dblLatitudePPos;

// Header RouteInformation

@property (nonatomic, strong)NSString *strPerformanceFactor;
@property (nonatomic, strong)NSString *strAverageFF;
@property (nonatomic, strong)NSString *strRouteName;
@property (nonatomic, strong)NSString *strOptimization;
@property (nonatomic, strong)NSString *strAverageWindDirection;
@property (nonatomic, strong)NSString *strAverageWindSpeed;
@property (nonatomic, strong)NSString *strAverageWindComponent;
@property (nonatomic, strong)NSString *strAverageTemperature;
@property (nonatomic, strong)NSString *strAverageISADeviation;
@property (nonatomic, strong)NSString *strInitialAltitude;
@property (nonatomic, strong)NSString *strClimbMach;
@property (nonatomic, strong)NSString *strClimbSpeed;
@property (nonatomic, strong)NSString *strCruiseCI;
@property (nonatomic, strong)NSString *strDescendMach;
@property (nonatomic, strong)NSString *strDescendSpeed;
@property (nonatomic, strong)NSString *strRouteDescription;
@property (nonatomic, strong)NSString *strGroundDistance;
@property (nonatomic, strong)NSString *strAirDistance;
@property (nonatomic, strong)NSString *strGreatCircleDistance;


// FuelHeader

@property (nonatomic, strong)NSString *strTripFuel;
@property (nonatomic, strong)NSString *strContingencyFuel;
@property (nonatomic, strong)NSString *strContingencyPolicy;
@property (nonatomic, strong)NSString *strContingencyEnrouteAlternate;
@property (nonatomic, strong)NSString *strAlternateDuration;
@property (nonatomic, strong)NSString *strAlternateFuel;
@property (nonatomic, strong)NSString *strAlternateAirport;
@property (nonatomic, strong)NSMutableArray *arrDestinationAlternates;
@property (nonatomic, strong)NSString *strFinalReserveFuel;
@property (nonatomic, strong)NSString *strFinalReserveDuration;
@property (nonatomic, strong)NSString *strETOPSFuel;
@property (nonatomic, strong)NSString *strETOPSDuration;
@property (nonatomic, strong)NSString *strPosExtraFuel;
@property (nonatomic, strong)NSString *strMaxFuelWeight;
@property (nonatomic, strong)NSString *strTakeOffEstimatedFuel;
@property (nonatomic, strong)NSString *strTakeOffEstimatedDuration;
@property (nonatomic, strong)NSString *strTaxiFuel;
@property (nonatomic, strong)NSString *strTaxiDuration;
@property (nonatomic, strong)NSString *strBlockFuel;
@property (nonatomic, strong)NSString *strBlockDuration;
@property (nonatomic, strong)NSString *strArrivalFuel;
@property (nonatomic, strong)NSString *strArrivalDuration;
@property (nonatomic, strong)NSMutableArray *arrFuelAdjustments;

// WEIGHTS

@property (nonatomic, strong)NSString *strDryOperatingWeight;
@property (nonatomic, strong)NSString *strLoadWeight;
@property (nonatomic, strong)NSString *strZeroFuelWeight;
@property (nonatomic, strong)NSString *strZeroFuelWeightLimit;
@property (nonatomic, strong)NSString *strTakeOffWeight;
@property (nonatomic, strong)NSString *strTakeOffWeightOpsLimit;
@property (nonatomic, strong)NSString *strTakeOffWeightStructLimit;
@property (nonatomic, strong)NSString *strLandingWeight;
@property (nonatomic, strong)NSString *strLandingWeightOpsLimit;
@property (nonatomic, strong)NSString *strLandingWeightStructLimit;


//
@property (nonatomic, strong) NSString *strETADestination;
@property (nonatomic, strong) NSString *strETASchedDestination;
@property (nonatomic, strong) NSString *strOFPNumber;
@property (nonatomic, strong) NSMutableArray *arrayAirportDataList;

@property (nonatomic, strong) NSMutableArray *arrayBriefingAirport;
@property (nonatomic, strong) NSMutableArray *arrayEscapeRoutes;
@property (nonatomic, strong) NSMutableArray *arrayEnRouteWaypoints;
@property (nonatomic, strong) NSMutableArray *arrayLog;
@property (nonatomic, strong) NSMutableArray *arrayLogXML;
@property (nonatomic, strong) NSMutableArray *arrayWXAirports;

@property (nonatomic, strong) NSMutableArray *arrayEFF;
@property (nonatomic, strong) NSMutableArray *arrayLogDestinationAlternates;
@property (nonatomic, strong) NSMutableArray *arrayAllAirports;
@property (nonatomic, strong) NSMutableString *strATCFltpln;
@property (nonatomic, strong) NSString *strAlt;

@property (nonatomic, strong) NSMutableSet *lookup;
@property (nonatomic, strong) NSMutableSet *lookupAirport;

@property (nonatomic, strong) NSString *strTripDuration;
//@property (nonatomic, strong) NSString *strInitialAltitude;


@property (nonatomic, strong) NSArray *arrayEscapeWpts;
@property (nonatomic, strong) NSMutableArray *arrayEnrouteAirports;
@property (nonatomic, strong) NSString *strDirection;
@property (nonatomic, strong) NSString *strAircraft;
@property (nonatomic, strong) NSString *strAircraftRegistration;
@property (nonatomic, strong) NSString *strFlightIdentifier;
@property (nonatomic, strong) NSString *strDirectionLog;
@property (nonatomic, strong) NSString *strAircraftLog;
@property (nonatomic, strong) NSString *strEntityName;
@property (nonatomic, strong) NSString *strEntityAirports;
@property (nonatomic, strong) NSMutableArray *arrAirport;
@property (nonatomic, strong) NSString *strAircraftType;
@property (nonatomic, strong) NSMutableArray *arrayAlternates;
@property (nonatomic, strong) NSMutableArray *arrayAirportAlternates;

@property (nonatomic, strong) NSMutableArray *arrayWXNotams;
@property (nonatomic, strong) NSString *strPathDocuments;
@property (nonatomic, strong) NSString *strPathDirectory;
@property (nonatomic, strong) NSString *strPath2Title;
@property (nonatomic, strong) NSString *strPath3Title;
@property (nonatomic, strong) NSString *strWptTitle;
@property (nonatomic, strong) NSString *strWptRegion;
@property (nonatomic, strong) NSString *strAptRegion;
@property (nonatomic, strong) NSString *strPathOFP;
@property (nonatomic, strong) NSString *strDeparture;
@property (nonatomic, strong) NSString *strDestination;
@property (nonatomic, strong) NSString *strFlightPlanEquipment;
@property (nonatomic, strong) NSString *strAnnAirport;
@property (nonatomic, strong) NSString *strTakeOffTime;
@property (nonatomic, strong) NSString *strOffBlockTime;
@property (nonatomic, strong) NSString *strLandingTime;
@property (nonatomic, strong) NSString *strOFPHeader;
@property (nonatomic, strong) NSString *strFltplanTitle;
@property (nonatomic) bool bolWPT;
@property (nonatomic) bool bolPreviewWPT;
@property (nonatomic) bool bolInFlightPos;

@property (nonatomic) NSInteger intRowWaypoint;


//// SunFlight

@property (nonatomic) double dblLatitudeFROM;
@property (nonatomic) double dblLongitudeFROM;
@property (nonatomic) double dblLatitudeTO;
@property (nonatomic) double dblLongitudeTO;

@property (nonatomic) double dblLatitudeFROMPreFlight;
@property (nonatomic) double dblLongitudeFROMPreFlight;
@property (nonatomic) double dblLatitudeTOPreFlight;
@property (nonatomic) double dblLongitudeTOPreFlight;

@property (nonatomic) double dblLatitudeFROMInFlight;
@property (nonatomic) double dblLongitudeFROMInFlight;
@property (nonatomic) double dblLatitudeTOInFlight;
@property (nonatomic) double dblLongitudeTOInFlight;

@property (nonatomic) double dblDistanceNM;

@property (nonatomic) double dblLongitudeSR;
@property (nonatomic) double dblLatitudeSR;
@property (nonatomic) double dblLongitudeSS;
@property (nonatomic) double dblLatitudeSS;
@property (nonatomic) double dblLongitudeSRInFlight;
@property (nonatomic) double dblLatitudeSRInFlight;
@property (nonatomic) double dblLongitudeSSInFlight;
@property (nonatomic) double dblLatitudeSSInFlight;

@property (nonatomic) double dblLongitudeSR2;
@property (nonatomic) double dblLatitudeSR2;
@property (nonatomic) double dblLongitudeSS2;
@property (nonatomic) double dblLatitudeSS2;
@property (nonatomic) double dblLongitudeSRInFlight2;
@property (nonatomic) double dblLatitudeSRInFlight2;
@property (nonatomic) double dblLongitudeSSInFlight2;
@property (nonatomic) double dblLatitudeSSInFlight2;

@property (nonatomic, strong) NSDate *TimeOvhdFROMLCL;
@property (nonatomic, strong) NSDate *TimeOvhdTOLCL;
@property (nonatomic, strong) NSDate *TimeOvhdFROM;
@property (nonatomic, strong) NSDate *TimeOvhdTO;

@property (nonatomic, strong) NSDate *TimeSunriseDep;
@property (nonatomic, strong) NSDate *TimeSunsetDep;
@property (nonatomic, strong) NSDate *TimeSunriseDest;
@property (nonatomic, strong) NSDate *TimeSunsetDest;

@property (nonatomic, strong) NSDate *dateFlight;
@property (nonatomic, strong) NSString *strFlightTransfer;
@property (nonatomic) NSInteger IntTimeDifference;
@property (nonatomic) NSInteger IntTimeDifferenceDest;
@property (nonatomic) NSInteger IntTimeZone;


@property (nonatomic, strong) NSString *txtDepAirport;
@property (nonatomic, strong) NSString *txtDestAirport;
@property (nonatomic, strong) NSString *strTimeFROM;
@property (nonatomic, strong) NSString *strTimeTO;
@property (nonatomic, strong) NSString *txtLatFROMInFlight;
@property (nonatomic, strong) NSString *txtLongFROMInFlight;
@property (nonatomic, strong) NSString *txtLatTOInFlight;
@property (nonatomic, strong) NSString *txtLongTOInFlight;
@property (nonatomic, strong) NSString *strTimeZoneName;
@property (nonatomic, strong) NSString *strTimeDifferenceDep;
@property (nonatomic, strong) NSString *strTimeDifferenceDest;
@property (nonatomic, strong) NSString *strFlightTime;



@property (nonatomic) bool bolDepAirport;
@property (nonatomic) bool bolDestAirport;
@property (nonatomic) bool bolSunRise;
@property (nonatomic) bool bolSunSet;
@property (nonatomic) bool bolSunRise2;
@property (nonatomic) bool bolSunSet2;
@property (nonatomic) bool bolSunRiseInFlight;
@property (nonatomic) bool bolSunSetInFlight;
@property (nonatomic) bool bolSunRiseInFlight2;
@property (nonatomic) bool bolSunSetInFlight2;
@property (nonatomic) bool bolPreFlight;
@property (nonatomic) bool bolInFlight;
@property (nonatomic) bool bolDay;
@property (nonatomic) bool bolCalcPossible;
@property (nonatomic) bool bolCalcDayNightTime;
@property (nonatomic) bool bolFajr;
@property (nonatomic) bool bolIsha;
@property (nonatomic) bool bolFajr2;
@property (nonatomic) bool bolIsha2;


@property (nonatomic, strong) NSDate *timeTimeTakeOffFROM;
@property (nonatomic, strong) NSDate *timeTimeLandTO;
@property (nonatomic) NSInteger intFlightTime;
@property (nonatomic) NSInteger intFlightLevel;
@property (nonatomic) NSInteger intFlightLevelCorr;
@property (nonatomic) NSInteger intDayFlightTime;
@property (nonatomic) NSInteger intNightFlightTime;
@property (nonatomic) NSInteger intSunrise;
@property (nonatomic) NSInteger intFajr;
@property (nonatomic) NSInteger intIsha;
@property (nonatomic) NSInteger intSunset;
@property (nonatomic) NSInteger intSunriseDep;
@property (nonatomic) NSInteger intSunsetDep;
@property (nonatomic) NSInteger intSunriseDest;
@property (nonatomic) NSInteger intSunsetDest;



@property (nonatomic) NSInteger intTimeOvhdFROM;
@property (nonatomic) NSInteger intTimeOvhdTO;
@property (nonatomic) NSInteger intTimeOvhdFROMLCL;
@property (nonatomic) NSInteger intTimeOvhdTOLCL;

@property (nonatomic) NSInteger intTimeOvhdFROMPreFlight;
@property (nonatomic) NSInteger intTimeOvhdTOPreFlight;

@property (nonatomic) NSInteger intTimeOvhdFROMInFlight;
@property (nonatomic) NSInteger intTimeOvhdTOInFlight;

@property (nonatomic) NSInteger intSection;

@property (nonatomic, strong) NSString *strSunrise;
@property (nonatomic, strong) NSString *strSunriseInFlight;
@property (nonatomic, strong) NSString *strSunsetInFlight;
@property (nonatomic, strong) NSString *strFajr;
@property (nonatomic, strong) NSString *strIsha;
@property (nonatomic, strong) NSString *strFajrLCL;
@property (nonatomic, strong) NSString *strIshaLCL;
@property (nonatomic, strong) NSString *strSunset;
@property (nonatomic, strong) NSString *strSunrise2;
@property (nonatomic, strong) NSString *strSunriseInFlight2;
@property (nonatomic, strong) NSString *strSunsetInFlight2;
@property (nonatomic, strong) NSString *strFajr2;
@property (nonatomic, strong) NSString *strIsha2;
@property (nonatomic, strong) NSString *strFajrLCL2;
@property (nonatomic, strong) NSString *strIshaLCL2;
@property (nonatomic, strong) NSString *strSunset2;


@property (nonatomic, strong) NSString *strSunriseLCL;
@property (nonatomic, strong) NSString *strSunsetLCL;
@property (nonatomic, strong) NSString *strSunriseLCLinFlight;
@property (nonatomic, strong) NSString *strSunsetLCLinFlight;
@property (nonatomic, strong) NSString *strSunriseLCL2;
@property (nonatomic, strong) NSString *strSunsetLCL2;
@property (nonatomic, strong) NSString *strSunriseLCLinFlight2;
@property (nonatomic, strong) NSString *strSunsetLCLinFlight2;
@property (nonatomic, strong) NSString *strSunriseDEP;
@property (nonatomic, strong) NSString *strSunsetDEP;
@property (nonatomic, strong) NSString *strSunriseDEST;
@property (nonatomic, strong) NSString *strSunsetDEST;


@property (nonatomic, strong) NSString *strLatSunrise;
@property (nonatomic, strong) NSString *strLongSunrise;

@property (nonatomic, strong) NSString *strLatSunset;
@property (nonatomic, strong) NSString *strLongSunset;

@property (nonatomic, strong) NSString *strLatSunrise2;
@property (nonatomic, strong) NSString *strLongSunrise2;

@property (nonatomic, strong) NSString *strLatSunset2;
@property (nonatomic, strong) NSString *strLongSunset2;

@property (nonatomic, strong) NSString *strLatSunriseInFlight;
@property (nonatomic, strong) NSString *strLongSunriseInFlight;

@property (nonatomic, strong) NSString *strLatSunsetInFlight;
@property (nonatomic, strong) NSString *strLongSunsetInFlight;

@property (nonatomic, strong) NSString *strLatSunriseInFlight2;
@property (nonatomic, strong) NSString *strLongSunriseInFlight2;

@property (nonatomic, strong) NSString *strLatSunsetInFlight2;
@property (nonatomic, strong) NSString *strLongSunsetInFlight2;

@property (nonatomic, strong) NSString *strAirportICAO;
@property (nonatomic, strong) NSString *strAirportIATA;

@property (nonatomic, strong) NSString *strAirportCity;
@property (nonatomic, strong) NSString *strAirportName;

@property (nonatomic, strong) NSMutableArray *arrayCoordinates;
@property (nonatomic, strong) NSMutableArray *arrayCoordinatesInFlight;
@property (nonatomic, strong) NSMutableArray *arrayResults;

@property (nonatomic, strong) NSString *strFlightPlanTitle;

/// MaxFDP

@property (nonatomic) BOOL BolSectorSelected;
@property (nonatomic) BOOL BolPilots;
@property (nonatomic) BOOL BolAcclimatized;
@property (nonatomic) BOOL BolPreceedingRestless18;
@property (nonatomic) BOOL BolSectorLess7hrs;
@property (nonatomic) NSInteger IntSegCrew;
@property (nonatomic) NSInteger IntSegBodyClock;
@property (nonatomic) NSInteger IntSegLongRange;
@property (nonatomic) NSInteger IntSectorNumbers;
//@property (nonatomic) NSInteger IntTimeDifference;
@property (nonatomic, retain) NSDate *ReportTime;
@property (nonatomic) NSInteger ReliefRestTime;
@property (nonatomic) NSInteger IntInflightRestTime;
@property (nonatomic) NSInteger IntsegPilots;
@property (nonatomic) NSInteger IntsegBlockhours;
@property (nonatomic) NSInteger IntsegRestTakenIn;
@property (nonatomic) BOOL BolswcInFlightRelief;
@property (nonatomic) BOOL BolswcStandby;
@property (nonatomic) BOOL BolswcSBYRest;
@property (nonatomic) BOOL BolswcSplitDuty;
@property (nonatomic) BOOL BolsegBunk;
@property (nonatomic) BOOL BolsegSeat;
@property (nonatomic) NSInteger IntTimeRest;
@property (nonatomic) NSInteger IntSplitDuty;
@property (nonatomic, retain) NSDate *SBYBegin;
@property (nonatomic, retain) NSDate *OriginalReportTime;
@property (nonatomic, retain) NSDate *OriginalStandbyTime;
@property (nonatomic, retain) NSDate *OriginalActualReportTime;
@property (nonatomic, retain) NSDate *LimitingReportTime;
@property (nonatomic, retain) NSDate *FDPStartTime;
@property (nonatomic) NSInteger IntMaxFDPCorrectionSBY;
@property (nonatomic, retain) NSDate *DelayActReport;
@property (nonatomic) NSInteger IntsegDelayHours;
@property (nonatomic) BOOL BolswcDelay;
@property (nonatomic) BOOL BolDelayMore4;
@property (nonatomic) NSInteger IntTableAacclimatised;
@property (nonatomic) NSInteger IntTableBnonAcclimatised;
@property (nonatomic) NSInteger IntMaxFDP;
@property (nonatomic) NSInteger IntMaxFDPHours;
@property (nonatomic) NSInteger IntMaxFDPMinutes;
@property (nonatomic) NSInteger IntMaxFDPENDHours;
@property (nonatomic) NSInteger IntMaxFDPENDMinutes;
@property (nonatomic) NSInteger IntSTARTFDPHours;
@property (nonatomic) NSInteger IntSTARTFDPMinutes;
@property (nonatomic, retain) NSString *txtTimeBand;
@property (nonatomic, retain) NSString *txtStartFDP;
@property (nonatomic, retain) NSString *txtMaxFDP;
@property (nonatomic, retain) NSString *txtNewCorrFDP;
@property (nonatomic, retain) NSString *txtReducedDiscr;
@property (nonatomic, retain) NSString *txtCorrections;
@property (nonatomic, retain) NSString *txtCorrectionDiscr;
@property (nonatomic, retain) NSString *txtEndTimeLCL;
@property (nonatomic, retain) NSString *txtEndTimeUTC;
@property (nonatomic) NSInteger IntSplitDutyPicker;

// FuelUplift

@property (nonatomic) NSInteger intVolume;
@property (nonatomic) double intDensity;
@property (nonatomic) NSInteger intWeight;
@property (nonatomic) double intFactVolume;
@property (nonatomic) double intFactWeight;
@property (nonatomic) bool bolMultipleReceipts;
@property (nonatomic) NSString *strVolumetxt;
@property (nonatomic) NSString *strWeighttxt;
@property (nonatomic) NSString *specificSG;
@property (nonatomic) NSString *strDensity;
@property (nonatomic) NSString *strDensityDecimal;
@property (nonatomic) NSString *strlblDensity;

+ (User *)sharedUser;

// Electronic Flight Folder
//@property (nonatomic, strong) EFF *eff;

@end
