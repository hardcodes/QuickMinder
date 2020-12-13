//
//  HCPortraitSendMailViewContoller.h
//  quickminder
//
//  Created by Putze Sven on 25.12.11.
//  Copyright (c) 2011 hardcodes.de. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HCMoreRecepientsSendMailViewContoller;

@protocol HCMoreRecepientsSendMailViewContollerDelegate
	// tell the partent view that the user has chosen a mail recipient
- (void) sendMailFromButtonWithTag: (id) sender fromController: (HCMoreRecepientsSendMailViewContoller*) aController;
	// is called via timer from sendMailFromButtonWithTag:fromController
- (void) sendMailAfterViewAppearedFromButtonWithTag: (id) sender;
	// tell the parent view to dismiss us
- (void) moreRecepientsSendMailViewContollerDidFinish: (HCMoreRecepientsSendMailViewContoller*) aController;

@end


@interface HCMoreRecepientsSendMailViewContoller : UIViewController{
}

@property (assign, nonatomic) id <HCMoreRecepientsSendMailViewContollerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIButton *buttonSendMail1;
@property (retain, nonatomic) IBOutlet UIButton *buttonSendMail2;
@property (retain, nonatomic) IBOutlet UIButton *buttonSendMail3;
@property (retain, nonatomic) IBOutlet UIButton *buttonSendMail4;

- (IBAction)done:(id)sender;
- (IBAction)buttonSendMailTouched:(id)sender;

@end
