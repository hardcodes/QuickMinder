//
//  HCUITextField.h
//  QuickMinder
//
//  Created by Putze Sven on 02.02.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HCUITextFieldDisabledAlpha 0.1



@protocol HCAttachmentViewDelegate
@required

- (void) attachmentButtonWasTouched: (id) sender;

@end

@interface HCUITextField : UITextField{

}
	// Selector is a convenience method
	// leftViewIsShown=YES -> show leftView with "group" image
	// leftViewIsShown=NO  -> hide & release leftView
- (void) toggleGroupLeftViewIsVisible: (BOOL) leftViewIsShown;

	// displays a warning message in the rightView of the given textField if rightViewIsShown==YES
	// otherwise the current rightView is released
- (void) toggleRightHCOverlayWarningViewWithText: (NSString*) aText isVisible: (BOOL) rightViewIsShown;

	// display image with number of attachments
- (void) toggleLeftAttachmentViewWithText: (NSString*) aText isVisible: (BOOL) rightViewIsShown;

	// Selector returns YES if the text of this textField contains at least 1 valid email address
- (BOOL) textHasOneValidMailRecipient;

	// Selector returns YES if the text of this textField contains more than one valid email address
- (BOOL) textHasMultipleValidMailRecipients;


	// Selector returns YES if aHaystack contains aNeedle
+ (BOOL) haystack: (NSString*) aHaystack containsNeedle: (NSString*) aNeedle;

	// Selector returns YES if Mail Recipient is valid
+ (BOOL) isValidRecipientWithNumber: (NSInteger) recipientNumber;

@property (assign, nonatomic) NSUInteger buttonControlEvent;

@end
