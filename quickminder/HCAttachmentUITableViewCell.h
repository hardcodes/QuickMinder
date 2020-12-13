//
//  HCAttachmentUITableViewCell.h
//  QuickMinder
//
//  Created by Putze Sven on 09.03.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCUIButton.h"
#import "HCMailAttachment.h"

extern const NSString* HCHCAttachmentUITableViewCellIdentifier;

@protocol HCAttachmentUITableViewCellDelegate <NSObject>
@required
	// must be implemented from the tableviewcontroller
- (void)removeAttachmentFromMutableArray: (HCMailAttachment*) attachmentToRemove;

@end

@interface HCAttachmentUITableViewCell : UITableViewCell
@property (assign, nonatomic) id <HCAttachmentUITableViewCellDelegate> delegate;
@property (retain, nonatomic) IBOutlet HCUIButton *buttonPhoneTrash;
@property (retain, nonatomic) IBOutlet HCUIButton *buttonPadTrash;
@property (assign, nonatomic) HCMailAttachment* mailAttachment;
@property (retain, nonatomic) IBOutlet UIImageView *mailAttachmentImageView;

- (IBAction)buttonTrashTouchUpInside:(id)sender;

@end
