//
//  HCOverlayWarningView.m
//  quickminder
//
//  Created by Putze Sven on 13.01.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import "HCOverlayWarningView.h"
#import "QuartzCore/CALayer.h"


#pragma mark - implementation

@implementation HCOverlayWarningView


- (id)initWithFrame:(CGRect)frame
{
	DLog(@"");
	
    self = [super initWithFrame:frame];
    if (self) {
			// Initialization code
		self.layer.cornerRadius = HCWarningViewCornerRadius;
		
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
	
	DLog(@"");
	
	self = [super initWithCoder: aDecoder];
	if(self){
		self.layer.cornerRadius = HCWarningViewCornerRadius;
	}
	return self;
}


- (id)initWithText: (NSString*) aText frame: (CGRect) aFrame{
	
	DLog(@"");
	
	self = [self initWithFrame: aFrame];
    if (self) {

		UIFont *font = [UIFont systemFontOfSize:15];
		CGSize textSize = [aText sizeWithFont: font constrainedToSize:CGSizeMake(280, 60)];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 5, textSize.height + 5)];
		[label setBackgroundColor: [UIColor clearColor]];
		[label setTextColor: [UIColor whiteColor]];
		[label setFont: font];
		[label setText: aText];
		[label setTextAlignment: UITextAlignmentCenter];
		[label setNumberOfLines: 0];
		[label setShadowColor: [UIColor darkGrayColor]];
		[label setShadowOffset: CGSizeMake(1, 1)];
		[label setCenter: CGPointMake( aFrame.size.width/2, aFrame.size.height/2)];
		
		[self addSubview: label];
		[label release];
		
		[self setBackgroundColor: [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5]];
		[self setAlpha: 1.0];
		[self setHidden: NO];
		
    }
    return self;
}

@end
