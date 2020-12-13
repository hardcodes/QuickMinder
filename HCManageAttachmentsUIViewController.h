//
//  HCManageAttachmentsUIViewController.h
//  QuickMinder
//
//  Created by Putze Sven on 11.03.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCUIViewRoundedCorners.h"


@class HCManageAttachmentsUIViewController;
@protocol HCManageAttachmentsUIViewControllerDelegate <NSObject>

- (void)manageAttachmentsUIViewControllerDidFinish: (HCManageAttachmentsUIViewController*) controllerThatFinished;

@end



@interface HCManageAttachmentsUIViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	
}

@property (assign, nonatomic) NSMutableArray *attachmentsArray;
@property (assign, nonatomic) id<HCManageAttachmentsUIViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIButton *buttonCancel;
@property (retain, nonatomic) IBOutlet UITableView *tableViewAttachments;

- (IBAction)buttonCancelTouchDown:(id)sender;

@end
