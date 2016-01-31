//
//	ReaderViewController.m
//	Reader v2.8.6
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2015 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ReaderConstants.h"
#import "ReaderViewController.h"
#import "ThumbsViewController.h"
#import "ReaderMainToolbar.h"
#import "ReaderMainPagebar.h"
#import "ReaderContentView.h"
#import "ReaderThumbCache.h"
#import "ReaderThumbQueue.h"

#import "User.h"
#import "Escape.h"
#import "Airports.h"
#import "Airport.h"

#import "SDCoreDataController.h"
#import "AirportAlternatesTableViewController.h"
#import <MessageUI/MessageUI.h>

@interface ReaderViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate,
                                    ReaderMainPagebarDelegate, ReaderContentViewDelegate, ThumbsViewControllerDelegate>
{
}
@end

@implementation ReaderViewController
{
	ReaderDocument *document;

	UIScrollView *theScrollView;

	ReaderMainToolbar *mainToolbar;

	ReaderMainPagebar *mainPagebar;

	NSMutableDictionary *contentViews;

	UIUserInterfaceIdiom userInterfaceIdiom;

	NSInteger currentPage, minimumPage, maximumPage;

	UIDocumentInteractionController *documentInteraction;

	UIPrintInteractionController *printInteraction;

	CGFloat scrollViewOutset;

	CGSize lastAppearSize;

	NSDate *lastHideTime;

	BOOL ignoreDidScroll;
}

#pragma mark - Constants

#define BUTTON_X 8.0f
#define BUTTON_Y 8.0f

#define BUTTON_SPACE 8.0f
#define BUTTON_HEIGHT 30.0f

#define BUTTON_FONT_SIZE 15.0f
#define TEXT_BUTTON_PADDING 24.0f

#define ICON_BUTTON_WIDTH 40.0f

#define TITLE_FONT_SIZE 19.0f
#define TITLE_HEIGHT 28.0f

#define STATUS_HEIGHT 20.0f

#define TOOLBAR_HEIGHT 44.0f
#define PAGEBAR_HEIGHT 48.0f

#define SCROLLVIEW_OUTSET_SMALL 4.0f
#define SCROLLVIEW_OUTSET_LARGE 8.0f

#define TAP_AREA_SIZE 48.0f

#pragma mark - Properties

@synthesize delegate,btnAirports;

#pragma mark - ReaderViewController methods

- (void)setEscape:(Escape *)newEscape
{
    if (_escape != newEscape)
    {
        _escape = newEscape;
        
    }
}
- (void)setAirport:(Airports *)newAirport
{
    if (_airport != newAirport)
    {
        _airport = newAirport;
        
    }
}

- (void)updateContentSize:(UIScrollView *)scrollView
{
	CGFloat contentHeight = scrollView.bounds.size.height; // Height

	CGFloat contentWidth = (scrollView.bounds.size.width * maximumPage);

	scrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
}

- (void)updateContentViews:(UIScrollView *)scrollView
{
	[self updateContentSize:scrollView]; // Update content size first

	[contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
		^(NSNumber *key, ReaderContentView *contentView, BOOL *stop)
		{
			NSInteger page = [key integerValue]; // Page number value

			CGRect viewRect = CGRectZero; viewRect.size = scrollView.bounds.size;

			viewRect.origin.x = (viewRect.size.width * (page - 1)); // Update X

			contentView.frame = CGRectInset(viewRect, scrollViewOutset, 0.0f);
		}
	];

	NSInteger page = currentPage; // Update scroll view offset to current page

	CGPoint contentOffset = CGPointMake((scrollView.bounds.size.width * (page - 1)), 0.0f);

	if (CGPointEqualToPoint(scrollView.contentOffset, contentOffset) == false) // Update
	{
		scrollView.contentOffset = contentOffset; // Update content offset
	}

	[mainToolbar setBookmarkState:[document.bookmarks containsIndex:page]];

	[mainPagebar updatePagebar]; // Update page bar
}

- (void)addContentView:(UIScrollView *)scrollView page:(NSInteger)page
{
	CGRect viewRect = CGRectZero; viewRect.size = scrollView.bounds.size;

	viewRect.origin.x = (viewRect.size.width * (page - 1)); viewRect = CGRectInset(viewRect, scrollViewOutset, 0.0f);

	NSURL *fileURL = document.fileURL; NSString *phrase = document.password; NSString *guid = document.guid; // Document properties

	ReaderContentView *contentView = [[ReaderContentView alloc] initWithFrame:viewRect fileURL:fileURL page:page password:phrase]; // ReaderContentView

	contentView.message = self; [contentViews setObject:contentView forKey:[NSNumber numberWithInteger:page]]; [scrollView addSubview:contentView];

	[contentView showPageThumb:fileURL page:page password:phrase guid:guid]; // Request page preview thumb
}

- (void)layoutContentViews:(UIScrollView *)scrollView
{
	CGFloat viewWidth = scrollView.bounds.size.width; // View width

	CGFloat contentOffsetX = scrollView.contentOffset.x; // Content offset X

	NSInteger pageB = ((contentOffsetX + viewWidth - 1.0f) / viewWidth); // Pages

	NSInteger pageA = (contentOffsetX / viewWidth); pageB += 2; // Add extra pages

	if (pageA < minimumPage) pageA = minimumPage; if (pageB > maximumPage) pageB = maximumPage;

	NSRange pageRange = NSMakeRange(pageA, (pageB - pageA + 1)); // Make page range (A to B)

	NSMutableIndexSet *pageSet = [NSMutableIndexSet indexSetWithIndexesInRange:pageRange];

	for (NSNumber *key in [contentViews allKeys]) // Enumerate content views
	{
		NSInteger page = [key integerValue]; // Page number value

		if ([pageSet containsIndex:page] == NO) // Remove content view
		{
			ReaderContentView *contentView = [contentViews objectForKey:key];

			[contentView removeFromSuperview]; [contentViews removeObjectForKey:key];
		}
		else // Visible content view - so remove it from page set
		{
			[pageSet removeIndex:page];
		}
	}

	NSInteger pages = pageSet.count;

	if (pages > 0) // We have pages to add
	{
		NSEnumerationOptions options = 0; // Default

		if (pages == 2) // Handle case of only two content views
		{
			if ((maximumPage > 2) && ([pageSet lastIndex] == maximumPage)) options = NSEnumerationReverse;
		}
		else if (pages == 3) // Handle three content views - show the middle one first
		{
			NSMutableIndexSet *workSet = [pageSet mutableCopy]; options = NSEnumerationReverse;

			[workSet removeIndex:[pageSet firstIndex]]; [workSet removeIndex:[pageSet lastIndex]];

			NSInteger page = [workSet firstIndex]; [pageSet removeIndex:page];

			[self addContentView:scrollView page:page];
		}

		[pageSet enumerateIndexesWithOptions:options usingBlock: // Enumerate page set
			^(NSUInteger page, BOOL *stop)
			{
				[self addContentView:scrollView page:page];
			}
		];
	}
}

- (void)handleScrollViewDidEnd:(UIScrollView *)scrollView
{
	CGFloat viewWidth = scrollView.bounds.size.width; // Scroll view width

	CGFloat contentOffsetX = scrollView.contentOffset.x; // Content offset X

	NSInteger page = (contentOffsetX / viewWidth); page++; // Page number

	if (page != currentPage) // Only if on different page
	{
		currentPage = page; document.pageNumber = [NSNumber numberWithInteger:page];

		[contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
			^(NSNumber *key, ReaderContentView *contentView, BOOL *stop)
			{
				if ([key integerValue] != page) [contentView zoomResetAnimated:NO];
			}
		];

		[mainToolbar setBookmarkState:[document.bookmarks containsIndex:page]];

		[mainPagebar updatePagebar]; // Update page bar
	}
}

- (void)showDocumentPage:(NSInteger)page
{
	if (page != currentPage) // Only if on different page
	{
		if ((page < minimumPage) || (page > maximumPage)) return;

		currentPage = page; document.pageNumber = [NSNumber numberWithInteger:page];

		CGPoint contentOffset = CGPointMake((theScrollView.bounds.size.width * (page - 1)), 0.0f);

		if (CGPointEqualToPoint(theScrollView.contentOffset, contentOffset) == true)
			[self layoutContentViews:theScrollView];
		else
			[theScrollView setContentOffset:contentOffset];

		[contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
			^(NSNumber *key, ReaderContentView *contentView, BOOL *stop)
			{
				if ([key integerValue] != page) [contentView zoomResetAnimated:NO];
			}
		];

		[mainToolbar setBookmarkState:[document.bookmarks containsIndex:page]];

		[mainPagebar updatePagebar]; // Update page bar
	}
}

- (void)showDocument
{
	[self updateContentSize:theScrollView]; // Update content size first

	[self showDocumentPage:[document.pageNumber integerValue]]; // Show page

	document.lastOpen = [NSDate date]; // Update document last opened date
}

- (void)closeDocument
{
	if (printInteraction != nil) [printInteraction dismissAnimated:NO];

	[document archiveDocumentProperties]; // Save any ReaderDocument changes

	[[ReaderThumbQueue sharedInstance] cancelOperationsWithGUID:document.guid];

	[[ReaderThumbCache sharedInstance] removeAllObjects]; // Empty the thumb cache

//	if ([delegate respondsToSelector:@selector(dismissReaderViewController:)] == YES)
//	{
		[delegate dismissReaderViewController:self]; // Dismiss the ReaderViewController
//    [self dismissViewControllerAnimated:YES completion:NULL];
//    [self dismissViewControllerAnimated:YES completion:NULL];
//    [self dismissViewControllerAnimated:YES completion:NULL];
//
//    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
//	}
//	else // We have a "Delegate must respond to -dismissReaderViewController:" error
//	{
//		NSAssert(NO, @"Delegate must respond to -dismissReaderViewController:");
//	}
}

#pragma mark - UIViewController methods

- (instancetype)initWithReaderDocument:(ReaderDocument *)object
{
	if ((self = [super initWithNibName:nil bundle:nil])) // Initialize superclass
	{
		if ((object != nil) && ([object isKindOfClass:[ReaderDocument class]])) // Valid object
		{
			userInterfaceIdiom = [UIDevice currentDevice].userInterfaceIdiom; // User interface idiom

			NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter]; // Default notification center

			[notificationCenter addObserver:self selector:@selector(applicationWillResign:) name:UIApplicationWillTerminateNotification object:nil];

			[notificationCenter addObserver:self selector:@selector(applicationWillResign:) name:UIApplicationWillResignActiveNotification object:nil];

			scrollViewOutset = ((userInterfaceIdiom == UIUserInterfaceIdiomPad) ? SCROLLVIEW_OUTSET_LARGE : SCROLLVIEW_OUTSET_SMALL);

			[object updateDocumentProperties]; document = object; // Retain the supplied ReaderDocument object for our use

			[ReaderThumbCache touchThumbCacheWithGUID:object.guid]; // Touch the document thumb cache directory
		}
		else // Invalid ReaderDocument object
		{
			self = nil;
		}
	}

	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    document = [ReaderDocument withDocumentFilePath:[User sharedUser].strPathDocuments password:nil];
//	assert([User sharedUser].strPathDocuments != nil); // Must have a valid ReaderDocument
    if (document == nil) {
//        UIAlertController *alertController = [UIAlertController
//                                              alertControllerWithTitle:@"File Missing!"
//                                              message:@"No File found!"
//                                              preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction
//                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
//                                       style:UIAlertActionStyleCancel
//                                       handler:^(UIAlertAction *action)
//                                       {
//                                           NSLog(@"Cancel action");
//                                       }];
//        
//        UIAlertAction *okAction = [UIAlertAction
//                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction *action)
//                                   {
//                                       NSLog(@"OK action");
//                                   }];
//        
//        [alertController addAction:cancelAction];
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
    assert(document != nil); // Must have a valid ReaderDocument
    }
	self.view.backgroundColor = [UIColor grayColor]; // Neutral gray
//        [self.navigationController setNavigationBarHidden:YES animated:NO];
        UIBarButtonItem * Bookmarkbutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Reader-Mark-N@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(tappedMarkButton)];
        UIBarButtonItem * Thumbnailsbutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Reader-Thumbs@2xX.png"] style:UIBarButtonItemStylePlain target:self action:@selector(tappedThumbsButton)];
        UIBarButtonItem * Sharebutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Reader-Export@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
        UIBarButtonItem * Printbutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Reader-Print@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(tappedPrintButton)];
        UIBarButtonItem * Mailbutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Reader-Email@2x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(tappedEmailButton)];
//        UIBarButtonItem * Tripkitbutton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus-32.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addtoTripkit)];
        btnAirports = [[UIBarButtonItem alloc]initWithTitle:@"| Airports |" style:UIBarButtonItemStylePlain target:self action:@selector(showAirports)];
    
    if ([User sharedUser].bolWPT == YES) {
        self.navigationItem.title = [User sharedUser].strWptTitle;
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnAirports, nil]];
        if ([User sharedUser].bolPreviewWPT == YES) {
//            self.navigationItem.rightBarButtonItems = nil;
            [User sharedUser].bolPreviewWPT = NO;
        }else {
        }
        [User sharedUser].bolWPT = NO;
    }else {
        self.navigationItem.title = [document.fileName stringByDeletingPathExtension];
        NSArray *actionButtonItems = @[Bookmarkbutton,Thumbnailsbutton,Sharebutton,Printbutton,Mailbutton];
        self.navigationItem.rightBarButtonItems = actionButtonItems;
    }
	UIView *fakeStatusBar = nil; CGRect viewRect = self.view.bounds; // View bounds

	if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) // iOS 7+
	{
		if ([self prefersStatusBarHidden] == NO) // Visible status bar
		{
			CGRect statusBarRect = viewRect; statusBarRect.size.height = STATUS_HEIGHT;
			fakeStatusBar = [[UIView alloc] initWithFrame:statusBarRect]; // UIView
			fakeStatusBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			fakeStatusBar.backgroundColor = [UIColor blackColor];
			fakeStatusBar.contentMode = UIViewContentModeRedraw;
			fakeStatusBar.userInteractionEnabled = NO;

			viewRect.origin.y += STATUS_HEIGHT; viewRect.size.height -= STATUS_HEIGHT;
		}
	}
//    if ((document.canPrint == YES) && (document.password == nil)) // Document print enabled
//    {
//        Class printInteractionController = NSClassFromString(@"UIPrintInteractionController");
//        
//        if ((printInteractionController != nil) && [printInteractionController isPrintingAvailable])
//        {
//            rightButtonX -= (iconButtonWidth + buttonSpacing); // Next position
//            
//            UIButton *printButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            printButton.frame = CGRectMake(rightButtonX, BUTTON_Y, iconButtonWidth, BUTTON_HEIGHT);
//            [printButton setImage:[UIImage imageNamed:@"Reader-Print"] forState:UIControlStateNormal];
//            [printButton addTarget:self action:@selector(printButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//            [printButton setBackgroundImage:buttonH forState:UIControlStateHighlighted];
//            [printButton setBackgroundImage:buttonN forState:UIControlStateNormal];
//            printButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//            //printButton.backgroundColor = [UIColor grayColor];
//            printButton.exclusiveTouch = YES;
//            
//            [self addSubview:printButton]; titleWidth -= (iconButtonWidth + buttonSpacing);
//        }
//    }

	CGRect scrollViewRect = CGRectInset(viewRect, -scrollViewOutset, 0.0f);
	theScrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect]; // All
	theScrollView.autoresizesSubviews = NO; theScrollView.contentMode = UIViewContentModeRedraw;
	theScrollView.showsHorizontalScrollIndicator = NO; theScrollView.showsVerticalScrollIndicator = NO;
	theScrollView.scrollsToTop = NO; theScrollView.delaysContentTouches = NO; theScrollView.pagingEnabled = YES;
	theScrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	theScrollView.backgroundColor = [UIColor clearColor]; theScrollView.delegate = self;
	[self.view addSubview:theScrollView];

	CGRect toolbarRect = viewRect; toolbarRect.size.height = TOOLBAR_HEIGHT;
	mainToolbar = [[ReaderMainToolbar alloc] initWithFrame:toolbarRect document:document]; // ReaderMainToolbar
//	mainToolbar.delegate = self; // ReaderMainToolbarDelegate
	[self.view addSubview:mainToolbar];

	CGRect pagebarRect = self.view.bounds; pagebarRect.size.height = PAGEBAR_HEIGHT;
	pagebarRect.origin.y = (self.view.bounds.size.height - pagebarRect.size.height);
	mainPagebar = [[ReaderMainPagebar alloc] initWithFrame:pagebarRect document:document]; // ReaderMainPagebar
	mainPagebar.delegate = self; // ReaderMainPagebarDelegate
	[self.view addSubview:mainPagebar];

	if (fakeStatusBar != nil) [self.view addSubview:fakeStatusBar]; // Add status bar background view

	UITapGestureRecognizer *singleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	singleTapOne.numberOfTouchesRequired = 1; singleTapOne.numberOfTapsRequired = 1; singleTapOne.delegate = self;
	[self.view addGestureRecognizer:singleTapOne];

	UITapGestureRecognizer *doubleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	doubleTapOne.numberOfTouchesRequired = 1; doubleTapOne.numberOfTapsRequired = 2; doubleTapOne.delegate = self;
	[self.view addGestureRecognizer:doubleTapOne];

	UITapGestureRecognizer *doubleTapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	doubleTapTwo.numberOfTouchesRequired = 2; doubleTapTwo.numberOfTapsRequired = 2; doubleTapTwo.delegate = self;
	[self.view addGestureRecognizer:doubleTapTwo];

	[singleTapOne requireGestureRecognizerToFail:doubleTapOne]; // Single tap requires double tap to fail

	contentViews = [NSMutableDictionary new]; lastHideTime = [NSDate date];

	minimumPage = 1; maximumPage = [document.pageCount integerValue];
}
//
//        self.navigationItem.leftBarButtonItem = [self backButton];
//    }
//    
//    - (UIBarButtonItem *)backButton
//    {
//        UIImage *image = [UIImage imageNamed:@"back-32.png"];
//        CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
////        CGRect buttonFrame = CGRectMake(5, 3, 30, 30);
//        UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
//        [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
////        [button setTitle:@"< Back" forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"back-32.png"] forState:UIControlStateNormal];
//        
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
//        
//        return item;
//    }
//-(void)backButtonPressed
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(void)addtoTripkit
{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:[@"Escape Route Waypoint " stringByAppendingString:_escape.wptname]
                                          message:[[@"Do you want to add " stringByAppendingString:_escape.wptname] stringByAppendingString:@" to your enroute escaperoute list ?"]
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"NO", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                       //                                       [self.parentViewController.navigationController popViewControllerAnimated:YES];
                                   }];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"YES", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [[User sharedUser].arrayEscapeRoutes addObject:_escape];
                                   NSString *identifier = [NSString stringWithFormat:@"%@", _escape.wptname];
                                   
                                   // this is very fast constant time lookup in a hash table
                                   if ([[User sharedUser].lookup containsObject:identifier])
                                   {
                                       NSLog(@"item already exists.  removing: %@ at index %lu", identifier, [[User sharedUser].arrayEscapeRoutes count]-1);
                                       [[User sharedUser].arrayEscapeRoutes removeObjectAtIndex:[[User sharedUser].arrayEscapeRoutes count]-1];
                                   }
                                   else
                                   {
                                       NSLog(@"distinct item.  keeping %@ at index %lu", identifier, [[User sharedUser].arrayEscapeRoutes count]-1);
                                       [[User sharedUser].lookup addObject:identifier];
                                   }
                                   
                                   //                                NSInteger intEnrBatchNumber = [[User sharedUser].arrayEscapeRoutes count] + [[User sharedUser].arrayEnrouteAirports count];
                                   //                                [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%li", (long)intEnrBatchNumber]];
                                   ////////////////////////////////// handling alternates for escape waypoint
                                   
                                   arrAlternates = [[NSArray alloc] init];
                                   NSString* string = _escape.alternates;
                                   arrAlternates = [string componentsSeparatedByString:@", "];
                                   //                                [User sharedUser].arrayEnrouteAirports = [[NSMutableArray alloc] init];
                                   self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
                                   for (int i=0; i < [arrAlternates count]; i++)
                                   {
                                       
                                       NSString *strIcaoIdentifier = [arrAlternates objectAtIndex:i];  //find object with this id in core data
                                       
                                       NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
                                       [context setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
                                       
                                       NSFetchRequest *request = [[NSFetchRequest alloc] init];
                                       
                                       if ([[User sharedUser].strEntityName containsString: @"Iran"]) {
                                           [User sharedUser].strEntityAirports = @"AirportsMiddleEast";
                                       }
                                       if ([[User sharedUser].strEntityName containsString: @"Europe"]) {
                                           [User sharedUser].strEntityAirports = @"AirportsEurope";
                                       }
                                       if ([[User sharedUser].strEntityName containsString: @"MiddleEast"]) {
                                           [User sharedUser].strEntityAirports = @"AirportsMiddleEast";
                                       }
                                       if ([[User sharedUser].strEntityName containsString: @"Australia"]) {
                                           [User sharedUser].strEntityAirports = @"AirportsAustralia";
                                       }
                                       if ([[User sharedUser].strEntityName containsString: @"Asia"]) {
                                           [User sharedUser].strEntityAirports = @"AirportsAsia";
                                       }
                                       if ([[User sharedUser].strEntityName containsString: @"China"]) {
                                           [User sharedUser].strEntityAirports = @"AirportsAsia";
                                       }
                                       if ([[User sharedUser].strEntityName containsString: @"AfricaUSA"]) {
                                           [User sharedUser].strEntityAirports = @"AirportsAfrica";
                                       }
                                       
                                       NSEntityDescription *entity = [NSEntityDescription entityForName:[User sharedUser].strEntityAirports
                                                                                 inManagedObjectContext:context];
                                       [request setEntity:entity];
                                       NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier == %@",strIcaoIdentifier];
                                       [request setPredicate:predicate];
                                       
                                       NSArray *results = [context executeFetchRequest:request error:NULL];
                                       if ([results count] == 0) {
                                           [User sharedUser].strEntityAirports = @"AirportsEurasia";
                                           NSEntityDescription *entity = [NSEntityDescription entityForName:[User sharedUser].strEntityAirports
                                                                                     inManagedObjectContext:context];
                                           [request setEntity:entity];
                                           NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier == %@",strIcaoIdentifier];
                                           [request setPredicate:predicate];
                                           
                                           results = [context executeFetchRequest:request error:NULL];
                                       }
                                       if ([results count] == 0) {
                                           [User sharedUser].strEntityAirports = @"AirportsEurope";
                                           NSEntityDescription *entity = [NSEntityDescription entityForName:[User sharedUser].strEntityAirports
                                                                                     inManagedObjectContext:context];
                                           [request setEntity:entity];
                                           NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier == %@",strIcaoIdentifier];
                                           [request setPredicate:predicate];
                                           
                                           results = [context executeFetchRequest:request error:NULL];
                                       }
                                       if ([results count] == 0) {
                                           [User sharedUser].strEntityAirports = @"AirportsAmericas";
                                           NSEntityDescription *entity = [NSEntityDescription entityForName:[User sharedUser].strEntityAirports
                                                                                     inManagedObjectContext:context];
                                           [request setEntity:entity];
                                           NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier == %@",strIcaoIdentifier];
                                           [request setPredicate:predicate];
                                           
                                           results = [context executeFetchRequest:request error:NULL];
                                       }
                                       if ([results count] == 0) {
                                           [User sharedUser].strEntityAirports = @"AirportsAsia";
                                           NSEntityDescription *entity = [NSEntityDescription entityForName:[User sharedUser].strEntityAirports
                                                                                     inManagedObjectContext:context];
                                           [request setEntity:entity];
                                           NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier == %@",strIcaoIdentifier];
                                           [request setPredicate:predicate];
                                           
                                           results = [context executeFetchRequest:request error:NULL];
                                       }
                                       if ([results count] == 0) {
                                           [User sharedUser].strEntityAirports = @"AirportsMiddleEast";
                                           NSEntityDescription *entity = [NSEntityDescription entityForName:[User sharedUser].strEntityAirports
                                                                                     inManagedObjectContext:context];
                                           [request setEntity:entity];
                                           NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier == %@",strIcaoIdentifier];
                                           [request setPredicate:predicate];
                                           
                                           results = [context executeFetchRequest:request error:NULL];
                                       }
                                       if ([results count] == 0) {
                                           [User sharedUser].strEntityAirports = @"AirportsAustralia";
                                           NSEntityDescription *entity = [NSEntityDescription entityForName:[User sharedUser].strEntityAirports
                                                                                     inManagedObjectContext:context];
                                           [request setEntity:entity];
                                           NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier == %@",strIcaoIdentifier];
                                           [request setPredicate:predicate];
                                           
                                           results = [context executeFetchRequest:request error:NULL];
                                       }
                                       if ([results count] == 0) {
                                           [User sharedUser].strEntityAirports = @"AirportsAfrica";
                                           NSEntityDescription *entity = [NSEntityDescription entityForName:[User sharedUser].strEntityAirports
                                                                                     inManagedObjectContext:context];
                                           [request setEntity:entity];
                                           NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier == %@",strIcaoIdentifier];
                                           [request setPredicate:predicate];
                                           
                                           results = [context executeFetchRequest:request error:NULL];
                                       }
                                       if ([results count] == 0) {
                                           [User sharedUser].strEntityAirports = @"AirportsAmericas";
                                           NSEntityDescription *entity = [NSEntityDescription entityForName:[User sharedUser].strEntityAirports
                                                                                     inManagedObjectContext:context];
                                           [request setEntity:entity];
                                           NSPredicate *predicate = [NSPredicate predicateWithFormat:@"icaoidentifier == %@",strIcaoIdentifier];
                                           [request setPredicate:predicate];
                                           
                                           results = [context executeFetchRequest:request error:NULL];
                                       }



                                       Airports *managedairport = [[Airports alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
                                       managedairport = [results objectAtIndex:0];
                                       Airport *detairport = [[Airport alloc] init];
                                       detairport.cat32x = managedairport.cat32x;
                                       detairport.cat332 = managedairport.cat332;
                                       detairport.cat333 = managedairport.cat333;
                                       detairport.cat345 = managedairport.cat345;
                                       detairport.cat346 = managedairport.cat346;
                                       detairport.cat350 = managedairport.cat350;
                                       detairport.cat380 = managedairport.cat380;
                                       detairport.cat777 = managedairport.cat777;
                                       detairport.cat787 = managedairport.cat787;
                                       detairport.note32x = managedairport.note32x;
                                       detairport.note332 = managedairport.note332;
                                       detairport.note333 = managedairport.note333;
                                       detairport.note345 = managedairport.note345;
                                       detairport.note346 = managedairport.note346;
                                       detairport.note350 = managedairport.note350;
                                       detairport.note380 = managedairport.note380;
                                       detairport.note777 = managedairport.note777;
                                       detairport.note787 = managedairport.note787;
                                       detairport.rffnotes = managedairport.rffnotes;
                                       detairport.rff = managedairport.rff;
                                       detairport.rffnotes = managedairport.rffnotes;
                                       detairport.peg = managedairport.peg;
                                       detairport.pegnotes = managedairport.pegnotes;
                                       detairport.iataidentifier = managedairport.iataidentifier;
                                       detairport.icaoidentifier = managedairport.icaoidentifier;
                                       detairport.name = managedairport.name;
                                       detairport.chart = managedairport.chart;
                                       detairport.adequate = managedairport.adequate;
                                       detairport.escaperoute = managedairport.escaperoute;
                                       detairport.updatedAt = managedairport.updatedAt;
                                       detairport.city = managedairport.city;
                                       detairport.cpldg = managedairport.cpldg;
                                       detairport.elevation = managedairport.elevation;
                                       detairport.latitude = managedairport.latitude;
                                       detairport.longitude = managedairport.longitude;
                                       detairport.timezone = managedairport.timezone;
                                       [[User sharedUser].arrayEnrouteAirports addObject:detairport];
                                       NSString *identifier = [NSString stringWithFormat:@"%@", detairport.icaoidentifier];
                                       
                                       // this is very fast constant time lookup in a hash table
                                       if ([[User sharedUser].lookupAirport containsObject:identifier])
                                       {
                                           NSLog(@"item already exists.  removing: %@ at index %lu", identifier, [[User sharedUser].arrayEnrouteAirports count]-1);
                                           [[User sharedUser].arrayEnrouteAirports removeObjectAtIndex:[[User sharedUser].arrayEnrouteAirports count]-1];
                                       }
                                       else
                                       {
                                           NSLog(@"distinct item.  keeping %@ at index %lu", identifier, [[User sharedUser].arrayEnrouteAirports count]-1);
                                           [[User sharedUser].lookupAirport addObject:identifier];
                                       }
                                       
                                   }
                                   NSInteger intEnrBatchNumber = [[User sharedUser].arrayEscapeRoutes count] + [[User sharedUser].arrayEnrouteAirports count];
                                   [[[[[self tabBarController] viewControllers] objectAtIndex: 4] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%li", (long)intEnrBatchNumber]];
                                   ////////////////////////////////////////////////////////////////
                                   
                               }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	if (CGSizeEqualToSize(lastAppearSize, CGSizeZero) == false)
	{
		if (CGSizeEqualToSize(lastAppearSize, self.view.bounds.size) == false)
		{
			[self updateContentViews:theScrollView]; // Update content views
		}

		lastAppearSize = CGSizeZero; // Reset view size tracking
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	if (CGSizeEqualToSize(theScrollView.contentSize, CGSizeZero) == true)
	{
		[self performSelector:@selector(showDocument) withObject:nil afterDelay:0.0];
	}

#if (READER_DISABLE_IDLE == TRUE) // Option

	[UIApplication sharedApplication].idleTimerDisabled = YES;

#endif // end of READER_DISABLE_IDLE Option
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	lastAppearSize = self.view.bounds.size; // Track view size

#if (READER_DISABLE_IDLE == TRUE) // Option

	[UIApplication sharedApplication].idleTimerDisabled = NO;

#endif // end of READER_DISABLE_IDLE Option
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
#ifdef DEBUG
	NSLog(@"%s", __FUNCTION__);
#endif

	mainToolbar = nil; mainPagebar = nil;

	theScrollView = nil; contentViews = nil; lastHideTime = nil;

	documentInteraction = nil; printInteraction = nil;

	lastAppearSize = CGSizeZero; currentPage = 0;

	[super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (userInterfaceIdiom == UIUserInterfaceIdiomPad) if (printInteraction != nil) [printInteraction dismissAnimated:NO];

	ignoreDidScroll = YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
	if (CGSizeEqualToSize(theScrollView.contentSize, CGSizeZero) == false)
	{
		[self updateContentViews:theScrollView]; lastAppearSize = CGSizeZero;
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	ignoreDidScroll = NO;
}

- (void)didReceiveMemoryWarning
{
#ifdef DEBUG
	NSLog(@"%s", __FUNCTION__);
#endif

	[super didReceiveMemoryWarning];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (ignoreDidScroll == NO) [self layoutContentViews:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self handleScrollViewDidEnd:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	[self handleScrollViewDidEnd:scrollView];
}

#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldReceiveTouch:(UITouch *)touch
{
	if ([touch.view isKindOfClass:[UIScrollView class]]) return YES;

	return NO;
}

#pragma mark - UIGestureRecognizer action methods

- (void)decrementPageNumber
{
	if ((maximumPage > minimumPage) && (currentPage != minimumPage))
	{
		CGPoint contentOffset = theScrollView.contentOffset; // Offset

		contentOffset.x -= theScrollView.bounds.size.width; // View X--

		[theScrollView setContentOffset:contentOffset animated:YES];
	}
}

- (void)incrementPageNumber
{
	if ((maximumPage > minimumPage) && (currentPage != maximumPage))
	{
		CGPoint contentOffset = theScrollView.contentOffset; // Offset

		contentOffset.x += theScrollView.bounds.size.width; // View X++

		[theScrollView setContentOffset:contentOffset animated:YES];
	}
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
		CGRect viewRect = recognizer.view.bounds; // View bounds

		CGPoint point = [recognizer locationInView:recognizer.view]; // Point

		CGRect areaRect = CGRectInset(viewRect, TAP_AREA_SIZE, 0.0f); // Area rect

		if (CGRectContainsPoint(areaRect, point) == true) // Single tap is inside area
		{
			NSNumber *key = [NSNumber numberWithInteger:currentPage]; // Page number key

			ReaderContentView *targetView = [contentViews objectForKey:key]; // View

			id target = [targetView processSingleTap:recognizer]; // Target object

			if (target != nil) // Handle the returned target object
			{
				if ([target isKindOfClass:[NSURL class]]) // Open a URL
				{
					NSURL *url = (NSURL *)target; // Cast to a NSURL object

					if (url.scheme == nil) // Handle a missing URL scheme
					{
						NSString *www = url.absoluteString; // Get URL string

						if ([www hasPrefix:@"www"] == YES) // Check for 'www' prefix
						{
							NSString *http = [[NSString alloc] initWithFormat:@"http://%@", www];

							url = [NSURL URLWithString:http]; // Proper http-based URL
						}
					}

					if ([[UIApplication sharedApplication] openURL:url] == NO)
					{
						#ifdef DEBUG
							NSLog(@"%s '%@'", __FUNCTION__, url); // Bad or unknown URL
						#endif
					}
				}
				else // Not a URL, so check for another possible object type
				{
					if ([target isKindOfClass:[NSNumber class]]) // Goto page
					{
						NSInteger number = [target integerValue]; // Number

						[self showDocumentPage:number]; // Show the page
					}
				}
			}
//			else // Nothing active tapped in the target content view
//			{
//				if ([lastHideTime timeIntervalSinceNow] < -0.75) // Delay since hide
//				{
//					if ((mainToolbar.alpha < 1.0f) || (mainPagebar.alpha < 1.0f)) // Hidden
//					{
//						[mainToolbar showToolbar]; [mainPagebar showPagebar]; // Show
//					}
//				}
//			}

			return;
		}

		CGRect nextPageRect = viewRect;
		nextPageRect.size.width = TAP_AREA_SIZE;
		nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);

		if (CGRectContainsPoint(nextPageRect, point) == true) // page++
		{
			[self incrementPageNumber]; return;
		}

		CGRect prevPageRect = viewRect;
		prevPageRect.size.width = TAP_AREA_SIZE;

		if (CGRectContainsPoint(prevPageRect, point) == true) // page--
		{
			[self decrementPageNumber]; return;
		}
	}
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateRecognized)
	{
		CGRect viewRect = recognizer.view.bounds; // View bounds

		CGPoint point = [recognizer locationInView:recognizer.view]; // Point

		CGRect zoomArea = CGRectInset(viewRect, TAP_AREA_SIZE, TAP_AREA_SIZE); // Area

		if (CGRectContainsPoint(zoomArea, point) == true) // Double tap is inside zoom area
		{
			NSNumber *key = [NSNumber numberWithInteger:currentPage]; // Page number key

			ReaderContentView *targetView = [contentViews objectForKey:key]; // View

			switch (recognizer.numberOfTouchesRequired) // Touches count
			{
				case 1: // One finger double tap: zoom++
				{
					[targetView zoomIncrement:recognizer]; break;
				}

				case 2: // Two finger double tap: zoom--
				{
					[targetView zoomDecrement:recognizer]; break;
				}
			}

			return;
		}

		CGRect nextPageRect = viewRect;
		nextPageRect.size.width = TAP_AREA_SIZE;
		nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);

		if (CGRectContainsPoint(nextPageRect, point) == true) // page++
		{
			[self incrementPageNumber]; return;
		}

		CGRect prevPageRect = viewRect;
		prevPageRect.size.width = TAP_AREA_SIZE;

		if (CGRectContainsPoint(prevPageRect, point) == true) // page--
		{
			[self decrementPageNumber]; return;
		}
	}
}

#pragma mark - ReaderContentViewDelegate methods

- (void)contentView:(ReaderContentView *)contentView touchesBegan:(NSSet *)touches
{
	if ((mainToolbar.alpha > 0.0f) || (mainPagebar.alpha > 0.0f))
	{
		if (touches.count == 1) // Single touches only
		{
			UITouch *touch = [touches anyObject]; // Touch info

			CGPoint point = [touch locationInView:self.view]; // Touch location

			CGRect areaRect = CGRectInset(self.view.bounds, TAP_AREA_SIZE, TAP_AREA_SIZE);

			if (CGRectContainsPoint(areaRect, point) == false) return;
		}

		[mainToolbar hideToolbar]; [mainPagebar hidePagebar]; // Hide

		lastHideTime = [NSDate date]; // Set last hide time
	}
}

#pragma mark - ReaderMainToolbarDelegate methods

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar doneButton:(UIButton *)button
{
#if (READER_STANDALONE == FALSE) // Option

	[self closeDocument]; // Close ReaderViewController
//    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];

#endif // end of READER_STANDALONE Option
}

//- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar thumbsButton:(UIButton *)button

- (void)tappedThumbsButton
{
#if (READER_ENABLE_THUMBS == TRUE) // Option

	if (printInteraction != nil) [printInteraction dismissAnimated:NO];

	ThumbsViewController *thumbsViewController = [[ThumbsViewController alloc] initWithReaderDocument:document];

	thumbsViewController.title = self.title; thumbsViewController.delegate = self; // ThumbsViewControllerDelegate

	thumbsViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	thumbsViewController.modalPresentationStyle = UIModalPresentationFullScreen;

	[self presentViewController:thumbsViewController animated:NO completion:NULL];

#endif // end of READER_ENABLE_THUMBS Option
}

- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar exportButton:(UIButton *)button
//- (void)tappedExportButton
{
	if (printInteraction != nil) [printInteraction dismissAnimated:YES];

	NSURL *fileURL = document.fileURL; // Document file URL

	documentInteraction = [UIDocumentInteractionController interactionControllerWithURL:fileURL];

	documentInteraction.delegate = self; // UIDocumentInteractionControllerDelegate

	[documentInteraction presentOpenInMenuFromRect:button.bounds inView:button animated:YES];
}
- (void)share {
    if (printInteraction != nil) [printInteraction dismissAnimated:YES];
    
    NSURL *fileURL = document.fileURL; // Document file URL    //    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    [docController dismissMenuAnimated:NO];
    docController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    [docController presentOptionsMenuFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];

}


- (void)tappedPrintButton
{
	if ([UIPrintInteractionController isPrintingAvailable] == YES)
	{
		NSURL *fileURL = document.fileURL; // Document file URL

		if ([UIPrintInteractionController canPrintURL:fileURL] == YES)
		{
			printInteraction = [UIPrintInteractionController sharedPrintController];

			UIPrintInfo *printInfo = [UIPrintInfo printInfo];
			printInfo.duplex = UIPrintInfoDuplexLongEdge;
			printInfo.outputType = UIPrintInfoOutputGeneral;
			printInfo.jobName = document.fileName;

			printInteraction.printInfo = printInfo;
			printInteraction.printingItem = fileURL;
			printInteraction.showsPageRange = YES;

			if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) // Large device printing
			{
				[printInteraction presentFromRect:CGRectMake(10, 10, 0, 0) inView:self.view animated:YES completionHandler:
					^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
					{
						#ifdef DEBUG
							if ((completed == NO) && (error != nil)) NSLog(@"%s %@", __FUNCTION__, error);
						#endif
					}
				];
			}
			else // Handle printing on small device
			{
				[printInteraction presentAnimated:YES completionHandler:
					^(UIPrintInteractionController *pic, BOOL completed, NSError *error)
					{
						#ifdef DEBUG
							if ((completed == NO) && (error != nil)) NSLog(@"%s %@", __FUNCTION__, error);
						#endif
					}
				];
			}
		}
	}
}

- (void)tappedEmailButton
{
	if ([MFMailComposeViewController canSendMail] == NO) return;

	if (printInteraction != nil) [printInteraction dismissAnimated:YES];

	unsigned long long fileSize = [document.fileSize unsignedLongLongValue];

	if (fileSize < 15728640ull) // Check attachment size limit (15MB)
	{
		NSURL *fileURL = document.fileURL; NSString *fileName = document.fileName;

		NSData *attachment = [NSData dataWithContentsOfURL:fileURL options:(NSDataReadingMapped|NSDataReadingUncached) error:nil];

		if (attachment != nil) // Ensure that we have valid document file attachment data available
		{
			MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];

			[mailComposer addAttachmentData:attachment mimeType:@"application/pdf" fileName:fileName];

			[mailComposer setSubject:fileName]; // Use the document file name for the subject

			mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
			mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;

			mailComposer.mailComposeDelegate = self; // MFMailComposeViewControllerDelegate

			[self presentViewController:mailComposer animated:YES completion:NULL];
		}
	}
}
//- (void)tappedInToolbar:(ReaderMainToolbar *)toolbar markButton:(UIButton *)button

- (void)tappedMarkButton
{
#if (READER_BOOKMARKS == TRUE) // Option

	if (printInteraction != nil) [printInteraction dismissAnimated:YES];

	if ([document.bookmarks containsIndex:currentPage]) // Remove bookmark
	{
		[document.bookmarks removeIndex:currentPage]; [mainToolbar setBookmarkState:NO];
	}
	else // Add the bookmarked page number to the bookmark index set
	{
		[document.bookmarks addIndex:currentPage]; [mainToolbar setBookmarkState:YES];
	}

#endif // end of READER_BOOKMARKS Option
}

#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
#ifdef DEBUG
	if ((result == MFMailComposeResultFailed) && (error != NULL)) NSLog(@"%@", error);
#endif

	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIDocumentInteractionControllerDelegate methods

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
	documentInteraction = nil;
}

#pragma mark - ThumbsViewControllerDelegate methods

- (void)thumbsViewController:(ThumbsViewController *)viewController gotoPage:(NSInteger)page
{
#if (READER_ENABLE_THUMBS == TRUE) // Option

	[self showDocumentPage:page];

#endif // end of READER_ENABLE_THUMBS Option
}

- (void)dismissThumbsViewController:(ThumbsViewController *)viewController
{
#if (READER_ENABLE_THUMBS == TRUE) // Option

	[self dismissViewControllerAnimated:NO completion:NULL];

#endif // end of READER_ENABLE_THUMBS Option
}

#pragma mark - ReaderMainPagebarDelegate methods

- (void)pagebar:(ReaderMainPagebar *)pagebar gotoPage:(NSInteger)page
{
	[self showDocumentPage:page];
}

#pragma mark - UIApplication notification methods

- (void)applicationWillResign:(NSNotification *)notification
{
	[document archiveDocumentProperties]; // Save any ReaderDocument changes

	if (userInterfaceIdiom == UIUserInterfaceIdiomPad) if (printInteraction != nil) [printInteraction dismissAnimated:NO];
}

-(void) showAirports
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AirportAlternatesTableViewController *Waypointcontroller = (AirportAlternatesTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"enRouteAlternates"];
    [self.navigationController pushViewController:Waypointcontroller animated:YES];
    
}


@end
