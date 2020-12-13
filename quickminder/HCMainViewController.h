//
//  HCMainViewController.h
//  quickminder
//
//  Created by Putze Sven on 21.12.11.
//  Copyright (c) 2011 hardcodes.de. All rights reserved.
//

#import "HCSettingsViewController.h"
#import "HCMoreRecepientsSendMailViewContoller.h"
#import "HCStaticMethods.h"
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIView.h>
#import "HCUIPopoverViewController.h"
#import "HCUISegmentedControl.h"
#import "HCManageAttachmentsUIViewController.h"

#define deg2rad (3.1415926/180.0)

	// number of pixels that should be visbible above the keyboard
#define HCKeyboardPadding 3
	// sumber of pixels from view bottom to textView bottom
#define HCViewPaddingPad 20
#define HCViewPaddingPhone 10
	// delay before becomeFirstResponder is called
#define HCFirstResponderDelay 0.6
	// max. length of subject
#define HCMaxSubjectLength 192
#define HCIPadPopoverVieControllerViewFactor 0.7



@interface HCMainViewController : UIViewController <
HCSettingsViewControllerDelegate,
HCMoreRecepientsSendMailViewContollerDelegate,
MFMailComposeViewControllerDelegate,
CLLocationManagerDelegate,
UITextViewDelegate,
UITextFieldDelegate,
HCUIPopoverViewControllerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
HCAttachmentViewDelegate,
HCManageAttachmentsUIViewControllerDelegate,
UIPopoverControllerDelegate>{
}

@property (retain, nonatomic) IBOutlet UITextView *textViewMessageBody;
@property (retain, nonatomic) IBOutlet UIView *landscapeNavigationView;
@property (retain, nonatomic) IBOutlet UIView *portraitNavigationView;
@property (retain, nonatomic) IBOutlet UIButton *buttonSendMail1;
@property (retain, nonatomic) IBOutlet UIButton *buttonSendMail2;
@property (retain, nonatomic) IBOutlet UIButton *buttonSendMail3;
@property (retain, nonatomic) IBOutlet UIButton *buttonSendMail4;
@property (retain, nonatomic) IBOutlet UIButton *buttonToolPopoverLandscape;
@property (retain, nonatomic) IBOutlet UIButton *buttonToolPopoverPortrait;
@property (retain, nonatomic) IBOutlet UIButton *buttonTrash;
@property (retain, nonatomic) IBOutlet UIView *viewHelpNote;
@property (retain, nonatomic) IBOutlet HCUITextField *textFieldSubject;
@property (retain, nonatomic) IBOutlet UIButton *buttonSendMail1Landscape;
@property (retain, nonatomic) IBOutlet UIButton *buttonSendMail1Portrait;
@property (retain, nonatomic) IBOutlet UIButton *buttonShowMailReceiversPortrait;
@property (retain, nonatomic) IBOutlet UIButton *buttonShowMailReceiversLandscape;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;



- (IBAction)buttonTrashTouchUpInside:(id)sender;
- (IBAction)buttonSendMailTouched:(id)sender;
- (IBAction)textFieldSubjectDidEndOnExit:(id)sender;
- (IBAction)buttonToolPopoverTouched:(id)sender;


@end
	