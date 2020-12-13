//
//  HCMainViewController.m
//  quickminder
//
//  Created by Putze Sven on 21.12.11.
//  Copyright (c) 2011 hardcodes.de. All rights reserved.
//

#import "HCMainViewController.h"
#import "HCDefaultStrings.h"
#import <UIKit/UIKit.h>
#import "HCMoreRecepientsSendMailViewContoller.h"
#import "HCAppDelegate.h"
#import "HCUITextField.h"
#import "HCMailComposeViewController.h"
#import "HCUIButton.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "HCMailAttachment.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "PersistanceHandler.h"
#import "SMTEDelegateController.h"


#pragma mark - private interface

@interface HCMainViewController ()

@property (retain, nonatomic) NSString *oldMailSubject;
@property (assign, nonatomic) BOOL viewIsVisible;
@property (assign, nonatomic) BOOL foundLocation;
@property (assign, nonatomic) BOOL locationServiceInProgress;
@property (assign, nonatomic) CGRect keyboardRect;
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (retain, nonatomic) id currentFirstResponder;
@property (retain, nonatomic) id lastUIViewController;
@property (retain, nonatomic) HCUIPopoverViewController *toolPopOverViewController;
@property (retain, nonatomic) NSMutableArray *attachments;
@property (retain, nonatomic) UIPopoverController *ipadPopoverController;
@property (retain, nonatomic) SMTEDelegateController *textExpander;


	// "private" methods
- (void)showGPSPosition;
- (void)showCameraViewController;
- (void)locationManagerTimeoutHandler;
- (void)setViewUserInteractionEnabledStates;
- (void)setTextViewFrameSize;
	// Seletor is a convenience method
	// YES = all 4 recipients and aliasses are invalid
- (BOOL)allRecipientsAreInvalid;
- (void)checkFirstResponder;
- (void)trashContentAndCheckSettings: (BOOL) checkSettings;
- (void)restoreUserSession;
- (void)dismissImagePickerController:(UIImagePickerController *)picker animated: (BOOL) animated;


@end


#pragma mark - implementation

@implementation HCMainViewController

@synthesize textViewMessageBody = _textViewMessageBody;
@synthesize landscapeNavigationView = _landscapeNavigationView;
@synthesize portraitNavigationView = _portraitNavigationView;
@synthesize buttonSendMail1 = _buttonSendMail1;
@synthesize buttonSendMail2 = _buttonSendMail2;
@synthesize buttonSendMail3 = _buttonSendMail3;
@synthesize buttonSendMail4 = _buttonSendMail4;
@synthesize buttonTrash = _buttonTrash;
@synthesize viewHelpNote = _viewHelpNote;
@synthesize buttonSendMail1Landscape = _buttonSendMail1Landscape;
@synthesize buttonSendMail1Portrait = _buttonSendMail1Portrait;
@synthesize buttonShowMailReceiversPortrait = _buttonShowMailReceiversPortrait;
@synthesize buttonShowMailReceiversLandscape = _buttonShowMailReceiversLandscape;
@synthesize activityIndicator = _activityIndicator;
@synthesize textFieldSubject = _textFieldSubject;
@synthesize buttonToolPopoverPortrait = _buttonLocationServicesPortrait;
@synthesize buttonToolPopoverLandscape = _buttonLocationServicesLandscape;
@synthesize oldMailSubject = _oldMailSubject;
@synthesize viewIsVisible = _viewIsVisible;
@synthesize keyboardRect = _keyboardRect;
@synthesize locationManager = _locationManager;
@synthesize foundLocation = _foundLocation;
@synthesize currentFirstResponder = _currentFirstResponder;
@synthesize lastUIViewController = _lastUIViewController;
@synthesize toolPopOverViewController = _toolPopOverViewController;
@synthesize attachments = _attachments;
@synthesize ipadPopoverController = _ipadPopoverController;
@synthesize locationServiceInProgress = _locationServiceInProgress;
@synthesize textExpander = _textExpander;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	
	DLog(@"");
	
    [super viewDidLoad];
		// Do any additional setup after loading the view, typically from a nib.
		// check the current interfaceOrientaion to hide/show the right buttons
	if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
		
		[[self landscapeNavigationView] setHidden: TRUE];
		[[self portraitNavigationView] setHidden: FALSE];
	}
	else{
		[[self landscapeNavigationView] setHidden: FALSE];
		[[self portraitNavigationView] setHidden: TRUE];
	}

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(UIApplicationWillResignActiveNotification:)
												 name:UIApplicationWillResignActiveNotification
											   object:self.view.window];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(UIApplicationDidBecomeActiveNotification:)
												 name:UIApplicationWillEnterForegroundNotification
											   object:self.view.window];
	
	[self setCurrentFirstResponder: nil];
	[self setLastUIViewController: nil];
	[self setToolPopOverViewController: nil];
	[self setKeyboardRect: CGRectNull];
	[self setAttachments: nil];
	[self restoreUserSession];
	[self setLocationServiceInProgress: NO];

	// Initialize the TextExpander delegate controller
	[self setTextExpander: [[SMTEDelegateController alloc] init]];
	DLog(@"TextExpander touch installed: %@", [SMTEDelegateController isTextExpanderTouchInstalled] ? @"YES" : @"NO");
	DLog(@"TextExpander snippets are shared: %@", [SMTEDelegateController snippetsAreShared] ? @"YES" : @"NO");
}

- (void)viewDidUnload
{
	[self setTextViewMessageBody:nil];
    [self setLandscapeNavigationView:nil];
    [self setPortraitNavigationView:nil];
	[self setButtonSendMail1:nil];
	[self setButtonSendMail2:nil];
	[self setButtonSendMail3:nil];
	[self setButtonSendMail4:nil];
    [self setButtonToolPopoverLandscape:nil];
	[self setViewHelpNote:nil];
	[self setButtonTrash:nil];
	[self setButtonShowMailReceiversPortrait:nil];
	[self setButtonToolPopoverPortrait:nil];
    [self setButtonSendMail1Landscape:nil];
    [self setButtonSendMail1Portrait:nil];
	[self setTextFieldSubject:nil];
	[self setButtonShowMailReceiversLandscape:nil];
	[self setButtonShowMailReceiversPortrait:nil];
	[self setButtonShowMailReceiversLandscape:nil];
	[self setIpadPopoverController: nil];
	[self setActivityIndicator:nil];
	[self setTextExpander: nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIApplicationWillResignActiveNotification
												  object:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIApplicationDidBecomeActiveNotification
												  object:nil];

	[self setLocationManager: nil];
	[self setCurrentFirstResponder: nil];
	[self setLastUIViewController: nil];
	[self setOldMailSubject: nil];
	[self setToolPopOverViewController: nil];
	[self setAttachments: nil];
	
}


- (void)dealloc
{
	[_textViewMessageBody release];
    [_landscapeNavigationView release];
    [_portraitNavigationView release];
	[_buttonSendMail1 release];
	[_buttonSendMail2 release];
	[_buttonSendMail3 release];
	[_buttonSendMail4 release];
    [_buttonLocationServicesLandscape release];
	[_viewHelpNote release];
	[_buttonTrash release];
	[_buttonLocationServicesPortrait release];
    [_buttonSendMail1Landscape release];
    [_buttonSendMail1Portrait release];
	[_textFieldSubject release];
	[_buttonShowMailReceiversPortrait release];
	[_buttonShowMailReceiversLandscape release];
	[_currentFirstResponder release];
	[_lastUIViewController release];
	[_locationManager release];
	[_oldMailSubject release];
	[_toolPopOverViewController release];
	[_attachments release];
	[_ipadPopoverController release];
	[_activityIndicator release];
	[_textExpander release];
	[super dealloc];
}


- (void)viewWillAppear:(BOOL)animated
{
	
	DLog(@"");
	
	[super viewWillAppear:animated];
	
		// So we can resize the uiscrollview if the keyboard is shown
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(UIKeyboardDidShowNotification:)
												 name:UIKeyboardDidShowNotification
											   object:self.view.window];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(UIKeyboardDidHideNotification:)
												 name:UIKeyboardDidHideNotification
											   object:self.view.window];

		// load the defaults/user values
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
		// button 1-4 are only present on iPad
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
		[[self buttonSendMail1] setTitle: [defaults valueForKey: HCMailReceiverAlias1Key] forState: UIControlStateNormal];
		[[self buttonSendMail2] setTitle: [defaults valueForKey: HCMailReceiverAlias2Key] forState: UIControlStateNormal];
		[[self buttonSendMail3] setTitle: [defaults valueForKey: HCMailReceiverAlias3Key] forState: UIControlStateNormal];
		[[self buttonSendMail4] setTitle: [defaults valueForKey: HCMailReceiverAlias4Key] forState: UIControlStateNormal];
	}
	else{
		[[self buttonSendMail1Portrait] setTitle: [defaults valueForKey: HCMailReceiverAlias1Key] forState: UIControlStateNormal];
		[[self buttonSendMail1Landscape] setTitle: [defaults valueForKey: HCMailReceiverAlias1Key] forState: UIControlStateNormal];
	}
	[self setViewUserInteractionEnabledStates];

	if([defaults boolForKey: HCWordCorrectionKey]==YES){
		[[self textFieldSubject] setAutocorrectionType: UITextAutocorrectionTypeYes];
		[[self textViewMessageBody] setAutocorrectionType: UITextAutocorrectionTypeYes];

		DLog(@"UITextAutocorrectionTypeYes");

	}
	else{
		[[self textFieldSubject] setAutocorrectionType: UITextAutocorrectionTypeNo];
		[[self textViewMessageBody] setAutocorrectionType: UITextAutocorrectionTypeNo];

		DLog(@"UITextAutocorrectionTypeNo");
	}
	// check if we can and should use TextExpander Touch
	#ifndef DEBUG
	if(YES==[SMTEDelegateController isTextExpanderTouchInstalled] && YES==[SMTEDelegateController snippetsAreShared] && YES==[defaults boolForKey: HCUseTextExpander]){
	#endif

		[[self textFieldSubject] setDelegate: self.textExpander];
		[[self textViewMessageBody] setDelegate: self.textExpander];
		// Set ourself as the next delegate to be called after the TextExpander delegate controller
		[[self textExpander] setNextDelegate:self];
	#ifndef DEBUG
	}
	else{
		DLog(@"not using TextExpander Touch");
		[[self textFieldSubject] setDelegate: self];
		[[self textViewMessageBody] setDelegate: self];
	}
	#endif
	DLog(@"self.textFieldSubject.delegate = %@", self.textFieldSubject.delegate);
	DLog(@"self.textViewMessageBody.delegate = %@", self.textViewMessageBody.delegate);

	if(self.allRecipientsAreInvalid==YES){
		self.textFieldSubject.text = @"";
	}
	else{
		if([[self lastUIViewController] isKindOfClass: [HCSettingsViewController class]]){
				// Has the mailsubject been changed?
			NSString *newDefaultMailSubject = [defaults objectForKey: HCMailSubjectKey];
			NSString *newSubjectText;
			if(![self.oldMailSubject isEqualToString: newDefaultMailSubject] || [self.textFieldSubject.text isEqualToString: @""]){
					// mailsubject was changed -> change in textFieldSubject
				if([self.oldMailSubject isEqualToString: @""] || [self.textFieldSubject.text isEqualToString: @""]){
					newSubjectText = newDefaultMailSubject;
					DLog(@"oldMailSubject || textFieldSubject.text is empty, new subject=%@", newSubjectText);
				}
				else{
						// replace the subject at the beginning of text only
					NSRange subjectRange = NSMakeRange(0, self.oldMailSubject.length);
					newSubjectText = [self.textFieldSubject.text stringByReplacingOccurrencesOfString: self.oldMailSubject withString: newDefaultMailSubject options: 0 range: subjectRange];
					DLog(@"replacing text, new subject=%@", newSubjectText);
				}
					// new composed line of text as subject
				self.textFieldSubject.text = newSubjectText;
					// the default value for a subject has changed
				[self setOldMailSubject: newDefaultMailSubject];

			}
		}
	}

	DLog(@"self.textFieldSubject.text = %@", self.textFieldSubject.text);

		// so not every new view must be set here
	[self setLastUIViewController: nil];
}


- (void)viewDidAppear:(BOOL)animated{
	
	DLog(@"");
	
    [super viewDidAppear:animated];
	if(![HCMailComposeViewController canSendMail]) [HCStaticMethods showWarningMessage: NSLocalizedString(@"This device can not send mail! Please check the mail settings of your device", nil)];
	[self setViewIsVisible: YES];
	
	[self performSelector:@selector(checkFirstResponder) withObject: nil afterDelay: HCFirstResponderDelay];
	
#if defined (BETA_VERSION)
	DLog(@"BETA_VERSION, setting text color");
	[[self textFieldSubject] setTextColor: UIColorFromHEX(0xff0033)];
	[[self textViewMessageBody] setTextColor: UIColorFromHEX(0xff0033)];
#else
	DLog(@"NO BETA_VERSION, leaving text color");
#endif

}


- (void)viewDidLayoutSubviews{

	DLog(@"");
		// documentation says that super does nothing but maybe in future
	[super viewDidLayoutSubviews];

}


- (void)viewWillDisappear:(BOOL)animated{	

	DLog(@"");
	[self setViewIsVisible: NO];
	[super viewWillDisappear:animated];
	
		// unregister for keyboard notifications while not visible.
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardDidShowNotification
												  object:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardDidHideNotification
												  object:nil];

}


- (void)viewDidDisappear:(BOOL)animated
{

	DLog(@"");

	[super viewDidDisappear:animated];
}


#pragma mark - application lifecycle

- (void)UIApplicationWillResignActiveNotification: (NSNotification*) aNotification{
	
		// AppDelegate has received applicationWillResignActive:
	DLog(@"");
		// write back the userdefaults to be sure that they are on disk
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		// store the curent message to restore it eventually
	[defaults setObject: self.textViewMessageBody.text forKey: HCTextViewMailBodyKey];
	[defaults setObject: self.textFieldSubject.text forKey: HCTextViewMailSubjectKey];
	
		// we got attachments, save them to disk
	BOOL archiveSuccess = [PersistanceHandler archiveObject: self.attachments toNSDocumentDirectoryWithFileName: HCAttachmentsStorageFileName];
	if(archiveSuccess==NO) ALog(@"Could not save attachments!");
		// save some memory
	[[self attachments] removeAllObjects];
	[defaults synchronize];

	if(self.toolPopOverViewController.popoverIsVisible){
		[[self toolPopOverViewController] dismissHCUIPopoverViewControllerFromSuperViewAnimated: NO];
	}
	[self setToolPopOverViewController: nil];		
	
	if(self.ipadPopoverController && self.ipadPopoverController.isPopoverVisible==YES){		
		[[self ipadPopoverController] dismissPopoverAnimated: NO];
	}
		
	[self setIpadPopoverController: nil];
	
	if(self.presentedViewController && [self.presentedViewController isKindOfClass: [UIImagePickerController class]]){
		[[self presentedViewController] dismissModalViewControllerAnimated: NO];
	}
}


- (void)UIApplicationDidBecomeActiveNotification: (NSNotification*) aNotification{
		// AppDelegate has received applicationWillEnterForeground:

	DLog(@"");

	[self restoreUserSession];
		// tell textExpander to reload textsnippets
	[[self textExpander] willEnterForeground];
	[self setViewUserInteractionEnabledStates];

}


#pragma mark - Storyboard / Seques


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{


	DLog(@"%@", [segue identifier]);

	self.viewIsVisible = NO;
	
		// seque to HCSettingsViewController
    if ([[segue identifier] isEqualToString:@"showPreferences"]) {
		
		HCSettingsViewController *settingsController = (HCSettingsViewController*) [segue destinationViewController];
        [settingsController setDelegate:self];
		[self setLastUIViewController: settingsController];
	}
	
		// seque to HCPortraitSendMailViewContoller
	if ([[segue identifier] isEqualToString:@"showMailButtonsPortrait"] || [[segue identifier] isEqualToString:@"showMailButtonsLandscape"]) {
		HCMoreRecepientsSendMailViewContoller *moreRecepientsSendMailViewContoller = (HCMoreRecepientsSendMailViewContoller*) [segue destinationViewController];
		[moreRecepientsSendMailViewContoller setDelegate:self];
		[self setLastUIViewController: moreRecepientsSendMailViewContoller];
	}
}


#pragma mark - Buttons

- (IBAction)buttonToolPopoverTouched:(id)sender {
	
	DLog(@"");
	
	if(self.toolPopOverViewController.popoverIsVisible){
		
		[self dismissPopoverViewController: (HCUIPopoverViewController*) self.toolPopOverViewController animated: YES];

	}
	else{
		if(!self.toolPopOverViewController) [self setToolPopOverViewController: [[HCUIPopoverViewController alloc] initWithCoder: nil]];
		[[self toolPopOverViewController] setDelegate: self];
		[[self toolPopOverViewController] setContentBackgroundColor: UIColorFromHEX(0x8992c5)];
			// button is nested in the "navigation" view
		CGRect senderRect = [ self.view convertRect: [sender frame] fromView: [sender superview]];

		DLog(@"main view Rect=%@", NSStringFromCGRect(self.view.frame));
		DLog(@"senderRect=%@", NSStringFromCGRect(senderRect));
		
		[[self toolPopOverViewController] presentHCUIPopoverViewControllerInSuperView: self.view forAlignmentRect: senderRect animated: YES];
		
		if([self currentFirstResponder] != nil){
			if([[self currentFirstResponder] respondsToSelector: @selector(resignFirstResponder)]){
				DLog(@"currentFirstResponder respondsToSelector 'resignFirstResponder'");
				[[self currentFirstResponder] performSelector: @selector(resignFirstResponder)];
			}
		}
	
	}	
}


- (IBAction)buttonTrashTouchUpInside:(id)sender {
	
	DLog(@"");
	
    [self trashContentAndCheckSettings: NO];
	[[self textFieldSubject] becomeFirstResponder];
	
}

- (IBAction)buttonSendMailTouched:(id)sender {

	DLog(@"");
	
		// call the delegate method (using HCMoreRecepientsSendMailViewContollerDelegate Protocol)
	[self sendMailAfterViewAppearedFromButtonWithTag: sender];

}



#pragma mark - orientationchange


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    DLog(@"");
	return YES;
	
}


- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
	
	DLog(@"");
	
	if(self.toolPopOverViewController && self.toolPopOverViewController.popoverVisible==YES){
		[[self toolPopOverViewController] dismissHCUIPopoverViewControllerFromSuperViewAnimated: NO];
		if([self currentFirstResponder] != nil){
			if([[self currentFirstResponder] respondsToSelector: @selector(becomeFirstResponder)]){

				DLog(@"currentFirstResponder respondsToSelector 'becomeFirstResponder'");

				[[self currentFirstResponder] performSelector: @selector(becomeFirstResponder)];
			}
		}
		
	}
	
	if(self.ipadPopoverController){
		
		if(self.ipadPopoverController.isPopoverVisible==YES) [self.ipadPopoverController dismissPopoverAnimated: NO];
		else [self setIpadPopoverController: nil];
	}


	[super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
	
	[[self landscapeNavigationView] setHidden: YES];
	[[self portraitNavigationView] setHidden: YES];
	
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	
	DLog(@"");
	
	[super didRotateFromInterfaceOrientation: fromInterfaceOrientation];
	
		// check the coming interfaceOrientaion to hide/show the right buttons
	if(UIInterfaceOrientationIsPortrait(fromInterfaceOrientation)){
		
		[[self landscapeNavigationView] setHidden: NO];
		[[self portraitNavigationView] setHidden: YES];
		[[self landscapeNavigationView] setNeedsDisplay];
	}
	else{
		[[self landscapeNavigationView] setHidden: YES];
		[[self portraitNavigationView] setHidden: NO];
		[[self portraitNavigationView] setNeedsDisplay];
	}
	

	
	if(self.ipadPopoverController && self.ipadPopoverController.isPopoverVisible==NO){

		[self.ipadPopoverController presentPopoverFromRect: self.buttonToolPopoverLandscape.frame 
													inView: self.view
								  permittedArrowDirections: UIPopoverArrowDirectionAny 
												  animated: YES];
	}
	else{
		if([self currentFirstResponder] != nil){
			[[self currentFirstResponder] becomeFirstResponder];

		}
	}
	
	[self setViewUserInteractionEnabledStates];
	
}


#pragma mark - keyboard handling

	// Called when the UIKeyboardDidShowNotification is sent.
- (void)UIKeyboardDidShowNotification: (NSNotification*) aNotification{
	
	DLog(@"");	
		// keyboard hides part of the textView -> resize it
	NSDictionary* info = [aNotification userInfo];
	self.keyboardRect = [ self.view convertRect: [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView: nil];
	
	[self setTextViewFrameSize];
}


	// Called when the UIKeyboardDidShowNotification is sent.
- (void)UIKeyboardDidHideNotification: (NSNotification*) aNotification{
	
	DLog(@"");
	
	[self setKeyboardRect: CGRectNull];
	[self setTextViewFrameSize];

}


- (void) setTextViewFrameSize{

	DLog(@"");
	
	CGRect textViewFrame = [[self textViewMessageBody] frame];
	BOOL textViewFrameHasChanged = NO;
	
	if(self.allRecipientsAreInvalid==YES || self.currentFirstResponder==nil || CGRectIsNull(self.keyboardRect)){
			// no keyboard is shown, take the whole space
		GLuint padding;
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) padding = HCViewPaddingPad;
		else padding = HCViewPaddingPhone;
		textViewFrame.size.height = self.view.bounds.size.height - self.textViewMessageBody.frame.origin.y - padding;
		textViewFrameHasChanged = YES;
	}
	else{
			// check if keyboard hides a part of the textView
		if (CGRectIntersectsRect(self.keyboardRect, textViewFrame)){

			DLog(@"keyboard and textView overlap");
			textViewFrame.size.height = self.view.bounds.size.height - self.keyboardRect.size.height - self.textViewMessageBody.frame.origin.y - HCKeyboardPadding;
			textViewFrameHasChanged = YES;

		}
		else{

			DLog(@"keyboard and textView do not overlap");
				// the keyboard does not hide a part of the textView
				// but maybe the distance is too big
			if(self.keyboardRect.origin.y - CGRectGetMinY(textViewFrame) > HCKeyboardPadding){

				DLog(@"space between keyboard and textView is too big");

				textViewFrame.size.height = self.view.bounds.size.height - self.keyboardRect.size.height - self.textViewMessageBody.frame.origin.y - HCKeyboardPadding;
				textViewFrameHasChanged = YES;			
			}

		}
	}
	
		// change the frame only if really needed
	if(textViewFrameHasChanged){

		DLog(@"self.view: %@", self.view);
		DLog(@"keyboardRect: %@", NSStringFromCGRect(self.keyboardRect));
		DLog(@"textViewMessageBody: %@", self.textViewMessageBody);
		DLog(@"new frame: %@", NSStringFromCGRect(textViewFrame));
		
		if(textViewFrame.size.height <= 0){

			DLog(@"textViewFrame.size.height <= 0, no resizing");

		}
		else{
			[[self textViewMessageBody] setFrame: textViewFrame];
			[[self textViewMessageBody] setNeedsLayout];
		}
	}
	else{
		DLog(@"no resizing");
	}
}


	// we will be called after the user has edited the subject and enters "Return"
- (IBAction)textFieldSubjectDidEndOnExit:(id)sender {
	
	DLog(@"");
		
		// make the UITextView the FirstResponder, thus entering mail text is quicker
		// fake that the textView had text even if not so
		// (empty text leads to reactivating the textField again)
	[[self textViewMessageBody] becomeFirstResponder];
	[self setCurrentFirstResponder: [self textViewMessageBody]];
	
}


#pragma mark - HCSettingsViewControllerDelegate Protocol

- (void)settingsViewControllerDidFinish:(HCSettingsViewController *)controller
{
	DLog(@"");
	
	[self dismissViewControllerAnimated: YES completion: nil];
}


#pragma mark - UITextViewDelegate Protocol


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView{

		// if viewHelpNote is shown, we should not react upon touches in the textView 
	if(self.allRecipientsAreInvalid==YES){

		DLog(@" NO");
		return NO;
	}

	DLog(@" YES");
	return YES;
}


- (void) textViewDidBeginEditing:(UITextView *)textView{
	
	DLog(@"");
	
		// our only way to know that it is the textView that caused the keyboard to show up
	[self setCurrentFirstResponder: textView];
	
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

	DLog(@"textView:shouldChangeTextInRange:replacementText: , %@, %@", NSStringFromRange(range), text);


	if((range.length==0 && range.location==0 && text.length==0 && textView.text.length==0)){
			// flip back to textField

		DLog(@"flip back to textField");

		[[self textFieldSubject] becomeFirstResponder];
		[self setCurrentFirstResponder: [self textFieldSubject]];
		return NO;
	}
	
	return YES;
}


#pragma mark - UITextFieldDelegate Protocol


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
	
		// if viewHelpNote is shown, we should not react upon touches in the textField 
	if(self.allRecipientsAreInvalid==YES){
		DLog(@"textFieldShouldBeginEditing: NO");
		return NO;
	}
	DLog(@"textFieldShouldBeginEditing: YES");
	
	return YES;

}


- (void) textFieldDidBeginEditing:(UITextField *)textField{
	
	DLog(@"");
	
		// user touched the subject field
	[self setCurrentFirstResponder: textField];
}


- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	
		// check if the max. length is exceeded
	if(textField.text.length - range.length + string.length >= HCMaxSubjectLength) return NO;
	
	return YES;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	DLog(@"");
	
	if (buttonIndex == 1) {
		
			//OK clicked
		
	} else {
		
	}
	
}


#pragma mark - HCMoreRecepientsSendMailViewContollerDelegate Protocol


	// delegate is also called from HCPortraitSendMailViewContoller
- (void)sendMailFromButtonWithTag: (id) sender fromController:(HCMoreRecepientsSendMailViewContoller*)aController{
	
DLog(@"");
	[[self activityIndicator] startAnimating];
	[self performSelector:@selector(sendMailAfterViewAppearedFromButtonWithTag:) withObject:sender afterDelay:0.5];
	[self dismissModalViewControllerAnimated:YES];
	
}


- (void) sendMailAfterViewAppearedFromButtonWithTag: (id) sender{
	
	DLog(@"");
	
		// check if the view is visible = we can show the mailcomposer
	if(!self.viewIsVisible){
		
		DLog(@"view is still not visible");

			// we are still not visible -> HCMoreRecepientsSendMailViewContoller is still closing
		[self performSelector:@selector(sendMailAfterViewAppearedFromButtonWithTag:) withObject:sender afterDelay:0.1];
	}
	else{
		
		[[self activityIndicator] startAnimating];
			// we are visible at last -> send mail
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSString *mailRecipient;
		
		switch ([sender tag]) {
			case 1:
					// send mail to recevier #1
				mailRecipient = [defaults objectForKey: HCMailReceiver1Key];
				break;
				
			case 2: // send mail to receiver #2
				mailRecipient = [defaults objectForKey: HCMailReceiver2Key];
				break;
				
			case 3: // send mail to receiver #3
				mailRecipient = [defaults objectForKey: HCMailReceiver3Key];
				break;
				
				
			case 4: // send mail to receiver #4
				mailRecipient = [defaults objectForKey: HCMailReceiver4Key];
				break;
				
			default:
					// should never happen
				mailRecipient = [defaults objectForKey: HCMailReceiver1Key];
				break;
		}
		
		[HCMailComposeViewController sendMailWithSubject: self.textFieldSubject.text messageBody: self.textViewMessageBody.text toRecipient: mailRecipient attachments: self.attachments withDelegate: self];
		
	}
}


- (void) moreRecepientsSendMailViewContollerDidFinish: (HCMoreRecepientsSendMailViewContoller*) aController{
	
	DLog(@"");
	
	[self dismissModalViewControllerAnimated:YES];
	
}


#pragma mark - MFMailComposeViewControllerDelegate Protocol

	// The mail compose view controller delegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError *)error

{
	DLog(@"");
	
	[[self activityIndicator] stopAnimating];
	
	NSString *errorMessage=@"";
	BOOL showErrorMessage = YES;
		
		switch (result) {
				
			case MFMailComposeResultCancelled:
				errorMessage = NSLocalizedString(@"sending mail was cancelled - you should not see this message :-/", nil);
				showErrorMessage = NO;
				break;
				
			case MFMailComposeResultSaved:
				errorMessage = NSLocalizedString(@"mail was saved in iOS mailcenter for later delivery", nil);
				break;
				
			case MFMailComposeResultSent:
				errorMessage = NSLocalizedString(@"mail was sent - you should not see this message :-/", nil);
				showErrorMessage = NO;
					// mail has been sent, delete text?
				NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
				if([defaults boolForKey: HCAutoDeleteKey]){
					
					[self trashContentAndCheckSettings: YES];
				}

				break;
				
			case MFMailComposeResultFailed:
				errorMessage = [NSString stringWithFormat: @"%@%@", NSLocalizedString(@"sending of mail failed :-/\nerrorCode: ",nil), error];
				break;
				
			default:
					// should never happen
				errorMessage = [NSString stringWithFormat: @"%@%@", NSLocalizedString(@"an unknown error has occured. Sorry for beeing so unclear :-/\nerrorCode: ", nil), error];
				break;
		}
		
	if(showErrorMessage && ![errorMessage isEqualToString: @""]) [HCStaticMethods showWarningMessage: errorMessage];

	[self setCurrentFirstResponder: [self textFieldSubject]];

		// [self dismissModalViewControllerAnimated:YES];
	[self dismissViewControllerAnimated: YES completion: ^(void){
		
		[[self textFieldSubject] becomeFirstResponder];
		
		DLog(@"dismissViewControllerAnimated:completion: self.currentFirstResponder=%@", self.currentFirstResponder);

	}];
	
}


#pragma mark - GPS

-(void)showGPSPosition{
	
	DLog(@"");
	
		// should never happen, the device is not capable of location services
	if ([CLLocationManager locationServicesEnabled] == NO){
			// in production this should never happen because the button will not be activated
		[HCStaticMethods showWarningMessage: NSLocalizedString(@"Your device can not use the location services!", nil)];
		return;
	}
		// the device can use location services but "the user explicitly denied the use of location services for this application or
		// location services are currently disabled in Settings."
	if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
			// in production this should never happen because the button will not be activated
		[HCStaticMethods showWarningMessage: NSLocalizedString(@"kCLAuthorizationStatusDenied", nil)];
		return;
	}
	[[self activityIndicator] startAnimating];
	[[self textViewMessageBody] becomeFirstResponder];
	[self setCurrentFirstResponder: [self textViewMessageBody]];
		// locate the device
	if(!self.locationManager) [self setLocationManager: [[CLLocationManager alloc] init]];
	[self.locationManager setDesiredAccuracy: kCLLocationAccuracyBest];
	[self.locationManager setDistanceFilter: kCLDistanceFilterNone];
	[self.locationManager setDelegate: self];
		// set timer for stopping the location manager
	[self performSelector:@selector(locationManagerTimeoutHandler) withObject: nil afterDelay: HCLocationManagerTimeoutValue];
		// start location manager
	[self setFoundLocation: NO];
	[self setLocationServiceInProgress: YES];
	[[self locationManager] startUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate safetynet


	// if this selector is called the location manager should be terminated because it takes too long
- (void) locationManagerTimeoutHandler{
	
	DLog(@"");
	
		// safetynet
	if(!self.foundLocation){
		
		[[self locationManager] stopUpdatingLocation];
		[[self activityIndicator] stopAnimating];
		[self setLocationServiceInProgress: NO];
		[HCStaticMethods showWarningMessage: NSLocalizedString(@"Timeout, can not get a location!",nil)];
	}
}


#pragma mark - CLLocationManagerDelegate Protocol

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
	
	DLog(@"");
	
	if(status==kCLAuthorizationStatusDenied){
		[[self locationManager] stopUpdatingLocation];
		[[self activityIndicator] stopAnimating];
		[self setLocationServiceInProgress: NO];
			// cancel the timeout timer
		[NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(locationManagerTimeoutHandler) object: nil];

	}
	
}


- (void) locationManager:(CLLocationManager *)manager
		didFailWithError:(NSError *)error{
	
	DLog(@"error=%@", [error localizedDescription]);
	
	/*
	 //CLError.h
	 typedef enum {
	 kCLErrorLocationUnknown  = 0,         // location is currently unknown, but CL will keep trying
	 kCLErrorDenied,                       // CL access has been denied (eg, user declined location use)
	 kCLErrorNetwork,                      // general, network-related error
	 kCLErrorHeadingFailure,               // heading could not be determined
	 kCLErrorRegionMonitoringDenied,       // Location region monitoring has been denied by the user
	 kCLErrorRegionMonitoringFailure,      // A registered region cannot be monitored
	 kCLErrorRegionMonitoringSetupDelayed, // CL could not immediately initialize region monitoring
	 kCLErrorRegionMonitoringResponseDelayed, // While events for this fence will be delivered, delivery will not occur immediately
	 kCLErrorGeocodeFoundNoResult,         // A geocode request yielded no result
	 kCLErrorGeocodeFoundPartialResult,    // A geocode request yielded a partial result
	 kCLErrorGeocodeCanceled               // A geocode request was cancelled
	 } CLError;
	 */
	
	[[self activityIndicator] stopAnimating];
	[self setLocationServiceInProgress: NO];
		// cancel the timeout timer
	[NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(locationManagerTimeoutHandler) object: nil];

	
	switch(error.code){
			
		case kCLErrorLocationUnknown:
			[HCStaticMethods showWarningMessage: NSLocalizedString(@"kCLErrorLocationUnknown", nil)];
			break;
			
		case kCLErrorDenied:
			[HCStaticMethods showWarningMessage: NSLocalizedString(@"kCLErrorDenied", nil)];
			break;			
			
		default:
			ALog(@"error=%@", [error localizedDescription]);
			break;
	}
	
	
	
}


	// We have our position
- (void) locationManager:(CLLocationManager *)manager
	 didUpdateToLocation:(CLLocation *)newLocation
			fromLocation:(CLLocation *)oldLocation{
	
	DLog(@"self.foundLocation=%@", (self.foundLocation==YES?@"YES":@"NO"));
		// save power, stop locating the device
	[manager stopUpdatingLocation];
	
	if(self.foundLocation==NO){
			// if the timeout timer fires right now, it knows that we had success
		[self setFoundLocation: YES];
			// cancel the timeout timer
		[NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(locationManagerTimeoutHandler) object: nil];
			
		[[self activityIndicator] stopAnimating];
		
			// print the coordinates
		[[self textViewMessageBody] setText: [NSString stringWithFormat:@"%@\n%@:\n%@ %+.6f, %@ %+.6f\n%@\n%@\n%@\n",
											  self.textViewMessageBody.text,
											  NSLocalizedString(@"current location",nil),
											  NSLocalizedString(@"latitude",nil),
											  newLocation.coordinate.latitude,
											  NSLocalizedString(@"longitude",nil),
											  newLocation.coordinate.longitude,
											  [HCStaticMethods coordinatesInDegreeAndArcMinutesForLatitude: newLocation.coordinate.latitude
																							  andLongitude: newLocation.coordinate.longitude],
											  [HCStaticMethods coordinatesInDegreeAndArcMinutesAndArcSecondsForLatitude: newLocation.coordinate.latitude
																										   andLongitude: newLocation.coordinate.longitude],
											  [HCStaticMethods googleMapsFormattedURLForLatitude: newLocation.coordinate.latitude
																					andLongitude: newLocation.coordinate.longitude]
											  
											  ]];
		[self setLocationServiceInProgress: NO];
	}
}


#pragma mark - HCUIPopoverViewControllerDelegate Protocol

- (NSArray*)addButtonsToContentViewForPopOverViewController: (HCUIPopoverViewController*) aPopoverViewController{
	
	DLog(@"");

	NSArray *buttonArray = nil;
	
	if(aPopoverViewController == self.toolPopOverViewController){
		CGRect phoneFrame = CGRectMake(0,0,38,38);
		
		HCUIButton *button1 = [HCUIButton buttonWithType: UIButtonTypeCustom];
		[button1 setDeviceIndependentFrameBasedOnPhoneFrame: phoneFrame];
		[button1 setDeviceIndependentImageOfType: HCButtonImageGPS];
		[button1 setTag: 1];
		[button1 setEnabled: ([CLLocationManager locationServicesEnabled]==YES && [CLLocationManager authorizationStatus]!=kCLAuthorizationStatusRestricted && [self locationServiceInProgress]==NO)];
		[button1 setShowsTouchWhenHighlighted: YES];
		
		HCUIButton *button2 = [HCUIButton buttonWithType: UIButtonTypeCustom];
		[button2 setDeviceIndependentFrameBasedOnPhoneFrame: phoneFrame];
		[button2 setDeviceIndependentImageOfType: HCButtonImageCamera];
		[button2 setTag: 2];
		[button2 setShowsTouchWhenHighlighted: YES];
#if TARGET_IPHONE_SIMULATOR
		DLog(@"iPhone simulator, no checking of camera");
#else
		[button2 setEnabled: ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]==YES)];
#endif
		
		
		buttonArray = [[NSArray alloc] initWithObjects: button1, button2, nil];
		
	}
	
	return [buttonArray autorelease];
}


- (void)popoverViewController: (HCUIPopoverViewController*) aPopoverViewController buttonTouched: (id) sender{
	
	DLog(@"popoverViewControllerButtonTouched, tag=%i", [sender tag]);

	switch ([sender tag]) {
		case 1:
			
			[self showGPSPosition];
			break;
			
		case 2:
			
			[self showCameraViewController];
			break;
			
		default:
			break;
	}
	
		// whatever button was touched, dismiss the popover
	[[self toolPopOverViewController] dismissHCUIPopoverViewControllerFromSuperViewAnimated: NO];
}


- (void)dismissPopoverViewController: (HCUIPopoverViewController*) aPopoverViewController animated: (BOOL) isAnimated{
	
	DLog(@"");
	
	[[self toolPopOverViewController] dismissHCUIPopoverViewControllerFromSuperViewAnimated: YES];
	if([self currentFirstResponder] != nil){
		if([[self currentFirstResponder] respondsToSelector: @selector(becomeFirstResponder)]){
			DLog(@"currentFirstResponder respondsToSelector 'becomeFirstResponder'");
			[[self currentFirstResponder] performSelector: @selector(becomeFirstResponder)];
		}
	}
	
}


#pragma mark - camera viewcontroller


- (void)showCameraViewController{

	DLog(@"");
	
#if TARGET_IPHONE_SIMULATOR
	DLog(@"iPhone simulator, no checking for camera");
#else
	if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == NO){
		[HCStaticMethods showWarningMessage: NSLocalizedString(@"nocamera", nil)];
		return;
	}
#endif

	
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	BOOL deviceHasFlashLight = [UIImagePickerController isFlashAvailableForCameraDevice: UIImagePickerControllerCameraDeviceRear]==YES ||
			[UIImagePickerController isFlashAvailableForCameraDevice: UIImagePickerControllerCameraDeviceFront]==YES;
	DLog(@"deviceHasFlashLight=%@", (deviceHasFlashLight==YES?@"YES":@"NO"));

#if TARGET_IPHONE_SIMULATOR
	DLog(@"iPhone simulator, no settings for UIImagePickerController");
#else
	DLog(@"Device: %@", [[UIDevice currentDevice] model]);
		// we have checked existance of camera before
	[imagePickerController setSourceType: UIImagePickerControllerSourceTypeCamera];
		// now check for mediatypes that can be captured by this camera
	
	NSArray *availableMediaTypes = [UIImagePickerController
					  availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];

	if(![availableMediaTypes containsObject: (NSString *)kUTTypeImage]){
		[HCStaticMethods showWarningMessage: NSLocalizedString(@"nokUTTypeImage", nil)];
		[imagePickerController release];
		return;
	}

	// now we are sure that we have a camera and that it can take still images.
	// let's check if the camera can take videos
	if([availableMediaTypes containsObject: (NSString *)kUTTypeMovie]){
		if(deviceHasFlashLight == YES){
			// camera can capture movies and has a flashlight, so we can use torch mode

			//TODO it seems that we can not use the UIImagePickerController for the wanted effect :-/
		}
	}

	[imagePickerController setMediaTypes: [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil]];
	[imagePickerController setShowsCameraControls: YES];
	[imagePickerController setAllowsEditing: NO];
	
#endif
	
	
	[imagePickerController setDelegate: self];

	if(deviceHasFlashLight == YES){
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		UIImagePickerControllerCameraFlashMode flashMode = [HCUISegmentedControl cameraFlashModeForSelectedSegment: [defaults integerForKey: HCPhotoFlashSegmentKey]];
		[imagePickerController setCameraFlashMode: flashMode];
	}
	
	DLog(@"imagePickerController=%@", imagePickerController)

	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
		[self setIpadPopoverController: [[UIPopoverController alloc] initWithContentViewController: imagePickerController]];
		[[self ipadPopoverController] setDelegate: self];
		[self.ipadPopoverController presentPopoverFromRect: self.buttonToolPopoverLandscape.frame 
													inView: self.view
								  permittedArrowDirections: UIPopoverArrowDirectionAny 
												  animated: YES];
	}
	else{
		[self presentModalViewController: imagePickerController animated: YES];
	}
	[imagePickerController release];
	
}


#pragma mark - UIPopoverControllerDelegate Protocol

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
	
	DLog(@"");
	if(self.ipadPopoverController == popoverController) [self setIpadPopoverController: nil];
	if([self currentFirstResponder] != nil){
		if([[self currentFirstResponder] respondsToSelector: @selector(becomeFirstResponder)]){
			DLog(@"currentFirstResponder respondsToSelector 'becomeFirstResponder'");
			[[self currentFirstResponder] performSelector: @selector(becomeFirstResponder)];
		}
	}
}


- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
	
	DLog(@"");
	return YES;
}


#pragma mark - UIImagePickerControllerDelegate Protocol

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

	DLog(@"");
	[self dismissImagePickerController: picker animated: YES];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	
	DLog(@"");
	
	HCMailAttachment *mailAttachment = [[HCMailAttachment alloc] init];
	[mailAttachment setAttachmentType: HCAttachmentUIImagePicker];
	[mailAttachment setAttachmentInfoDictionary: info];
	
	
		// TODO: check if the media should be saved to the camera roll (settings?)
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if([defaults boolForKey: HCSavePhotosKey]==YES){
		DLog(@"image should be saved to Camera Roll");
		UIImage *editedIage = [info objectForKey: UIImagePickerControllerEditedImage];
		if(!editedIage) editedIage = [info objectForKey: UIImagePickerControllerOriginalImage];
		
		
		if(editedIage){
						
			ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];  
				// save the image to the Camera Roll, block gets called after completion
			DLog(@"save the image to the Camera Roll");
			[assetsLibrary writeImageToSavedPhotosAlbum: [editedIage CGImage]
											orientation: (ALAssetOrientation)[editedIage imageOrientation]
										completionBlock: nil];
			[assetsLibrary release];
		}
		
	}
	
	
	if([self attachments]) [[self attachments] addObject: mailAttachment];
	else [self setAttachments: [[NSMutableArray alloc] initWithObjects: mailAttachment, nil]];

	[mailAttachment release];
	
	[self dismissImagePickerController: picker animated: YES];

}


- (void)dismissImagePickerController:(UIImagePickerController *)picker animated: (BOOL) animated{
	
	DLog(@"");
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
		
		[[self ipadPopoverController] dismissPopoverAnimated: animated];
		[[self ipadPopoverController] release];
			// no viewWillAppear or viewDidAppear is thrown, check for new values for ourself
		[self setViewUserInteractionEnabledStates];
	}
	else{
		[picker dismissModalViewControllerAnimated: YES];
		[self setIpadPopoverController: nil];
	}

}


#pragma mark UINavigationControllerDelegate Protocol

- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	
	DLog(@"");

}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

	DLog(@"");
	
}


#pragma mark - Recipient checks

- (BOOL) allRecipientsAreInvalid{
	
	BOOL recipient1Valid=[HCUITextField isValidRecipientWithNumber: 1];
	BOOL recipient2Valid=[HCUITextField isValidRecipientWithNumber: 2];
	BOOL recipient3Valid=[HCUITextField isValidRecipientWithNumber: 3];
	BOOL recipient4Valid=[HCUITextField isValidRecipientWithNumber: 4];
	
	return !(recipient1Valid==YES || recipient2Valid==YES || recipient3Valid==YES || recipient4Valid==YES);

}


#pragma mark - firstResponder

- (void) checkFirstResponder{

	DLog(@"");
	
	if(self.ipadPopoverController.isPopoverVisible==YES){
		DLog(@"popover is visible, no checking for first responder");
		return;
	}
	
		// load the defaults/user values
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	DLog(@"currentFirstResponder %@", [self currentFirstResponder]);

	
	if([self currentFirstResponder] != nil){
		if([[self currentFirstResponder] respondsToSelector: @selector(becomeFirstResponder)]){

			DLog(@"currentFirstResponder respondsToSelector 'becomeFirstResponder'");

			[[self currentFirstResponder] performSelector: @selector(becomeFirstResponder)];
		}
		else{

			DLog(@"currentFirstResponder does not respond to selector 'becomeFirstResponder'");

				// fallback
			if([[self textViewMessageBody] hasText]){
				[[self textViewMessageBody] becomeFirstResponder];
				[self setCurrentFirstResponder: [self textViewMessageBody]];
			}
			else{
				[[self textFieldSubject] becomeFirstResponder];
				[self setCurrentFirstResponder: [self textFieldSubject]];
			}
		}
		[self setTextViewFrameSize];	
	}
	else{
			// show keyboard if desired
		if([defaults boolForKey: HCShowKeyboardKey] && !self.allRecipientsAreInvalid){

			DLog(@"textFieldSubject.becomeFirstResponder");

			
			[[self textFieldSubject] becomeFirstResponder];
			[self setCurrentFirstResponder: [self textFieldSubject]];
		}
		else{
			[self setTextViewFrameSize];
		}
	}

}


#pragma mark - HCAttachmentViewDelegate Protocol

- (void) attachmentButtonWasTouched: (id) sender{
	
	DLog(@"");
	HCManageAttachmentsUIViewController* manageAttachmentsUIViewController = [[HCManageAttachmentsUIViewController alloc] initWithNibName:@"HCManageAttachmentsUIViewController" bundle: nil];
	[manageAttachmentsUIViewController setDelegate: self];
	[manageAttachmentsUIViewController setAttachmentsArray: self.attachments];
	[manageAttachmentsUIViewController setModalPresentationStyle: UIModalPresentationFullScreen];
	[self presentModalViewController: manageAttachmentsUIViewController animated: YES];		
	[manageAttachmentsUIViewController release];
}


#pragma mark - HCMailAttachmentsUITableViewControllerDelegate Protocol

- (void)manageAttachmentsUIViewControllerDidFinish: (HCManageAttachmentsUIViewController*) controllerThatFinished{

	DLog(@"");
	[self dismissViewControllerAnimated: YES completion: nil];
}


#pragma mark - content & visibility

- (void)trashContentAndCheckSettings: (BOOL) checkSettings{
	
	DLog(@"");
	
		// delete the message in the UITextView
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if(checkSettings && [defaults boolForKey: HCAutoDeleteKey]==NO) return;
	
	[[self textFieldSubject] setText: [defaults objectForKey: HCMailSubjectKey]];
	[[self textViewMessageBody] setText: @""];
	if([self attachments]) [[self attachments] removeAllObjects];
	
	[self setViewUserInteractionEnabledStates];
}


- (void)restoreUserSession{
	
	DLog(@"");
	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	self.textViewMessageBody.text=[defaults objectForKey: HCTextViewMailBodyKey];
	self.textFieldSubject.text=[defaults objectForKey: HCTextViewMailSubjectKey];
	if(self.textFieldSubject.text== nil || self.textFieldSubject.text.length==0) [[self textFieldSubject] setText: [defaults objectForKey: HCMailSubjectKey]];

	[self setOldMailSubject: [defaults objectForKey: HCMailSubjectKey]];
	
	NSMutableArray *restoredAttachments = [PersistanceHandler decodeObjectFromNSDocumentDirectoryWithFileName: HCAttachmentsStorageFileName];
	if(restoredAttachments){
		DLog(@"found attachments on filesystem");
		[self setAttachments: restoredAttachments];	
	}
	else [[self attachments] removeAllObjects];
	
}


	// selector checks if all mail receipients are well set and if location services are available
- (void) setViewUserInteractionEnabledStates{
	
	DLog(@"");
	
		// the first sendMail button is used in every cnnfiguration
	[[self buttonSendMail1] setEnabled: [HCUITextField isValidRecipientWithNumber: 1]==YES];
	[[self buttonSendMail1] setNeedsDisplay];
	
		// buttons 2-4 are only directly visible on iPad
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
		
		[[self buttonSendMail2] setEnabled: [HCUITextField isValidRecipientWithNumber: 2]==YES];
		[[self buttonSendMail2] setNeedsDisplay];
		
		[[self buttonSendMail3] setEnabled: [HCUITextField isValidRecipientWithNumber: 3]==YES];
		[[self buttonSendMail3] setNeedsDisplay];		
		
		[[self buttonSendMail4] setEnabled: [HCUITextField isValidRecipientWithNumber: 4]==YES];
		[[self buttonSendMail4] setNeedsDisplay];
		
	}else{
		
			// no two buttons can be adressed by the same outlet so we have two buttons here that do the same
		[[self buttonSendMail1Landscape] setEnabled: [HCUITextField isValidRecipientWithNumber: 1]==YES];
		[[self buttonSendMail1Portrait] setEnabled: [HCUITextField isValidRecipientWithNumber: 1]==YES];
		[[self buttonSendMail1Portrait] setNeedsDisplay];
		[[self buttonSendMail1Landscape] setNeedsDisplay];
		
			// the button with the envelope is only shown on iPhone
			// could do this in one step but it's more readable this way
		bool showMailReceivers = [HCUITextField isValidRecipientWithNumber: 2]==YES || [HCUITextField isValidRecipientWithNumber: 3]==YES || [HCUITextField isValidRecipientWithNumber: 4]==YES;
		
		[[self buttonShowMailReceiversPortrait] setEnabled: showMailReceivers];
		[[self buttonShowMailReceiversPortrait] setNeedsDisplay];
		[[self buttonShowMailReceiversLandscape] setEnabled: showMailReceivers];
		[[self buttonShowMailReceiversLandscape] setNeedsDisplay];

		DLog(@"showMailReceivers: %@", (showMailReceivers ? @"YES" : @"NO"));
		DLog(@"self.buttonShowMailReceiversPortrait.isHidden: %@", (self.buttonShowMailReceiversPortrait.isHidden ? @"YES" : @"NO"));
		DLog(@"self.buttonShowMailReceiversLandscape.isHidden: %@", (self.buttonShowMailReceiversLandscape.isHidden ? @"YES" : @"NO"));
		
	}
	
	
	[[self viewHelpNote] setHidden: (self.allRecipientsAreInvalid==NO)];
	[[self viewHelpNote] setNeedsDisplay];
	
	if(self.allRecipientsAreInvalid==YES){
			// help note is shown, disable all other buttons
		[[self buttonTrash] setEnabled: NO];
		[[self buttonToolPopoverLandscape] setEnabled: NO];
		[[self buttonToolPopoverPortrait] setEnabled: NO];
		
	}
	else{
			// at least one mail recipient is valid, show trashcan button and location services evntually
		[[self buttonTrash] setEnabled: YES];
		[[self buttonToolPopoverLandscape] setEnabled: YES];
		[[self buttonToolPopoverPortrait] setEnabled: YES];
		
		[self performSelector:@selector(checkFirstResponder) withObject: nil afterDelay: HCFirstResponderDelay];
	}
	[[self buttonTrash] setNeedsDisplay];
	[[self buttonToolPopoverLandscape] setNeedsDisplay];
	[[self buttonToolPopoverPortrait] setNeedsDisplay];
	
		// check interface orientation
		// check the coming interfaceOrientaion to hide/show the right buttons
	if(UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])){
		
		DLog(@"UIInterfaceOrientationIsPortrait");
		
		[[self landscapeNavigationView] setHidden: YES];
		[[self portraitNavigationView] setHidden: NO];		
	}
	else{
		
		DLog(@"UIInterfaceOrientationIsLandscape");
		[[self landscapeNavigationView] setHidden: NO];
		[[self portraitNavigationView] setHidden: YES];
	}
	
	[[self textFieldSubject] toggleLeftAttachmentViewWithText: [NSString stringWithFormat: @"%i", self.attachments.count] isVisible: (self.attachments.count > 0)];
	
}


@end
