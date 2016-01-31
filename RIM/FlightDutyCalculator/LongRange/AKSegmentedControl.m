//
//  AKSegmentedControl.m
//  RIM
//
//  Created by Michael Gehringer on 9/3/15.
//  Copyright © 2015 Mikelsoft.com. All rights reserved.
//

#import "AKSegmentedControl.h"

@implementation AKSegmentedControl

//- (void)setSelectedSegmentIndex:(NSInteger)toValue {
//    // Trigger UIControlEventValueChanged even when re-tapping the selected segment.
//    if (toValue==self.selectedSegmentIndex) {
//        [self sendActionsForControlEvents:UIControlEventValueChanged];
//    }
//    [super setSelectedSegmentIndex:toValue];
//}

//-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self sendActionsForControlEvents:UIControlEventAllTouchEvents];
//    [super touchesEnded:touches withEvent:event];
//}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSInteger previousSelectedSegmentIndex = self.selectedSegmentIndex;
    [super touchesBegan:touches withEvent:event];
//    if (![[self class] isIOS7]) {
        // before iOS7 the segment is selected in touchesBegan
        if (previousSelectedSegmentIndex == self.selectedSegmentIndex) {
            // if the selectedSegmentIndex before the selection process is equal to the selectedSegmentIndex
            // after the selection process the superclass won't send a UIControlEventValueChanged event.
            // So we have to do this ourselves.
//            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
//    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSInteger previousSelectedSegmentIndex = self.selectedSegmentIndex;
    [super touchesEnded:touches withEvent:event];
//    if ([[self class] isIOS7]) {
        // on iOS7 the segment is selected in touchesEnded
        if (previousSelectedSegmentIndex == self.selectedSegmentIndex) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
//    }
}


@end
