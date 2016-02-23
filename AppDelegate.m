//
//  AppDelegate.m
//  RIM
//
//  Created by Mikel on 25.03.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "AppDelegate.h"
#import "UYLCountryTableViewController.h"
#import "UYLCountryViewController.h"
#import "Country+Extensions.h"
//#import "Escape+Extensions.h"
//#import "EscapeNarrowInboundIran+Extensions.h"
#import "User.h"
#import "SDSyncEngine.h"
#import "SDCoreDataController.h"
#import "Country.h"
#import "Escape.h"
#import "Airports.h"
#import "EscapeWideInboundEurope.h"
#import "EscapeWideInboundMiddleEast.h"
#import "EscapeWideInboundIran.h"
#import "EscapeWideOutboundEurope.h"
#import "EscapeWideOutboundMiddleEast.h"
#import "EscapeWideOutboundIran.h"
#import "EscapeNarrowInbound.h"
#import "EscapeNarrowOutbound.h"
#import "EscapeWideInboundAfricaUSA.h"
#import "EscapeWideOutboundAfricaUSA.h"
#import "EscapeWideInboundSEAsia.h"
#import "EscapeWideOutboundSEAsia.h"
#import "EscapeWideInboundChina.h"
#import "EscapeWideOutboundChina.h"
#import "EscapeNarrowInboundEurope.h"
#import "EscapeNarrowInboundMiddleEast.h"
#import "EscapeNarrowInboundIran.h"
#import "EscapeNarrowOutboundEurope.h"
#import "EscapeNarrowOutboundMiddleEast.h"
#import "EscapeNarrowOutboundIran.h"
#import "EscapeNarrowInboundAfricaUSA.h"
#import "EscapeNarrowOutboundAfricaUSA.h"
#import "EscapeNarrowInboundChina.h"
#import "EscapeNarrowOutboundChina.h"
#import "AirportsAfrica.h"
#import "AirportsAmericas.h"
#import "AirportsEurasia.h"
#import "AirportsEurope.h"
#import "AirportsMiddleEast.h"
#import "AirportsAustralia.h"
#import "AirportsAsia.h"
#import "AirportsImported.h"
#import <SVProgressHUD.h>


@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark -
#pragma mark === UIApplicationDelegate Methods ===
#pragma mark -



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
// Set SVProgressHUD defaults
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];

/// Max FDP
    
    [User sharedUser].IntInflightRestTime = 0;
    [User sharedUser].IntSplitDuty = 0;
    [User sharedUser].IntMaxFDPCorrectionSBY = 0;
    [User sharedUser].BolswcStandby = NO;
    [User sharedUser].BolswcSBYRest = NO;
    [User sharedUser].BolswcSplitDuty = NO;
    [User sharedUser].BolswcDelay = NO;
    [User sharedUser].BolPilots = YES;
// SunriseSunset
    
    [User sharedUser].bolCalcSSSR =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"ReadSunrise"] boolValue];
    
    /// RIM
    
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[AirportsImported class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[Airports class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[AirportsAfrica class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[AirportsAsia class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[AirportsAustralia class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[AirportsEurasia class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[AirportsEurope class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[AirportsAmericas class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[AirportsMiddleEast class]];

    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[Escape class]];
    
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeWideInboundEurope class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeWideInboundIran class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeWideInboundMiddleEast class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeWideInboundSEAsia class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeWideInboundAfricaUSA class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeWideInboundChina class]];

    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeWideOutboundMiddleEast class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeWideOutboundEurope class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeWideOutboundIran class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeWideOutboundSEAsia class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeWideOutboundAfricaUSA class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeWideOutboundChina class]];


    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeNarrowInbound class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeNarrowOutbound class]];
    
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeNarrowInboundEurope class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeNarrowInboundIran class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeNarrowInboundMiddleEast class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeNarrowInboundAfricaUSA class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeNarrowInboundChina class]];
    
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeNarrowOutboundMiddleEast class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeNarrowOutboundEurope class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeNarrowOutboundIran class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeNarrowOutboundAfricaUSA class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EscapeNarrowOutboundChina class]];
    
    [User sharedUser].arrayEscapeRoutes = [[NSMutableArray alloc] init];
    [User sharedUser].arrayEnrouteAirports = [[NSMutableArray alloc] init];
    [User sharedUser].arrayEscapeWpts = [[NSArray alloc] init];
    [User sharedUser].lookup = [[NSMutableSet alloc] init];
    [User sharedUser].lookupAirport = [[NSMutableSet alloc] init];
    [User sharedUser].arrayEnRouteWaypoints = [[NSMutableArray alloc] init];
    [User sharedUser].arrayLog = [[NSMutableArray alloc] init];
    [User sharedUser].arrayAllAirports = [[NSMutableArray alloc] init];
    [User sharedUser].arrayWXNotams = [[NSMutableArray alloc] init];

    NSArray *arrAirports;
    arrAirports = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"airports" ofType:@"plist"]];
    [User sharedUser].arrayAllAirports = [(NSArray*)arrAirports mutableCopy];
    
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.93 green:0.80 blue:0.80 alpha:1.0];
    shadow.shadowOffset = CGSizeMake(0, 0);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1] /*#007aff*/, NSForegroundColorAttributeName, shadow,
                                                           NSShadowAttributeName,
                                                           [UIFont systemFontOfSize:25.0], NSFontAttributeName, nil]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1]]; /*#c99e2d*/
    UIImage* tabBarBackground = [UIImage imageNamed:@"TabbarIMGgray.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [[UINavigationBar appearance] setBackgroundImage:tabBarBackground forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1]]; /*#007aff*/
//    [[UINavigationBar appearance] setBounds :CGRectMake(0, 0, 320, 70)];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:0.788 green:0.62 blue:0.176 alpha:1]]; /*#007aff*/
    [[UISearchBar appearance] setBackgroundImage:tabBarBackground];
//    [[UITableViewCell appearance] setBackgroundColor:[UIColor colorWithRed:0.333 green:0.333 blue:0.333 alpha:0.4]];
//    [[UITableView appearance] setBackgroundColor:[UIColor darkGrayColor]];
//    [[UITableView appearance] setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Etihad.JPG"]] ];

    [User sharedUser].strAircraftType = @"All";

    return YES;
}
-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation {
    if (url != nil && [url isFileURL]) {
//        [self.viewController handleDocumentOpenURL:url];
    }
    return YES;
}
//- (void)handleDocumentOpenURL:(NSURL *)url {
//    [self displayAlert:[url absoluteString]];
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//    [webView setUserInteractionEnabled:YES];
//    [webView loadRequest:requestObj];
//}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[SDSyncEngine sharedEngine] startSync];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark === Core Data Accessors ===
#pragma mark -

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Airports" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationSupportDirectory] URLByAppendingPathComponent:@"Airports.sqlite"];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
//        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Airports" ofType:@"sqlite"]];
////        NSString* dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Airports.sqlite"];
////        NSURL *preloadURL = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Airports.sqlite"];
//        NSError* err = nil;
//        
//        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err]) {
//            NSLog(@"Oops, could copy preloaded data");
//        }
//    }

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:nil
                                                           error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark -
#pragma mark === Utility Methods ===
#pragma mark -

- (NSURL *)applicationSupportDirectory
{
    NSError *error = nil;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *appSupportDir = [fileManager URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    return appSupportDir;
}


@end
