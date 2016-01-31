//
//  EscapeWPTViewController.m
//  RIM
//
//  Created by Mikel on 27.03.15.
//  Copyright (c) 2015 Mikelsoft.com. All rights reserved.
//

#import "EscapeWPTDetailViewController.h"
#import "EscapeRouteTableViewController.h"
#import "User.h"


//@interface EscapeWPTDetailViewController () <UIScrollViewDelegate>
@interface EscapeWPTDetailViewController ()
//@property (nonatomic) IBOutlet UIImageView *imgviewEscape;
//@property (nonatomic) IBOutlet UIScrollView *scollviewEscape;
@end

@implementation EscapeWPTDetailViewController

- (void)setEscapewpt:(Escape *)newEscapeWPT
{
    if (_escapewpt != newEscapeWPT)
    {
        _escapewpt = newEscapeWPT;
        [self configureView];
    }
}

- (void)configureView
{
    self.view.backgroundColor = [UIColor grayColor];
    self.title = self.escapewpt.wptname;
    self.title = [self.escapewpt.wptname length] ? self.escapewpt.wptname : @"None";
    NSLog(@"wpt name: %@", self.escapewpt.wptname);
//    NSLog(@"Image Path: %@", self.escapewpt.path);
//    NSString* strImage = [self.escapewpt.chapter stringByAppendingString:self.escapewpt.page];
//    NSString* imageName = [[NSBundle mainBundle] pathForResource:strImage ofType:@"png"];
//    UIImage* imageObj = [[UIImage alloc] initWithContentsOfFile:imageName];
//    self.imgviewEscape = [[UIImageView alloc]initWithImage:imageObj];
//    self.imgviewEscape.image = [UIImage imageWithData:self.escapewpt.chart];
//    [self.webView loadData:self.escapewpt.chart MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
//    self.scollviewEscape = [[UIScrollView alloc]initWithFrame:self.view.bounds];
//    [self.scollviewEscape addSubview:self.imgviewEscape];
//    self.scollviewEscape.contentSize = self.imgviewEscape.bounds.size;
//    self.scollviewEscape.indicatorStyle = UIScrollViewIndicatorStyleWhite;
//    self.scollviewEscape.minimumZoomScale = 0.3f;
//    self.scollviewEscape.maximumZoomScale = 3.0f;
//    self.scollviewEscape.delegate = self;
//    [self.view addSubview:self.scollviewEscape];
    
    
}

#pragma mark -
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        [[User sharedUser].arrayEscapeRoutes addObject:self.escapewpt];
        [self.parentViewController.navigationController popViewControllerAnimated:YES];    }
    else
    {
        
        [self.parentViewController.navigationController popViewControllerAnimated:YES];
    }
}

//- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    NSLog(@"viewForZoomingInScrollView");
//    return self.imgviewEscape;
//}
#pragma mark -
#pragma mark === View Life Cycle Management ===
#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self configureView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

@end
