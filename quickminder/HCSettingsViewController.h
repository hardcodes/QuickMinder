//
//  HCSettingsViewController.h
//  quickminder
//
//  Created by Putze Sven on 21.12.11.
//  Copyright (c) 2011 hardcodes.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "HCUIViewRoundedCorners.h"
#import "HCUITextField.h"
#import "HCUISegmentedControl.h"
#import "HCUIPopoverViewController.h"


//	// number of pixels that should be visbible above the keyboard
//#define HCSettingsKeyboardPadding 4
#define HCMaxTextFieldRecipientLength 256
#define HCMaxTextFieldAliasLength 64

#define HCFullMaxMailRecipients 20
#define HCLiteMaxMailRecipients 4

@class HCSettingsViewController;

@protocol HCSettingsViewControllerDelegate
- (void)settingsViewControllerDidFinish:(HCSettingsViewController *)controller;
@end



@interface HCSettingsViewController : UIViewController
<UITextFieldDelegate,
ABPeoplePickerNavigationControllerDelegate,
HCUIPopoverViewControllerDelegate,
UIGestureRecognizerDelegate>{
	
}

@property (assign, nonatomic) id <HCSettingsViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet HCUITextField *textFieldMailReceiver1;
@property (retain, nonatomic) IBOutlet HCUITextField *textFieldMailReceiver2;
@property (retain, nonatomic) IBOutlet HCUITextField *textFieldMailReceiver3;
@property (retain, nonatomic) IBOutlet HCUITextField *textFieldMailReceiver4;
@property (retain, nonatomic) IBOutlet UITextField *textFieldMailSubject;
@property (retain, nonatomic) IBOutlet HCUITextField *textFieldMailAlias1;
@property (retain, nonatomic) IBOutlet HCUITextField *textFieldMailAlias2;
@property (retain, nonatomic) IBOutlet HCUITextField *textFieldMailAlias3;
@property (retain, nonatomic) IBOutlet HCUITextField *textFieldMailAlias4;
@property (retain, nonatomic) IBOutlet UISwitch *switchWordCorrection;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UISwitch *switchAutoDelete;
@property (retain, nonatomic) IBOutlet UISwitch *switchShowKeyboard;
@property (retain, nonatomic) IBOutlet UITextField *textFieldSendMailButtonLabel;
@property (retain, nonatomic) IBOutlet UISwitch *switchAutoSendMail;
@property (retain, nonatomic) IBOutlet HCUIViewRoundedCorners *viewMailAddress1;
@property (retain, nonatomic) IBOutlet HCUIViewRoundedCorners *viewMailAddress2;
@property (retain, nonatomic) IBOutlet HCUIViewRoundedCorners *viewMailAddress3;
@property (retain, nonatomic) IBOutlet HCUIViewRoundedCorners *viewMailAddress4;
@property (retain, nonatomic) IBOutlet UISwitch *switchSavePhotos;
@property (retain, nonatomic) IBOutlet UISlider *horizontalSliderCompressPhotos;
@property (retain, nonatomic) IBOutlet HCUISegmentedControl *segmentedControlFlash;
@property (retain, nonatomic) IBOutlet UISlider *horizontalSliderResizePhotos;
@property (retain, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGestureRecognizer;

- (IBAction)dismissViewControllerViaDelegate:(id)sender;
- (IBAction)switchWordCorrectionChanged:(id)sender;
- (IBAction)textFieldEditingDidEndOnExit:(id)sender;
- (IBAction)switchAutoDeleteChanged:(id)sender;
- (IBAction)switchShowKeyboardChanged:(id)sender;
- (IBAction)buttonLookupAddressbookTouched:(id)sender;
- (IBAction)switchAutoSendMailChanged:(id)sender;
- (IBAction)buttonInfoTouched:(id)sender;
- (IBAction)switchSavePhotosChanged:(id)sender;
- (IBAction)horizontalSliderCompressPhotosValueChanged:(id)sender;
- (IBAction)segmentedControlFlashValueChanged:(id)sender;
- (IBAction)horizontalSliderResizePhotosValueChanged:(id)sender;

- (void)validateContentOfTextField:(UITextField *)textField writeBack:(BOOL) writeBack;

- (void)validateEachTextField;


@end
