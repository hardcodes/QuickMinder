//
//  HCUITextField.m
//  QuickMinder
//
//  Created by Putze Sven on 02.02.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import "HCUITextField.h"
#import "HCOverlayWarningView.h"
#import "HCDefaultStrings.h"
#import "HCMailConfigItem.h"

#pragma mark - implementation

@implementation HCUITextField

@synthesize buttonControlEvent = _buttonControlEvent;


#pragma mark - init

- (id)initWithCoder:(NSCoder *)aDecoder{
	
	DLog(@"");
	
	self = [super initWithCoder: aDecoder];
	if(self){
		
		[self setButtonControlEvent: UIControlEventTouchUpInside];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame{
	
	DLog(@"");
	
	self = [super initWithFrame: frame];
	if(self){
		
		[self setButtonControlEvent: UIControlEventTouchUpInside];
	}
	
	return self;
}


-(void) setEnabled:(BOOL)enabled{
	
	
	if(enabled) self.alpha=1.0;
	else self.alpha=HCUITextFieldDisabledAlpha;

	[super setEnabled: enabled];
}


#pragma mark - left/right overlay view

- (void) toggleGroupLeftViewIsVisible: (BOOL) leftViewIsShown{

	DLog(@"");
	
	if(leftViewIsShown){
		
		UIImage *image = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: HCGroupImage32 ofType: HCPng]];
		UIImageView *overlayGroupView = [[UIImageView alloc] initWithImage: image];
		[image release];
		[self setLeftView: overlayGroupView];
		[overlayGroupView release];
		
		[[self leftView] setHidden: NO];
		[self setLeftViewMode: UITextFieldViewModeAlways];
	}
	else{
		[[self leftView] setHidden: YES];
		[self setLeftViewMode: UITextFieldViewModeNever];
		[self setLeftView: nil];
	}
}


- (void) toggleRightHCOverlayWarningViewWithText: (NSString*) aText isVisible: (BOOL) rightViewIsShown{

	DLog(@"");
	
	if(rightViewIsShown){
		
		CGRect warningRect = self.frame;
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) warningRect.size.width /=2.3;
		else warningRect.size.width /=1.3;
		warningRect.size.height *= 0.7;
		HCOverlayWarningView *warning = [[HCOverlayWarningView alloc] initWithText: aText frame: warningRect];
		[self setRightView: warning];
		[[self rightView] setHidden: NO];
		[warning release];
		[self setRightViewMode: UITextFieldViewModeUnlessEditing];
	}
	else{
		[self setRightViewMode: UITextFieldViewModeNever];
		[self setRightView: nil];
	}
}


- (void) toggleLeftAttachmentViewWithText: (NSString*) aText isVisible: (BOOL) rightViewIsShown{
	
	DLog(@"");
	
	if(rightViewIsShown){
		
		
		UIFont *font = [UIFont systemFontOfSize:12];
		CGSize textSize = [aText sizeWithFont: font constrainedToSize:CGSizeMake(32, 32)];
		
		UIButton *button;
		button = [UIButton buttonWithType: UIButtonTypeCustom];
		UIImage *buttonImage = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: HCAttachmentIcon ofType: HCPng]];
		[button setImage: buttonImage forState: UIControlStateNormal];
		CGRect buttonFrame = CGRectMake(0,0,buttonImage.size.width +textSize.width, buttonImage.size.height);

		[button setFrame: buttonFrame];
		[buttonImage release];
			// set the button's target
			// default event is UIControlEventTouchUpInside unless set otherwise
		[button addTarget: self.delegate action: @selector(attachmentButtonWasTouched:) forControlEvents: self.buttonControlEvent];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(buttonImage.size.width -2, buttonImage.size.height -textSize.height +2, textSize.width, textSize.height)];
		[label setBackgroundColor: [UIColor clearColor]];
		[label setTextColor: UIColorFromHEXWithAlpha(0x656492dd)];
		[label setFont: font];
		[label setText: aText];
		[label setTextAlignment: UITextAlignmentRight];
		[label setNumberOfLines: 1];
		[label setShadowColor: [UIColor whiteColor]];
		[label setShadowOffset: CGSizeMake(-1, -1)];

		
		[button addSubview: label];
		[label release];

		[self setLeftView: button];
		[[self leftView] setHidden: NO];
		[self setLeftViewMode: UITextFieldViewModeAlways];
	}
	else{
		[[self leftView] setHidden: YES];
		[self setLeftViewMode: UITextFieldViewModeNever];
		[self setLeftView: nil];
	}
	
}


#pragma mark - email

- (BOOL) textHasOneValidMailRecipient{
	
	
		// use own static method for easier code maintenance
	return [HCMailConfigItem mailRecipientIsValid: self.text];
}


- (BOOL) textHasMultipleValidMailRecipients{
	
	
	return [HCMailConfigItem mailRecipientsAreValid: self.text];

}


#pragma mark - class methods

+ (BOOL) haystack: (NSString*) aHaystack containsNeedle: (NSString*) aNeedle{
	
	DLog(@"");
	
	NSRange range = [aHaystack rangeOfString: aNeedle];
	if(range.location==NSNotFound) return NO;
	return YES;
}

+ (BOOL) isValidRecipientWithNumber: (NSInteger) recipientNumber{
	
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *recipient;
	NSString *alias;
	
	switch (recipientNumber) {
		case 1:
			recipient = [defaults objectForKey: HCMailReceiver1Key];
			alias = [defaults objectForKey: HCMailReceiverAlias1Key];
			break;
		case 2:
			recipient = [defaults objectForKey: HCMailReceiver2Key];
			alias = [defaults objectForKey: HCMailReceiverAlias2Key];
			break;
			
		case 3:
			recipient = [defaults objectForKey: HCMailReceiver3Key];
			alias = [defaults objectForKey: HCMailReceiverAlias3Key];
			break;

		case 4:
			recipient = [defaults objectForKey: HCMailReceiver4Key];
			alias = [defaults objectForKey: HCMailReceiverAlias4Key];
			break;

		default:
			recipient = @"";
			alias = @"";
			break;
	}
	return ([HCMailConfigItem mailRecipientIsValid: recipient]==YES || [HCMailConfigItem mailRecipientsAreValid: recipient]==YES) && ([HCMailConfigItem mailRecipientAliasIsValid: alias]==YES);
}


@end
