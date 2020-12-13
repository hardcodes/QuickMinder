//
//  HCMailComposeViewController.h
//  quickminder
//
//  Created by Putze Sven on 08.01.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import <MessageUI/MessageUI.h>

#define HCSendMailDelay 0.3
#define HCSendMailFindTextViewDelay 0.1
#define HCSendMailFindTextViewMaxRetry 20
#define HCMaxMailRecipients 35


@interface HCMailComposeViewController : MFMailComposeViewController{
}


@property (assign, nonatomic) BOOL autoSendMail;
	

- (void)touchSendMailButton;

- (void)waitForTextView;

- (UIView*)findButtonInView: (UIView*) aView withLabelText: (NSString*) aLabelText;

- (UIView*)findMessageInView: (UIView*) aView;


	// Selector creates an instance of MFMailComposeViewController, fills the properties, sets the delegates and shows the view
	// used since version 1.02
+ (void)sendMailWithSubject: (NSString*) aSubject
				messageBody: (NSString*) aMessageBody
				toRecipient: (NSString*) aRecipient
				attachments: (NSMutableArray*) anAttachmentsArray
			   withDelegate: (id) aDelegate;

@end
