//
//  VolumesViewController.h
//  uplift
//
//  Created by Michael Gehringer on 29.03.12.
//  Copyright (c) 2012 Mikelsoft.com. All rights reserved.
//

#import <UIKit/UIKit.h>





@class VolumesViewController;

@protocol VolumesViewControllerDelegate <NSObject>

    - (void) didUpdateData;

- (void)volumesViewController:
(VolumesViewController *)controller didSelectVolume:(NSString *)volume;
@end

@interface VolumesViewController : UITableViewController {
//    id delegate;
}
@property (nonatomic, weak) id <VolumesViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *volume;
// define delegate instance
//@property (nonatomic, assign) id <ModelViewDelegate> delegate;

@end
