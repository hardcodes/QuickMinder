//
//  HCPortraitSendMailViewContoller.m
//  quickminder
//
//  Created by Putze Sven on 25.12.11.
//  Copyright (c) 2011 hardcodes.de. All rights reserved.
//

#import "HCMoreRecepientsSendMailViewContoller.h"
#import "HCDefaultStrings.h"
#import "HCStaticMethods.h"
#import "HCMainViewController.h"
#import "HCUITextField.h"


#pragma mark - implementation

@implementation HCMoreRecepientsSendMailViewContoller

@synthesize delegate = _delegate;
@synthesize buttonSendMail1 = _buttonSendMail1;
@synthesize buttonSendMail2 = _buttonSendMail2;
@synthesize buttonSendMail3 = _buttonSendMail3;
@synthesize buttonSendMail4 = _buttonSendMail4;

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)dealloc {
	[_buttonSendMail1 release];
	[_buttonSendMail2 release];
    [_buttonSendMail3 release];
    [_buttonSendMail4 release];
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
	[self setButtonSendMail1:nil];
	[self setButtonSendMail2:nil];
    [self setButtonSendMail3:nil];
    [self setButtonSendMail4:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (void) viewWillAppear:(BOOL)animated{
	
	DLog(@"");

		// load the defaults/user values
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	[[self buttonSendMail1] setTitle: [defaults valueForKey: HCMailReceiverAlias1Key] forState: UIControlStateNormal];
	[[self buttonSendMail2] setTitle: [defaults valueForKey: HCMailReceiverAlias2Key] forState: UIControlStateNormal];
	[[self buttonSendMail3] setTitle: [defaults valueForKey: HCMailReceiverAlias3Key] forState: UIControlStateNormal];
	[[self buttonSendMail4] setTitle: [defaults valueForKey: HCMailReceiverAlias4Key] forState: UIControlStateNormal];
	
	[[self buttonSendMail1] setEnabled: [HCUITextField isValidRecipientWithNumber: 1]==YES];

	[[self buttonSendMail2] setEnabled: [HCUITextField isValidRecipientWithNumber: 2]==YES];
	
	[[self buttonSendMail3] setEnabled: [HCUITextField isValidRecipientWithNumber: 3]==YES];
	
	[[self buttonSendMail4] setEnabled: [HCUITextField isValidRecipientWithNumber: 4]==YES];

}


- (void) viewDidDisappear:(BOOL)animated{

	DLog(@"");
	[super viewDidDisappear: animated];
}


#pragma mark - actions

	// cancel/close the viewcontroller
- (IBAction)done:(id)sender {

	DLog(@"");
		// tell parent view to close us
	[self.delegate moreRecepientsSendMailViewContollerDidFinish: self];

}

#pragma mark - sendmail

- (IBAction)buttonSendMailTouched:(id)sender {
	
	DLog(@"tag=%i", [sender tag]);
	
	[self.delegate sendMailFromButtonWithTag: sender fromController: self];
		
}


#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if (buttonIndex == 1) {
		
			//OK clicked
		
	} else {
		
	}
	
}

@end
