//
//  HCMailComposeViewController.m
//  quickminder
//
//  Created by Putze Sven on 08.01.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import "HCMailComposeViewController.h"
#import "HCStaticMethods.h"
#import "HCDefaultStrings.h"
#import "HCUITextField.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "HCMailAttachment.h"
	//#import "HCUIImageResizing.h"
#import "UIImage+Resize.h"


#pragma mark - private interface

@interface HCMailComposeViewController(){

	int searchCount;
}

@end


#pragma mark - implementation

@implementation HCMailComposeViewController

@synthesize autoSendMail = _autoSendMail;


	// overridden to preset the BOOL property
- (void) viewDidLoad{

	DLog(@" delegate=%@", self.delegate);
	
	[super viewDidLoad];
	
	[self setAutoSendMail: NO];
	searchCount = 0;
	
}


	// overridden to check if the timer should be started
- (void) viewDidAppear:(BOOL)animated{

	DLog(@" delegate=%@", self.delegate);

	[super viewDidAppear: animated];
	
	if([self autoSendMail]){

		DLog(@" calling waitForTextView in %f seconds", HCSendMailDelay);

		[self performSelector:@selector(waitForTextView) withObject: nil afterDelay: HCSendMailDelay];
	}
}


- (void) viewWillDisappear:(BOOL)animated{
	
	DLog(@" delegate=%@", self.delegate);

	[super viewWillDisappear: animated];
}


#pragma mark - timed methods

- (void)waitForTextView{
	
	DLog(@"");
	
	UIView *viewWithText = [self findMessageInView: self.view];
	if(viewWithText!=nil){
			// we have some text = view is ready = we can send mail
		[self touchSendMailButton];
		return;
	}

	if(searchCount <= HCSendMailFindTextViewMaxRetry){
		
		++searchCount;

		DLog(@" calling waitForTextView in %f seconds", HCSendMailFindTextViewDelay);

		[self performSelector:@selector(waitForTextView) withObject: nil afterDelay: HCSendMailFindTextViewDelay];
		return;
	}
	
	DLog(@" waitForTextView -> calling touchSendMailButton");

	[self touchSendMailButton];
	
}

	// selector looks up for the send button and touches it programmatically
- (void) touchSendMailButton{

	DLog(@"");
	
#if DEBUG
	// Build Option "treat warnings as errors" must be NO for this
	NSLog(@"HCMailComposeViewController: %@", [[self view] recursiveDescription] );
	dumpViews(self.view, @"", @"");
#endif
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if([defaults boolForKey: HCAutoSendMailKey]){
		NSString *sendMailButtonLabel = [defaults objectForKey: HCSendMailButtonLabelKey];
		
		UIButton *sendMailButton = (UIButton*)[self findButtonInView: self.view withLabelText: sendMailButtonLabel];

		
		if(sendMailButton!=nil){

			DLog(@" sendMailButton=%@, state=%i", sendMailButton, sendMailButton.state);

			[sendMailButton sendActionsForControlEvents: UIControlEventTouchUpInside];	
		}
		else [HCStaticMethods showWarningMessage: NSLocalizedString(@"Sorry, can not find the Send Button.\nMaybe the Label is misspelled?",nil)];
	}
}


#pragma mark - view analysis

	// selector traverses the given view and searches a UIButton with
	// a label that has a text = aLabelText
	// nil = nothing found
- (UIView*)findButtonInView: (UIView*) aView withLabelText: (NSString*) aLabelText{
	
	DLog(@"");
	
		// are we the searched label?
	Class viewClass = [aView class];
	NSString *classDescription = [viewClass description];
	DLog(@"%@", classDescription);
		// UIButtonLabel is the subview for the search UIButton
	if([classDescription isEqualToString:@"UIButtonLabel"]){
		
			// UIButtonLabel inherits from UILabel
			// so we can address it as UILabel
		UILabel *buttonLabel = (UILabel*)aView;
			// found our target = break the recursion
		if([[buttonLabel text] isEqualToString: aLabelText]) return aView.superview;
		
	}
	
	UIView *subView = nil;

	for (NSUInteger i = 0; i < [aView.subviews count]; i++){
			// call ourself for every subview		
		UIView *enumeratedSubView = [aView.subviews objectAtIndex:i];
		subView = [self findButtonInView: enumeratedSubView withLabelText: aLabelText];
			// found our target = break the recursion
		if(subView!=nil) break;
	}
	
		// what ever we found, return it to the caller
	return subView;
}


- (UIView*)findMessageInView: (UIView*) aView{
		
	DLog(@"");
	
		// is this the MFComposeTextContentView?
	Class viewClass = [aView class];
		// UIButtonLabel is the subview for the search UIButton
	if([[viewClass description] isEqualToString:@"MFComposeTextContentView"]){
		
		NSString *textInView;
		@try {
			textInView = [NSString stringWithFormat: @"%@", ((UITextView *)aView).text];
		}
		@catch (NSException *exception) {
			NSLog(@"HCMailComposeViewController: findMessageInView, accessing the MFComposeTextContentView was not possible!");
		}
		@finally {
			if(textInView!=nil){
#if DEBUG
				NSLog(@"HCMailComposeViewController: findMessageInView, MFComposeTextContentView.text:%@", textInView);
#endif
				if(textInView.length!=0) return aView.superview;						
			}
		}
	}

	UIView *subView = nil;	
	for (NSUInteger i = 0; i < [aView.subviews count]; i++){
			// call ourself for every subview		
		UIView *enumeratedSubView = [aView.subviews objectAtIndex:i];
		subView = [self findMessageInView: enumeratedSubView];
			// found our target = break the recursion
		if(subView!=nil) break;
	}

	// what ever we found, return it to the caller
	return subView;

}

#pragma mark - class methods

+ (void)sendMailWithSubject: (NSString*) aSubject
				messageBody: (NSString*) aMessageBody
				toRecipient: (NSString*) aRecipient
				attachments: (NSMutableArray*) anAttachmentsArray
			   withDelegate: (id) aDelegate{
		
	
#if DEBUG
	NSLog(@"mailSubject: %@", aSubject);
	NSLog(@"mailBody: %@", aMessageBody);
	NSLog(@"recipient: %@", aRecipient);
	NSLog(@"attachments: %@", anAttachmentsArray);
#endif
	
	if([aMessageBody length] == 0 && [aSubject length] == 0 && [anAttachmentsArray count] == 0){
		DLog(@"There is no message to send!");
		[HCStaticMethods showWarningMessage: NSLocalizedString(@"There is no message to send!",nil)];
		return;
	}
	
	if([MFMailComposeViewController canSendMail]){
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSMutableArray *toRecipients = [[NSMutableArray alloc] initWithCapacity: HCMaxMailRecipients];
		
		if([HCUITextField haystack: aRecipient containsNeedle: @","]){
					// handle multiple mail recipients	
			NSArray *recipients = [aRecipient componentsSeparatedByString: @","];
			for(NSUInteger index=0; index < [recipients count]; index++){

				DLog(@" recipient# %i = %@", index, [[recipients objectAtIndex: index] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]);

				[toRecipients addObject: [[recipients objectAtIndex: index] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]];
			}
		}
			// only one recipient
		else [toRecipients addObject: aRecipient];
		
		HCMailComposeViewController *mailComposeViewController; 
		
			//HCMailComposeViewController<-MFMailComposeViewController<-...NSObject
		mailComposeViewController  = [[HCMailComposeViewController alloc] init];
		[mailComposeViewController setMailComposeDelegate: aDelegate];
		[mailComposeViewController setModalPresentationStyle:UIModalPresentationFormSheet];
		[mailComposeViewController setSubject: aSubject];
		[mailComposeViewController setMessageBody: aMessageBody isHTML:NO];
		[mailComposeViewController setToRecipients: toRecipients];
			// handle attachments
		if(anAttachmentsArray){
			
			unsigned int imageNumber = 1;
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat:@"yyyyMMdd-HHmm"];
			
			for(HCMailAttachment *mailAttachment in anAttachmentsArray){
				
				switch (mailAttachment.attachmentType) {
						
					case HCAttachmentUIImagePicker:;
						
						UIImage *originalImage = mailAttachment.imageRepresentationOfAttachment;
						UIImage *resizedImage = nil;
						CGSize newImageSize = CGSizeZero;
						
						DLog(@"original imageSize=%@", NSStringFromCGSize(originalImage.size));
						CGFloat resizingFactor = [defaults floatForKey: HCPhotoResizingKey];
						if(resizingFactor == 1.0){
							newImageSize = originalImage.size;
							resizedImage = originalImage;
							DLog(@"resizing factor = 1.0, keeping original image");
						}
						else{
							newImageSize = CGSizeMake(originalImage.size.width * resizingFactor, originalImage.size.height * resizingFactor);
								//resizedImage = [originalImage scaleToSize: newImageSize];
							resizedImage = [originalImage resizedImage: newImageSize interpolationQuality: kCGInterpolationHigh];
						}
						DLog(@"new imageSize=%@", NSStringFromCGSize(resizedImage.size));
						CGFloat compressionQuality = [defaults floatForKey: HCPhotoCompressionKey];
						NSData *imageData = UIImageJPEGRepresentation(resizedImage, compressionQuality);
						NSString *imageName;
						if([mailAttachment attachmentFileName]) imageName = [mailAttachment attachmentFileName];
						else{
							NSString *dateString = [formatter stringFromDate:[NSDate date]];
							imageName = [NSString stringWithFormat: @"QuickMinder-%@-%03i.JPG", dateString, imageNumber];
							++imageNumber;
						}
						DLog(@"attaching %@", imageName);
						[mailComposeViewController addAttachmentData: imageData mimeType: HCMimeTypeJpeg fileName: imageName];
						break;
						
					default:
						break;
				}
			}
			[formatter release];
		}
		[mailComposeViewController setAutoSendMail: YES];
		
		[aDelegate presentModalViewController:mailComposeViewController animated:YES];
		[mailComposeViewController release];
		[toRecipients release];
	}
	else{
		[HCStaticMethods showWarningMessage: NSLocalizedString(@"Your device is not able to send email!",nil)];
	}
	
		//	[mstring release];
	
}


@end
