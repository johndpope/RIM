//
//  EscapeWPTViewController.h
//  RIM
//
//  Created by Mikel on 27.03.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

@import UIKit;
#import "Escape.h"
#import "EscapeWideInboundEurope.h"
#import "EscapeWideInboundMiddleEast.h"
#import "EscapeWideInboundIran.h"
#import "EscapeWideOutboundEurope.h"
#import "EscapeWideOutboundMiddleEast.h"
#import "EscapeWideOutboundIran.h"
#import "EscapeNarrowInbound.h"
#import "EscapeNarrowOutbound.h"

@interface EscapeWPTDetailViewController : UIViewController

@property (nonatomic, strong) Escape *escapewpt;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *segFunction;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
//- (IBAction)addWaypointToArray:(id)sender;
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@end