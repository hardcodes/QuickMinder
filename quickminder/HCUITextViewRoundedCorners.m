//
//  HCUITextViewRoundedCorners.m
//  quickminder
//
//  Created by Putze Sven on 01.01.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import "HCUITextViewRoundedCorners.h"
#import "QuartzCore/CALayer.h"


#pragma mark - implementation

@implementation HCUITextViewRoundedCorners

- (id)initWithFrame:(CGRect)frame
{
	DLog(@"");
	
    self = [super initWithFrame:frame];
    if (self) {
			// Initialization code
		self.layer.cornerRadius = HCCornerRadius;
		
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
	
	DLog(@"");
	
	self = [super initWithCoder: aDecoder];
	if(self){
		self.layer.cornerRadius = HCCornerRadius;
	}
	return self;
}


@end
