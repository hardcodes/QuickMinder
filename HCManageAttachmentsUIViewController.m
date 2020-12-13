//
//  HCManageAttachmentsUIViewController.m
//  QuickMinder
//
//  Created by Putze Sven on 11.03.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import "HCManageAttachmentsUIViewController.h"
#import "HCMailAttachment.h"
#import "HCUIButton.h"


#pragma mark - private interface

@interface HCManageAttachmentsUIViewController()


@end


#pragma mark - implementation

@implementation HCManageAttachmentsUIViewController

@synthesize attachmentsArray = _attachmentsArray;
@synthesize delegate = _delegate;
@synthesize buttonCancel = _buttonCancel;
@synthesize tableViewAttachments = _tableViewAttachments;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	
	NSString* platform;
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) platform=@"iPad";
	else platform=@"iPhone";
	
	NSString* nibName = [NSString stringWithFormat: @"%@_%@", nibNameOrNil, platform];
	
	DLog(@"nibName=%@", nibName);
    
	self = [super initWithNibName: nibName bundle: nibBundleOrNil];
    if (self) {
			// Custom initialization

    }
    return self;

}

- (void)didReceiveMemoryWarning
{
		// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
		// Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	DLog(@"");
    [super viewDidLoad];
		// Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
	DLog(@"");
	[self setButtonCancel:nil];
	[self setTableViewAttachments:nil];
    [super viewDidUnload];
		// Release any retained subviews of the main view.
		// e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
		// Return YES for supported orientations
    return YES;
}

- (void)dealloc {
	
	DLog(@"");
	
	[_buttonCancel release];
	[_tableViewAttachments release];
    [super dealloc];
}


#pragma mark - UITableViewDataSource Protocol

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	DLog(@"section=%i, row=%i",indexPath.section, indexPath.row);
	
	UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier: @"SimpleTableIdentifier"];
	
	if (tableViewCell == nil) {
		
		tableViewCell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"SimpleTableIdentifier"] autorelease];
		
	}
	
	HCMailAttachment *mailAttachment = [[self attachmentsArray] objectAtIndex:indexPath.row];
	[[tableViewCell imageView] setImage: mailAttachment.imageRepresentationOfAttachment];
		
	HCUIButton *buttonRemoveAttachment = [HCUIButton buttonWithType: UIButtonTypeCustom];
	[buttonRemoveAttachment setDeviceIndependentImageOfType: HCButtomImageTrash];
	[buttonRemoveAttachment setDeviceIndependentFrameBasedOnPhoneFrame: CGRectMake(0,0,32,32)];
	[buttonRemoveAttachment setTag: -1];
	[buttonRemoveAttachment addTarget: self action: @selector(buttonRemoveAttachmentTouched:) forControlEvents: UIControlEventTouchUpInside];
	[buttonRemoveAttachment setEnabled: NO];
	[buttonRemoveAttachment setHighlighted: NO];
	[buttonRemoveAttachment setShowsTouchWhenHighlighted: YES];
	
	[tableViewCell setAccessoryView: buttonRemoveAttachment];

	HCUIViewRoundedCorners *bgColorView = [[HCUIViewRoundedCorners alloc] init];
	[bgColorView setBackgroundColor: UIColorFromHEXWithAlpha(0xFFFFFF10)];
	[tableViewCell setSelectedBackgroundView:bgColorView];
	[bgColorView release];
	return tableViewCell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	DLog(@"");
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	DLog(@"");
	return [[self attachmentsArray] count];
}


#pragma mark - UITableViewDelegate Protocol

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	DLog(@"section=%i, row=%i",indexPath.section, indexPath.row);
	UITableViewCell *tableViewCell = (UITableViewCell *)[(UITableView *)tableView cellForRowAtIndexPath: indexPath];
	HCUIButton *accessoryButton = (HCUIButton*)[tableViewCell accessoryView];
	[accessoryButton setTag: indexPath.row];
	[accessoryButton setEnabled: YES];
	[accessoryButton setHighlighted: NO];

}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	DLog(@"section=%i, row=%i",indexPath.section, indexPath.row);
	UITableViewCell *tableViewCell = (UITableViewCell *)[(UITableView *)tableView cellForRowAtIndexPath: indexPath];
	HCUIButton *accessoryButton = (HCUIButton*)[tableViewCell accessoryView];
	[accessoryButton setTag: -1];
	[accessoryButton setEnabled: NO];
}


- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	
	DLog(@"section=%i, row=%i",indexPath.section, indexPath.row);
	
}


#pragma mark - buttons

- (IBAction)buttonCancelTouchDown:(id)sender {
	
	DLog(@"");
	[[self delegate] manageAttachmentsUIViewControllerDidFinish: self];
}


- (void) buttonRemoveAttachmentTouched:(id)sender{
	
	DLog(@", tag=%i", [sender tag]);
	NSArray *deleteIndexPaths = [NSArray arrayWithObject: [NSIndexPath indexPathForRow: [sender tag] inSection:0]];
	
	[[self tableViewAttachments] beginUpdates];
	[[self attachmentsArray] removeObjectAtIndex: [sender tag]];
	[[self tableViewAttachments] deleteRowsAtIndexPaths: deleteIndexPaths withRowAnimation: UITableViewRowAnimationFade];
	[[self tableViewAttachments] endUpdates];
	
	if([[self attachmentsArray] count]==0) [self performSelector: @selector(buttonCancelTouchDown:) withObject: nil afterDelay: 0.5];
}


@end
