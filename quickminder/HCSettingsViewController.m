//
//  HCFlipsideViewController.m
//  quickminder
//
//  Created by Putze Sven on 21.12.11.
//  Copyright (c) 2011 hardcodes.de. All rights reserved.
//

#import "HCSettingsViewController.h"
#import "HCDefaultStrings.h"
#import "HCStaticMethods.h"
#import "HCMainViewController.h"
#import "HCOverlayWarningView.h"
#import "HCUITextField.h"
#import "UIScrollView+CalculateContentSize.h"
#import "HCMailConfigItem.h"

#pragma mark - private interface

@interface HCSettingsViewController()

	@property (nonatomic, readwrite) BOOL keyboardIsShown;
	@property (retain, nonatomic) UITextField *firstResponder;
	@property (assign, nonatomic) NSInteger addressbookLookupButtonTag;
	@property (retain, nonatomic) HCUIPopoverViewController *helpNotePopoverController;
	@property (assign, nonatomic) NSInteger helpNoteTag;


@end


#pragma mark - implementation

@implementation HCSettingsViewController {
@private
	HCUIPopoverViewController *_helpNotePopoverController;
	NSInteger _helpNoteTag;
}


@synthesize delegate = _delegate;
@synthesize textFieldMailReceiver1 = _textFieldMailReceiver1;
@synthesize textFieldMailReceiver2 = _textFieldMailReceiver2;
@synthesize textFieldMailReceiver3 = _textFieldMailReceiver3;
@synthesize textFieldMailReceiver4 = _textFieldMailReceiver4;
@synthesize textFieldMailSubject = _textFieldMailSubject;
@synthesize textFieldMailAlias1 = _textFieldMailAlias1;
@synthesize textFieldMailAlias2 = _textFieldMailAlias2;
@synthesize textFieldMailAlias3 = _textFieldMailAlias3;
@synthesize textFieldMailAlias4 = _textFieldMailAlias4;
@synthesize switchWordCorrection = _switchWordCorrection;
@synthesize scrollView = _scrollViewSettings;
@synthesize switchAutoDelete = _switchAutoDelete;
@synthesize switchShowKeyboard = _switchShowKeyboard;
@synthesize textFieldSendMailButtonLabel = _textFieldSendMailButtonLabel;
@synthesize switchAutoSendMail = _switchAutoSendMail;
@synthesize viewMailAddress1 = _viewMailAddress1;
@synthesize viewMailAddress2 = _viewMailAddress2;
@synthesize viewMailAddress3 = _viewMailAddress3;
@synthesize viewMailAddress4 = _viewMailAddress4;
@synthesize switchSavePhotos = _switchSavePhotos;
@synthesize horizontalSliderCompressPhotos = _horizontalSliderCompressPhotos;
@synthesize segmentedControlFlash = _segmentedControlFlash;
@synthesize horizontalSliderResizePhotos = _horizintalSliderResizePhotos;
@synthesize longPressGestureRecognizer = _longPressGestureRecognizer;
@synthesize keyboardIsShown = _keyboardIsShown;
@synthesize firstResponder = _firstResponder;
@synthesize addressbookLookupButtonTag = _addressbookLookupButtonTag;
@synthesize helpNotePopoverController = _helpNotePopoverController;
@synthesize helpNoteTag = _helpNoteTag;



#pragma mark - init

- (void)awakeFromNib
{
	DLog(@"");
	
    [super awakeFromNib];
}


- (void)dealloc {
	
	DLog(@"");
	
    [_textFieldMailReceiver1 release];
    [_textFieldMailReceiver2 release];
	[_textFieldMailReceiver3 release];
	[_textFieldMailReceiver4 release];
    [_textFieldMailSubject release];
    [_switchWordCorrection release];
    [_scrollViewSettings release];
	[_firstResponder release];
	[_switchAutoDelete release];
    [_switchShowKeyboard release];
    [_textFieldMailAlias1 release];
	[_textFieldMailAlias2 release];
	[_textFieldMailAlias3 release];
	[_textFieldMailAlias4 release];
	[_viewMailAddress1 release];
	[_viewMailAddress2 release];
	[_viewMailAddress3 release];
	[_viewMailAddress4 release];
	[_textFieldSendMailButtonLabel release];
	[_switchAutoSendMail release];
    [_switchSavePhotos release];
    [_horizontalSliderCompressPhotos release];
    [_segmentedControlFlash release];
    [_horizintalSliderResizePhotos release];
	[_helpNotePopoverController release];
	[_longPressGestureRecognizer release];
	[super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	DLog(@"");
	
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	// register for keyboard notifications
	
}


- (void)viewDidUnload
{
	DLog(@"");
	
    [self setTextFieldMailReceiver1:nil];
    [self setTextFieldMailReceiver2:nil];
    [self setTextFieldMailSubject:nil];
    [self setSwitchWordCorrection:nil];
    [self setScrollView:nil];
	[self setSwitchAutoDelete:nil];
	[self setTextFieldMailReceiver3:nil];
	[self setTextFieldMailReceiver4:nil];
    [self setSwitchShowKeyboard:nil];
    [self setTextFieldMailAlias1:nil];
	[self setTextFieldMailAlias2:nil];
	[self setTextFieldMailAlias3:nil];
	[self setTextFieldMailAlias4:nil];
	[self setViewMailAddress1:nil];
	[self setViewMailAddress2:nil];
	[self setViewMailAddress3:nil];
	[self setViewMailAddress4:nil];
	[self setTextFieldSendMailButtonLabel:nil];
	[self setSwitchAutoSendMail:nil];
	[self setFirstResponder: nil];
    [self setSwitchSavePhotos:nil];
    [self setHorizontalSliderCompressPhotos:nil];
    [self setSegmentedControlFlash:nil];
    [self setHorizontalSliderResizePhotos:nil];
	[self setLongPressGestureRecognizer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)didReceiveMemoryWarning
{
	DLog(@"");
	
    [super didReceiveMemoryWarning];
		// Release any cached data, images, etc that aren't in use.
}


- (void)viewWillAppear:(BOOL)animated
{
	
	DLog(@" delegate=%@", self.delegate);

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
		// these values are not initialized when the view is loaded because it may stay in memory
		// and should represent the stored data at any time the user comes here again
		// enter textView and exit via button without hitting "done" on the keyboard = not stored data
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[[self textFieldMailReceiver1] setText: [defaults objectForKey: HCMailReceiver1Key]];
	[[self textFieldMailReceiver2] setText: [defaults objectForKey: HCMailReceiver2Key]];
	[[self textFieldMailAlias1] setText: [defaults objectForKey: HCMailReceiverAlias1Key]];
	[[self textFieldMailAlias2] setText: [defaults objectForKey: HCMailReceiverAlias2Key]];
	[[self textFieldMailReceiver3] setText: [defaults objectForKey: HCMailReceiver3Key]];
	[[self textFieldMailReceiver4] setText: [defaults objectForKey: HCMailReceiver4Key]];
	[[self textFieldMailAlias3] setText: [defaults objectForKey: HCMailReceiverAlias3Key]];
	[[self textFieldMailAlias4] setText: [defaults objectForKey: HCMailReceiverAlias4Key]];
	[[self textFieldMailSubject] setText: [defaults objectForKey: HCMailSubjectKey]];
	[[self switchWordCorrection] setOn: [defaults boolForKey: HCWordCorrectionKey]];
	[[self switchAutoDelete] setOn: [defaults boolForKey: HCAutoDeleteKey]];
	[[self switchShowKeyboard] setOn: [defaults boolForKey: HCShowKeyboardKey]];
	[[self textFieldSendMailButtonLabel] setText: [defaults objectForKey: HCSendMailButtonLabelKey]];
	[[self switchAutoSendMail] setOn: [defaults boolForKey: HCAutoSendMailKey]];
	[[self switchSavePhotos] setOn: [defaults boolForKey: HCSavePhotosKey]];
	[[self horizontalSliderCompressPhotos] setValue: [defaults floatForKey: HCPhotoCompressionKey]];
	[[self horizontalSliderResizePhotos] setValue: [defaults floatForKey: HCPhotoResizingKey]];
#if TARGET_IPHONE_SIMULATOR
	DLog(@"Simulator, will not check for camera");
#else
	[[self switchSavePhotos] setEnabled: ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]==YES)];
	[[self horizontalSliderCompressPhotos] setEnabled: self.switchSavePhotos.isEnabled];
	[[self horizontalSliderResizePhotos] setEnabled: self.switchSavePhotos.isEnabled];
#endif
	BOOL deviceHasFlashLight = [UIImagePickerController isFlashAvailableForCameraDevice: UIImagePickerControllerCameraDeviceRear]==YES ||
	[UIImagePickerController isFlashAvailableForCameraDevice: UIImagePickerControllerCameraDeviceFront]==YES;
	[[self segmentedControlFlash] setEnabled: deviceHasFlashLight];
	[[self segmentedControlFlash] setSelectedSegmentIndex: [defaults integerForKey: HCPhotoFlashSegmentKey]];
	
		// tell the scrollView about the contentSize
    [[self scrollView] SetCalculatedContentSize];
    
	DLog(@"self.scrollView.bounds.size: %@", NSStringFromCGSize(self.scrollView.bounds.size));
	DLog(@"self.scrollView.frame.size: %@", NSStringFromCGSize(self.scrollView.frame.size));
	DLog(@"self.scrollView.contentSize: %@", NSStringFromCGSize(self.scrollView.contentSize));
	
	[self setFirstResponder: nil];
	[self setKeyboardIsShown: NO];

	[self validateEachTextField];
}


- (void)viewDidAppear:(BOOL)animated
{
	
	DLog(@" delegate=%@", self.delegate);

    [super viewDidAppear:animated];

	
}


- (void)viewWillDisappear:(BOOL)animated
{

	DLog(@" delegate=%@", self.delegate);

	[super viewWillDisappear:animated];
	
		// unregister for keyboard notifications while not visible.
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardDidShowNotification
												  object:nil];
		// unregister for keyboard notifications while not visible.
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardDidHideNotification
												  object:nil];

	
}

- (void)viewDidDisappear:(BOOL)animated
{

	DLog(@"");
	
	[super viewDidDisappear:animated];
}


#pragma mark - Actions

- (IBAction)dismissViewControllerViaDelegate:(id)sender
{

	DLog(@"");
	
	if([self firstResponder]!=nil){
			// let keyboard go
		[[self firstResponder] resignFirstResponder];
			// check/save the values
		[self textFieldDidEndEditing: self.firstResponder];
	}
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		// sync defaults to disk
	[defaults synchronize];
		// tell the parentview to shut us down
    [self.delegate settingsViewControllerDidFinish:self];
}


- (IBAction)switchWordCorrectionChanged:(id)sender {

	DLog(@"");
	
		// load the defaults/user values
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool: [[self switchWordCorrection] isOn] forKey: HCWordCorrectionKey];

}


- (IBAction)switchAutoDeleteChanged:(id)sender {
	
	DLog(@"");
	
		// load the defaults/user values
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool: [[self switchAutoDelete] isOn] forKey: HCAutoDeleteKey];
	
}

- (IBAction)switchShowKeyboardChanged:(id)sender {
	
	DLog(@"");
	
		// load the defaults/user values
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool: [[self switchShowKeyboard] isOn] forKey: HCShowKeyboardKey];

}

- (IBAction)buttonLookupAddressbookTouched:(id)sender {
	
	DLog(@"");
	
		// save the tag of the button, so we know later on which address is meant
	UIButton *touchedButton = (UIButton *)sender;
	[self setAddressbookLookupButtonTag: touchedButton.tag];
	
	ABPeoplePickerNavigationController *pickerNavigationController = [[ABPeoplePickerNavigationController alloc] init];
    pickerNavigationController.peoplePickerDelegate = self;
	pickerNavigationController.displayedProperties = [NSArray arrayWithObjects:
													  [NSNumber numberWithInt: kABPersonFirstNameProperty],
													  [NSNumber numberWithInt: kABPersonLastNameProperty],
													  [NSNumber numberWithInt: kABPersonPrefixProperty],
													  [NSNumber numberWithInt: kABPersonEmailProperty],
													  nil];
    [self presentModalViewController:pickerNavigationController animated:YES];	
    [pickerNavigationController release];
}

- (IBAction)switchAutoSendMailChanged:(id)sender {
	
	DLog(@"");
	
		// load the defaults/user values
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool: [[self switchAutoSendMail] isOn] forKey: HCAutoSendMailKey];

}


- (IBAction)buttonInfoTouched:(id)sender {
	
	DLog(@"");
	
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	
	NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
	NSString *build = [infoDictionary objectForKey:@"CFBundleVersion"];
	NSString *git = [[NSString alloc] initWithFormat:@"%@", [infoDictionary objectForKey:@"GIT_COMMIT_HASH"]];
	NSString *gitf = [git substringToIndex: 13];
	NSString *textExpanderLegalNote = NSLocalizedString(@"TextExpander", nil);
	NSString *softwareInfo = [NSString stringWithFormat:@"v%@.%@.%@\n\n%@", version, build, gitf, textExpanderLegalNote];
	UIAlertView* alertView = [[UIAlertView alloc]
							  initWithTitle: [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleName"]]
							  message: softwareInfo
							  delegate: self
							  cancelButtonTitle: NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	[git release];
	
}


- (IBAction)switchSavePhotosChanged:(id)sender {
	
	DLog(@"");
	
		// load the defaults/user values
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool: [[self switchSavePhotos] isOn] forKey: HCSavePhotosKey];

}


- (IBAction)horizontalSliderCompressPhotosValueChanged:(id)sender {
	
	DLog(@"slidervalues=%f", self.horizontalSliderCompressPhotos.value);
	
		// load the defaults/user values
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setFloat: self.horizontalSliderCompressPhotos.value forKey: HCPhotoCompressionKey];
}


- (IBAction)segmentedControlFlashValueChanged:(id)sender {
	
	DLog(@"selectedSegmentIndex=%i", self.segmentedControlFlash.selectedSegmentIndex);
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger: self.segmentedControlFlash.selectedSegmentIndex forKey: HCPhotoFlashSegmentKey];
}

- (IBAction)horizontalSliderResizePhotosValueChanged:(id)sender {

	DLog(@"slidervalues=%f", self.horizontalSliderResizePhotos.value);
	
		// load the defaults/user values
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setFloat: self.horizontalSliderResizePhotos.value forKey: HCPhotoResizingKey];

}


	// gets called via action to hide the keyboard
	// is called before textFieldDidEndEditing: (delegate)
- (IBAction)textFieldEditingDidEndOnExit:(id)sender {
	
	DLog(@" %@", sender);

}


#pragma mark - UITextFieldDelegate Protocol

- (void)textFieldDidBeginEditing:(UITextField *)textField{
		// gets called before textFieldWillBeginEditing
		// first anchor point, so mark this textField as firstResponder
		// value is used to know which textField must be scrolled into visible area
	[self setFirstResponder: textField];
	
	DLog(@" %@", self.firstResponder);
	
}

	// this is a delegate of the textfield
	// gets called after textFieldEditingDidEndOnExit:
- (void)textFieldDidEndEditing:(UITextField *)textField{

	DLog(@" %@", textField);

		// hide keyboard
	[textField resignFirstResponder];
	[self setFirstResponder: nil];

    [self validateContentOfTextField:textField writeBack: YES];
}


- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	
	DLog(@"");
	
	uint maxTextFieldLength;
	switch (textField.tag) {
		case 1:
		case 2:
		case 3:
		case 4:
			maxTextFieldLength=HCMaxTextFieldRecipientLength;
			break;
			
		default:
			maxTextFieldLength=HCMaxTextFieldAliasLength;
			break;
	}
	
		// check if the max. length is exceeded
	if(textField.text.length - range.length + string.length >= maxTextFieldLength) return NO;
	
	return YES;
}



#pragma mark - orientation change

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	DLog(@"");
	
    return YES;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{

	DLog(@"");
	
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	
#if DEBUG
	NSLog(@"HCSettingsViewController: didRotateFromInterfaceOrientation: %i, delegate=%@", fromInterfaceOrientation, self.delegate);
	NSLog(@"HCSettingsViewController: self.scrollView.bounds.size: %@", NSStringFromCGSize(self.scrollView.bounds.size));
	NSLog(@"HCSettingsViewController: self.scrollView.frame.size: %@", NSStringFromCGSize(self.scrollView.frame.size));
	NSLog(@"HCSettingsViewController: self.scrollView.contentSize: %@", NSStringFromCGSize(self.scrollView.contentSize));
#endif
	
	if(![self keyboardIsShown]){
			// scroll to top if keyboard is not shown
		[[self scrollView] setContentOffset: CGPointMake(0.0, 0.0) animated:YES];
	}
	

}


#pragma mark - keyboard handling

	// Called when the UIKeyboardDidShowNotification is sent.
- (void)UIKeyboardDidShowNotification: (NSNotification*) aNotification{
		
	DLog(@"");
	
	NSDictionary* info = [aNotification userInfo];
	CGRect keyboardRect = [ self.view convertRect: [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView: nil];

	if(![self keyboardIsShown]){		
			// enter only if the keyboard is not already shown
			// if it is shown and the user could taps a textView
			// the insets must not be set again

			// the keyboard is hiding the lower part of the scrollView
			// mark that area as a blind spot
		UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardRect.size.height, 0.0);
		[[self scrollView] setContentInset: contentInsets];
		[[self scrollView] setScrollIndicatorInsets: contentInsets];
		[self setKeyboardIsShown: YES];

		DLog(@"keyboard shown, setting contentInsets");

	}
	
		// we can only scroll to the textField if we have marked it as firstResponder
		// (just to be sure)
	if([self firstResponder]){
			// check if the superView from textField is now hidden by the keyboard
			// is the lower right corner of the view inside the remaining scrollView?
		CGRect remainingScrollViewBounds = self.scrollView.bounds;
		remainingScrollViewBounds.size.height -= keyboardRect.size.height;
		CGRect firstResponderFrameConverted = [self.scrollView convertRect: self.firstResponder.frame fromView: self.firstResponder.superview];
#if DEBUG
		NSLog(@"HCSettingsViewController: keyboardSize: %@", NSStringFromCGSize(keyboardRect.size));
		NSLog(@"HCSettingsViewController: scrollView.frame %@", NSStringFromCGRect(self.scrollView.frame));
		NSLog(@"HCSettingsViewController: remainingScrollViewBounds %@", NSStringFromCGRect(remainingScrollViewBounds));
		NSLog(@"HCSettingsViewController: firstResponder %@", self.firstResponder);
		NSLog(@"HCSettingsViewController: firstResponderFrameConverted: %@", NSStringFromCGRect(firstResponderFrameConverted));
		
#endif
		if (!CGRectIntersectsRect(remainingScrollViewBounds, firstResponderFrameConverted) &&
			!CGRectContainsRect(remainingScrollViewBounds, firstResponderFrameConverted)){
			
			DLog(@"must scroll the content");
			
				// the rect of the textView is not in the remaining rect of the scrollView
				// -> scroll the firstResponder into the visible area
			CGPoint scrollPoint = CGPointMake(0.0, (firstResponderFrameConverted.origin.y -remainingScrollViewBounds.size.height/2));
			[[self scrollView] setContentOffset: scrollPoint animated:YES];

			DLog(@"scrolled the content");
		}	
	}
}


- (void)UIKeyboardDidHideNotification: (NSNotification*) aNotification{
	
	DLog(@"");
	
	if([self keyboardIsShown]){
			// restore original size of the scrollView
		UIEdgeInsets contentInsets = UIEdgeInsetsZero;
		[[self scrollView] setContentInset: contentInsets];
		[[self scrollView] setScrollIndicatorInsets: contentInsets];
		
		[self setKeyboardIsShown: NO];

		DLog(@"keyboard hidden, reset contentInsets");

	}
}


#pragma mark - id<ABPeoplePickerNavigationControllerDelegate>


- (void)peoplePickerNavigationControllerDidCancel: (ABPeoplePickerNavigationController *)peoplePicker {

	DLog(@"");
	
    [self dismissModalViewControllerAnimated:YES];
	
}


- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	
	DLog(@"");
	
		// continue after selecting the person
    return YES;
	
}


- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
	  shouldContinueAfterSelectingPerson:(ABRecordRef)person
								property:(ABPropertyID)property
							  identifier:(ABMultiValueIdentifier)identifier{
	
	DLog(@"");
	
		// be sure that the user selected an email address
		// maybe we show more than email addresses in future to give th user a better
		// way to identify the right mail account
		// if the user did not touch a mail property he just must continue
	if(kABPersonEmailProperty != property) return YES;
		// so it is an email address
	NSString* firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	NSString* lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);

	ABMultiValueRef emailProperty = ABRecordCopyValue(person,property);
	NSString *mailRecipient = (NSString *)ABMultiValueCopyValueAtIndex(emailProperty,identifier);
	
	NSString* mailAlias = [NSString stringWithFormat: @"%@, %@", lastName, firstName];
	
	switch ([self addressbookLookupButtonTag]) {
		case 21:
			
			if(self.textFieldMailReceiver1.text.length==0) [[self textFieldMailReceiver1] setText: mailRecipient];
			else [[self textFieldMailReceiver1] setText: [NSString stringWithFormat: @"%@, %@", self.textFieldMailReceiver1.text, mailRecipient]];
			
			[self validateContentOfTextField: self.textFieldMailReceiver1 writeBack: YES];
				// don't change if there is already an alias
			if(self.textFieldMailAlias1.text.length==0){
				[[self textFieldMailAlias1] setText: mailAlias];
				[self validateContentOfTextField: self.textFieldMailAlias1 writeBack: YES];
			}
			
			break;
			
		case 22:
			
			if(self.textFieldMailReceiver2.text.length==0) [[self textFieldMailReceiver2] setText: mailRecipient];
			else [[self textFieldMailReceiver2] setText: [NSString stringWithFormat: @"%@, %@", self.textFieldMailReceiver2.text, mailRecipient]];

			[self validateContentOfTextField: self.textFieldMailReceiver2 writeBack: YES];
				// don't change if there is already an alias
			if(self.textFieldMailAlias2.text.length==0){
				[[self textFieldMailAlias2] setText: mailAlias];
				[self validateContentOfTextField: self.textFieldMailAlias2 writeBack: YES];
			}
			
			break;
			
		case 23:
			
			if(self.textFieldMailReceiver3.text.length==0) [[self textFieldMailReceiver3] setText: mailRecipient];
			else [[self textFieldMailReceiver3] setText: [NSString stringWithFormat: @"%@, %@", self.textFieldMailReceiver3.text, mailRecipient]];

			[self validateContentOfTextField: self.textFieldMailReceiver3 writeBack: YES];
				// don't change if there is already an alias
			if(self.textFieldMailAlias3.text.length==0){
				[[self textFieldMailAlias3] setText: mailAlias];
				[self validateContentOfTextField: self.textFieldMailAlias3 writeBack: YES];
			}
			
			break;
			
		case 24:
			
			if(self.textFieldMailReceiver4.text.length==0) [[self textFieldMailReceiver4] setText: mailRecipient];
			else [[self textFieldMailReceiver4] setText: [NSString stringWithFormat: @"%@, %@", self.textFieldMailReceiver4.text, mailRecipient]];

			[self validateContentOfTextField: self.textFieldMailReceiver4 writeBack: YES];
				// don't change if there is already an alias
			if(self.textFieldMailAlias4.text.length==0){
				[[self textFieldMailAlias4] setText: mailAlias];
				[self validateContentOfTextField: self.textFieldMailAlias4 writeBack: YES];
			}
			
			break;
			
		default:
				// should never happen
			break;
	}
	
	[firstName release];
	[lastName release];
	[mailRecipient release];
	
	[self dismissModalViewControllerAnimated:YES];
	[self setAddressbookLookupButtonTag: -1];
    return NO;
	
}

#pragma mark - content validation


- (void)validateContentOfTextField:(UITextField *)textField writeBack:(BOOL) writeBack{
	
	DLog(@"");
	
		// the textfield has lost its focus - now write the new content to user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL oneOreMoreValidMailRecipients;
		// TODO: extract part to method
	switch ([textField tag]) {
		case 1:
				// mailaddress #1
			[textField setText: [textField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
			oneOreMoreValidMailRecipients = ([(HCUITextField*)textField textHasOneValidMailRecipient]==YES || [(HCUITextField*)textField textHasMultipleValidMailRecipients]==YES);
			if(oneOreMoreValidMailRecipients==NO){
				self.textFieldMailAlias1.enabled=NO;
			}
			else{
				self.textFieldMailAlias1.enabled=YES;
				NSString *text = textField.text;
				text =[text stringByReplacingOccurrencesOfString: @", " withString: @","];
				text =[text stringByReplacingOccurrencesOfString: @"," withString: @", "];
				[textField setText: text];
				 
			}
			[(HCUITextField*)textField  toggleRightHCOverlayWarningViewWithText: NSLocalizedString(@"invalid email address(es)",nil) isVisible: (oneOreMoreValidMailRecipients==NO && textField.text.length>0)];
			[[self textFieldMailAlias1] toggleGroupLeftViewIsVisible: [(HCUITextField*)textField textHasMultipleValidMailRecipients]];
			if (writeBack==YES) [defaults setObject: textField.text forKey: HCMailReceiver1Key];
			break;
			
		case 2:
				// mailaddress #2
			[textField setText: [textField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
			oneOreMoreValidMailRecipients = ([(HCUITextField*)textField textHasOneValidMailRecipient]==YES || [(HCUITextField*)textField textHasMultipleValidMailRecipients]==YES);
			if(oneOreMoreValidMailRecipients==NO){
				self.textFieldMailAlias2.enabled=NO;
			}
			else{
				self.textFieldMailAlias2.enabled=YES;
				NSString *text = textField.text;
				text =[text stringByReplacingOccurrencesOfString: @", " withString: @","];
				text =[text stringByReplacingOccurrencesOfString: @"," withString: @", "];
				[textField setText: text];
			}
			[(HCUITextField*)textField  toggleRightHCOverlayWarningViewWithText: NSLocalizedString(@"invalid email address(es)",nil) isVisible: (oneOreMoreValidMailRecipients==NO && textField.text.length>0)];
			[[self textFieldMailAlias2] toggleGroupLeftViewIsVisible: [(HCUITextField*)textField textHasMultipleValidMailRecipients]];
			if (writeBack==YES) [defaults setObject: textField.text forKey: HCMailReceiver2Key];
			break;
			
		case 3:
				// mailaddress #3
			[textField setText: [textField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
			oneOreMoreValidMailRecipients = ([(HCUITextField*)textField textHasOneValidMailRecipient]==YES || [(HCUITextField*)textField textHasMultipleValidMailRecipients]==YES);
			if(oneOreMoreValidMailRecipients==NO){
				self.textFieldMailAlias3.enabled=NO;
			}
			else{
				self.textFieldMailAlias3.enabled=YES;
				NSString *text = textField.text;
				text =[text stringByReplacingOccurrencesOfString: @", " withString: @","];
				text =[text stringByReplacingOccurrencesOfString: @"," withString: @", "];
				[textField setText: text];
			}
			[(HCUITextField*)textField  toggleRightHCOverlayWarningViewWithText: NSLocalizedString(@"invalid email address(es)",nil) isVisible: (oneOreMoreValidMailRecipients==NO && textField.text.length>0)];
			[[self textFieldMailAlias3] toggleGroupLeftViewIsVisible: [(HCUITextField*)textField textHasMultipleValidMailRecipients]];
			if (writeBack==YES) [defaults setObject: textField.text forKey: HCMailReceiver3Key];
			break;
			
		case 4:
				// mailaddress #4
			[textField setText: [textField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
			oneOreMoreValidMailRecipients = ([(HCUITextField*)textField textHasOneValidMailRecipient]==YES || [(HCUITextField*)textField textHasMultipleValidMailRecipients]==YES);
			if(oneOreMoreValidMailRecipients==NO){
				self.textFieldMailAlias4.enabled=NO;
			}
			else{
				self.textFieldMailAlias4.enabled=YES;
				NSString *text = textField.text;
				text =[text stringByReplacingOccurrencesOfString: @", " withString: @","];
				text =[text stringByReplacingOccurrencesOfString: @"," withString: @", "];
				[textField setText: text];
			}
			[(HCUITextField*)textField  toggleRightHCOverlayWarningViewWithText: NSLocalizedString(@"invalid email address(es)",nil) isVisible: (oneOreMoreValidMailRecipients==NO && textField.text.length>0)];
			[[self textFieldMailAlias4] toggleGroupLeftViewIsVisible: [(HCUITextField*)textField textHasMultipleValidMailRecipients]];
			if (writeBack==YES) [defaults setObject: textField.text forKey: HCMailReceiver4Key];
			break;
			
		case 5:
				// mailsubject
			if (writeBack==YES) [defaults setObject: textField.text forKey: HCMailSubjectKey];
			break;
			
		case 11:
			if (writeBack==YES) [defaults setObject: textField.text forKey: HCMailReceiverAlias1Key];
			[(HCUITextField*)textField  toggleRightHCOverlayWarningViewWithText: NSLocalizedString(@"a little too short",nil) isVisible: ([HCMailConfigItem mailRecipientAliasIsValid: textField.text]==NO)];
				// mailalias #1
			break;
		case 12:
			if (writeBack==YES) [defaults setObject: textField.text forKey: HCMailReceiverAlias2Key];
			[(HCUITextField*)textField  toggleRightHCOverlayWarningViewWithText: NSLocalizedString(@"a little too short",nil) isVisible: ([HCMailConfigItem mailRecipientAliasIsValid: textField.text]==NO)];
				// mailalias #2
			break;
		case 13:
			if (writeBack==YES) [defaults setObject: textField.text forKey: HCMailReceiverAlias3Key];
			[(HCUITextField*)textField  toggleRightHCOverlayWarningViewWithText: NSLocalizedString(@"a little too short",nil) isVisible: ([HCMailConfigItem mailRecipientAliasIsValid: textField.text]==NO)];
				// mailalias #3
			break;
		case 14:
			if (writeBack==YES) [defaults setObject: textField.text forKey: HCMailReceiverAlias4Key];
			[(HCUITextField*)textField  toggleRightHCOverlayWarningViewWithText: NSLocalizedString(@"a little too short",nil) isVisible: ([HCMailConfigItem mailRecipientAliasIsValid: textField.text]==NO)];
				// mailalias #4
			break;
			
		case 666:
			if (writeBack==YES) [defaults setObject: textField.text forKey: HCSendMailButtonLabelKey];
				// label from sendmail button
			break;
			
		default:
				// should never happen
			break;
	}
}


- (void)validateEachTextField{
	
	DLog(@"");
	
	[self validateContentOfTextField: self.textFieldMailReceiver1 writeBack: NO];
	[self validateContentOfTextField: self.textFieldMailReceiver2 writeBack: NO];
	[self validateContentOfTextField: self.textFieldMailReceiver3 writeBack: NO];
	[self validateContentOfTextField: self.textFieldMailReceiver4 writeBack: NO];
	
}


#pragma mark - HCUIPopoverViewControllerDelegate Protocol

- (NSArray *)addButtonsToContentViewForPopOverViewController:(HCUIPopoverViewController *)aPopoverViewController {
	// so far we think there will only be the "help note popover", that does not need any preconfigured buttons
	return nil;
}

- (void)popoverViewController:(HCUIPopoverViewController *)aPopoverViewController buttonTouched:(id)sender {
	// should not happen because we don not provide preconfigured buttons in the popover

}

- (void)dismissPopoverViewController:(HCUIPopoverViewController *)aPopoverViewController animated:(BOOL)isAnimated {

	DLog(@"");

	//[[self toolPopOverViewController] dismissHCUIPopoverViewControllerFromSuperViewAnimated: YES];

}

- (UIView *)contentViewForPopOverViewController:(HCUIPopoverViewController *)aPopoverViewController {

	// TODO check which button was touched long to provide the correct helpmessage
	return nil;
}


#pragma mark - UIGestureRecognizerDelegate Protocol

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

	if (gestureRecognizer == [self longPressGestureRecognizer]) return YES;
	return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

	// The default implementation returns NO—no two gestures can be recognized simultaneously.
	return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

	if (gestureRecognizer == [self longPressGestureRecognizer]) return YES;
	return NO;
}



@end
