//
//  HCUIPopoverViewController.m
//  QuickMinder
//
//  Created by Putze Sven on 13.02.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import "HCUIPopoverViewController.h"
#import "HCArrowView.h"
#import "HCUIViewTouchCatcher.h"

#pragma mark - private interface

@interface HCUIPopoverViewController()

@property (assign, nonatomic) CGRect alignmentRect;

- (void)buttonTouched: (id) sender;

@end


#pragma mark - implementaion

@implementation HCUIPopoverViewController

@synthesize delegate = _delegate;
@synthesize horizontalPadding = _horizontalPadding;
@synthesize verticalPadding = _verticalPadding;
@synthesize buttonControlEvent = _buttonControlEvent;
@synthesize contentBackgroundColor = _contentBackgroundColor;
@synthesize contentAplha = _contentAplha;
@synthesize popoverVisible = _popoverVisible;
@synthesize alignmentRect = _alignmentRect;


#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	DLog(@"");
	
    [NSException raise: NSInvalidArgumentException format: @"initWithNibName:bundle: must not be used. HCUIPopoverViewController is intended to be used programmatically only."];
    return nil;
}


- (id)initWithCoder:(NSCoder *)aDecoder{

	DLog(@"");
	
	self = [super initWithCoder: aDecoder];
	if(self){
		
			// setting the default values
		[self setHorizontalPadding: HCUIPopoverViewControllerHPadding];
		[self setVerticalPadding: HCUIPopoverViewControllerVPadding];
		[self setButtonControlEvent: UIControlEventTouchUpInside];
		[self setContentBackgroundColor: [UIColor whiteColor]];
		[self setContentAplha: HCUIPopoverViewControllerAlpha];
		_popoverVisible=NO;
		[self setAlignmentRect: CGRectNull];
	}
	
	return self;

}


- (void)didReceiveMemoryWarning
{
	DLog(@"");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView{
	
	DLog(@"");
	
	HCUIViewRoundedCorners *contentView = nil;
	CGRect contentFrame = CGRectNull;
	if([self delegate] && [[self delegate] respondsToSelector: @selector(contentViewForPopOverViewController)]){
			// the casting to id would not be necessary because the protocol implements the NSObject protocol
			// but contentView is a HCUIViewRoundedCorners. Do not want to cast to HCUIViewRoundedCorners because
			// this is only mandatory if no other view is referenced here -> if superview has no individual view
			// for us, I say it will be a HCUIViewRoundedCorners.
		contentView = (id)[[[self delegate] contentViewForPopOverViewController: self] retain];		
	}
		// call the delegate for the buttons anyhow. We need the buttons even for custom views to set the action
	NSArray *contentArray = [[[self delegate] addButtonsToContentViewForPopOverViewController: self] retain];
	for (UIButton *button in contentArray) {
			// set the button's target
			// default event is UIControlEventTouchUpInside unless set otherwise
		[button addTarget: self action: @selector(buttonTouched:) forControlEvents: self.buttonControlEvent];
	}
	if(contentView){
			// TODO: calc contentFrame / position
	}
	else{
			// create an empty contentView
		contentView = [[HCUIViewRoundedCorners alloc] initWithFrame: CGRectNull andRadius: HCUIPopoverViewControllerContentLayerRadius];
		[contentView setBackgroundColor: self.contentBackgroundColor];
		[contentView setAlpha: self.contentAplha];
		
			// call delegate to get content information
		GLfloat yPosition = [self verticalPadding];
		GLfloat maxWidth = 0;
		
		for (UIButton *button in contentArray) {
				// new position for the button within the content view
			CGRect buttonFrame = CGRectMake(self.horizontalPadding, yPosition, button.frame.size.width, button.frame.size.height);
			[button setFrame: buttonFrame];
				// y position for the next button
			yPosition+= self.verticalPadding + button.frame.size.height;
				// what's the button with the max width?
			if (button.frame.size.width > maxWidth) maxWidth = button.frame.size.width;
			
			[contentView addSubview: button];
		}
			// all buttons are in the contentview -> calculate frame size
		contentFrame = CGRectMake(self.horizontalPadding, HCUIPopoverViewControllerArrowHeight, 2*self.horizontalPadding +maxWidth, yPosition);
		[contentView setFrame: contentFrame];
			// array is not needed anymore
		[contentArray release];
	}
	
		// create the arrow view
	CGRect arrowFrame=CGRectMake(self.horizontalPadding +contentFrame.size.width/2-HCUIPopoverViewControllerArrowBase/2,0,HCUIPopoverViewControllerArrowBase,HCUIPopoverViewControllerArrowHeight);
	HCArrowView *arrowView=[[HCArrowView alloc] initWithFrame: arrowFrame];
	[arrowView setDrawingColor: self.contentBackgroundColor];
	[arrowView setArrowDirection: HCArrowUp];
	[arrowView setLineWidth: 1.0];
	
		// create view controller's view (umbrella view)
	CGRect viewFrame = CGRectNull;
	if(CGRectIsNull(self.alignmentRect)){
		viewFrame = CGRectMake(0, 0, 2*self.horizontalPadding + contentView.frame.size.width, contentView.frame.size.height + HCUIPopoverViewControllerArrowHeight);				
	}
	else{
		viewFrame = CGRectMake(self.alignmentRect.origin.x +self.alignmentRect.size.width/2 -(2*self.horizontalPadding + contentView.frame.size.width)/2, self.alignmentRect.size.height, 2*self.horizontalPadding + contentView.frame.size.width, contentView.frame.size.height + HCUIPopoverViewControllerArrowHeight);
	}

	DLog(@"viewFrame=%@", NSStringFromCGRect(viewFrame));
	DLog(@"AlignmentRect=%@", NSStringFromCGRect(self.alignmentRect));

	HCUIViewTouchCatcher *umbrellaView = [[HCUIViewTouchCatcher alloc] initWithFrame: viewFrame];
	[umbrellaView addSubview: arrowView];
	[umbrellaView addSubview: contentView];
	[umbrellaView setDelegate: self];
	[self setView: umbrellaView];
	[[self view] becomeFirstResponder];
	[umbrellaView release];
	[contentView release];
	[arrowView release];
	
	self.view.userInteractionEnabled = NO;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
	
	DLog(@"");

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[self setContentBackgroundColor: nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	DLog(@"");
    // Return YES for supported orientations
    return YES;
}


#pragma mark - view presentation

- (void)presentHCUIPopoverViewControllerInSuperView: (UIView*) aSuperView forAlignmentRect: (CGRect) aAlignmentRect animated: (BOOL) isAnimated{
	
	DLog(@"%@", (isAnimated==YES?@"YES":@"NO"));

		// our view is centered under this CGRect
	[self setAlignmentRect: aAlignmentRect];
		// force loading of our own view and add it to the superview
	[aSuperView addSubview: self.view];
	
	if (isAnimated) {
		[[self view] setAlpha: 0.0];
		self.view.userInteractionEnabled = NO;
		[UIView beginAnimations: @"FadeIn" context: nil];
		[UIView setAnimationDelegate: self];
		[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
		[UIView setAnimationDuration: HCUIPopoverViewControllerAnimationDuration];
		
		[[self view] setAlpha: 1.0];
		
		[UIView commitAnimations];
		
	} else {
		_popoverVisible = YES;
		self.view.userInteractionEnabled = YES;
		[[self view] setAlpha: 1.0];
		[[self view] becomeFirstResponder];
	}	
}


#pragma mark - HCUIViewTouchCatcherDelegate Protocol

- (void)dismissHCUIPopoverViewControllerFromTouchCatcherViewAnimated: (BOOL) isAnimated{
	
	[[self delegate] dismissPopoverViewController: (HCUIPopoverViewController*) self animated: isAnimated];
}

- (void)dismissHCUIPopoverViewControllerFromSuperViewAnimated: (BOOL) isAnimated{
	
	DLog(@"%@", (isAnimated==YES?@"YES":@"NO"));	
	
	if (self.view) {
		
		[self viewWillDisappear: isAnimated];
		_popoverVisible = NO;
		[self.view resignFirstResponder];
		self.view.userInteractionEnabled = NO;
		
		if (isAnimated) {
			
			[UIView beginAnimations:@"FadeOut" context: nil];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
			[UIView setAnimationDuration: HCUIPopoverViewControllerAnimationDuration];
			
			self.view.alpha = 0.0;
			
			[UIView commitAnimations];
			
		}
		else{
			
			[[self view] removeFromSuperview];
			[self setView: nil];
		}
	}
}


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)theContext {
	
	DLog(@"");
	
	if ([animationID isEqual:@"FadeIn"]) {
		self.view.userInteractionEnabled = YES;
		_popoverVisible = YES;
		[[self view] becomeFirstResponder];
	}
	else{
		_popoverVisible = NO;
		[[self view] removeFromSuperview];
		[self setView: nil];
	}
}



#pragma mark - button action

- (void) buttonTouched:(id)sender{

	DLog(@", tag=%i", [sender tag]);

		// we don't know nothing about the buttons, let the delegate do the job
	[[self delegate] popoverViewController: (HCUIPopoverViewController*) self buttonTouched: sender];
}

@end
