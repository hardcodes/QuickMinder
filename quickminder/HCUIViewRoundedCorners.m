//
//  HCUIViewRoundedCorners.m
//  quickminder
//
//  Created by Putze Sven on 01.01.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import "HCUIViewRoundedCorners.h"
#import "QuartzCore/CALayer.h"


#pragma mark - private interface

@interface HCUIViewRoundedCorners() {
}
- (void)setupView;

@end


#pragma mark - implementation

@implementation HCUIViewRoundedCorners

- (id)initWithFrame:(CGRect)frame
{
	DLog(@"");
	
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andRadius: (CGFloat) aRadius{
	
	DLog(@"");
	
	self = [super initWithFrame:frame];
    if (self) {
			// Initialization code
		self.layer.cornerRadius = aRadius;
		
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
	
	DLog(@"");
	
	self = [super initWithCoder: aDecoder];
	if(self){
		[self setupView];
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


- (void)setupView{
	
	DLog(@"");
	
	self.layer.cornerRadius = HCCornerRadius;	
}

@end
