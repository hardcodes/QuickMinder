//
//  HCUIViewTouchCatcher.m
//  QuickMinder
//
//  Created by Putze Sven on 01.03.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import "HCUIViewTouchCatcher.h"


#pragma mark - implementation

@implementation HCUIViewTouchCatcher

@synthesize delegate = _delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	
	DLog(@"point=%@, event=%@", NSStringFromCGPoint(point), event);
	
	UIView *subView = nil;
	subView = [super hitTest: point withEvent: event];
		// one of our subviews was hit
	if(subView) return subView;
		// no subview was hit -> return self to indicate that we will handle the touch
		// so - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event will be called
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	DLog(@"");
	[[self delegate] dismissHCUIPopoverViewControllerFromTouchCatcherViewAnimated: YES];
}

@end
