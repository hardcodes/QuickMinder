//
//  HCUIViewTouchCatcher.h
//  QuickMinder
//
//  Created by Putze Sven on 01.03.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HCUIViewTouchCatcherDelegate
@required
- (void)dismissHCUIPopoverViewControllerFromTouchCatcherViewAnimated: (BOOL) isAnimated;
@end

@interface HCUIViewTouchCatcher : UIView{

}

@property (assign, nonatomic) id <HCUIViewTouchCatcherDelegate> delegate;

@end
