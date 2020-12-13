//
//  HCUIButton.m
//  QuickMinder
//
//  Created by Putze Sven on 06.02.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import "HCUIButton.h"
#import "QuartzCore/CALayer.h"
#import "HCDefaultStrings.h"


#pragma mark - private interface

@interface HCUIButton() {
}
- (void)setupView;

@end



#pragma mark - implementation

@implementation HCUIButton


#pragma mark - overridden


- (id)initWithFrame:(CGRect)frame{

	DLog(@"");

    self = [super initWithFrame:frame];
    if (self) {
			// Initialization code
		[self setupView];
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


-(void) setEnabled:(BOOL)enabled{
	
	if(enabled) self.alpha=1.0;
	else self.alpha=HCUIButtonDisabledAlpha;
	[super setEnabled: enabled];

}


+ (UIImage*)ImageOfType: (HCButtonImageType) imageType{
	
	NSString *imageName;
	
	switch(imageType){
			
		case HCButtomImageTrash:
			imageName = @"trash";
			break;
			
		case HCButtonImageCamera:
			imageName = @"camera";
			break;
			
		case HCButtonImageGPS:
			imageName = @"locationservice";
			break;
			
		default:
			
			return nil;
	}
	
	NSString* platform;
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) platform=@"ipad";
	else platform=@"iphone";
	NSString *fileName = [NSString stringWithFormat: @"%@~%@", imageName, platform];
	
	UIImage *buttonImage = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: fileName ofType: HCPng]];

	return [buttonImage autorelease];
}


- (void) setDeviceIndependentImageOfType: (HCButtonImageType) imageType{
	
	UIImage *buttonImage = [HCUIButton ImageOfType: imageType];
	[self setImage: buttonImage forState: UIControlStateNormal];

}


- (void) setDeviceIndependentFrameBasedOnPhoneFrame: (CGRect) aPhoneFrame{
	
	CGRect buttonFrameRect = CGRectNull;
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
		buttonFrameRect  = CGRectMake(aPhoneFrame.origin.x, aPhoneFrame.origin.y, aPhoneFrame.size.width*2, aPhoneFrame.size.height*2);
	}
	else buttonFrameRect = aPhoneFrame;
		
	[self setFrame: buttonFrameRect];
}


- (void)setupView{
	
	DLog(@"");
	
	[[self layer] setCornerRadius: HCUIButtonCornerRadius];	
	[self setClipsToBounds: YES];	
}


@end
