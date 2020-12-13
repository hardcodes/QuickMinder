//
//  HCAttachmentUITableViewCell.m
//  QuickMinder
//
//  Created by Putze Sven on 09.03.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import "HCAttachmentUITableViewCell.h"

const NSString* HCHCAttachmentUITableViewCellIdentifier=@"HCHCAttachmentUITableViewCellIdentifier";


#pragma mark - implementation

@implementation HCAttachmentUITableViewCell
@synthesize delegate;
@synthesize buttonPhoneTrash;
@synthesize buttonPadTrash;
@synthesize mailAttachment;
@synthesize mailAttachmentImageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	DLog(@"");
	
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
			[[self buttonPadTrash] setHidden: NO];
			[[self buttonPhoneTrash] setHidden: YES];
		}
		else{
			[[self buttonPadTrash] setHidden: YES];
			[[self buttonPhoneTrash] setHidden: NO];			
		}
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)dealloc {
	[buttonPhoneTrash release];
	[buttonPadTrash release];
	[mailAttachmentImageView release];
	[super dealloc];
}


- (IBAction)buttonTrashTouchUpInside:(id)sender {
	
	[[self delegate] removeAttachmentFromMutableArray: self.mailAttachment];
}


- (HCMailAttachment*)mailAttachment{
	return self.mailAttachment;
}

- (void)setMailAttachment:(HCMailAttachment *) aMailAttachment{
	
	if(aMailAttachment != mailAttachment){
		
		[aMailAttachment retain];
		[mailAttachment release];
		mailAttachment = aMailAttachment;
		
		switch (mailAttachment.attachmentType) {
				
			case HCAttachmentUIImagePicker:;
				
				NSDictionary *infoDictionary = [mailAttachment attachmentInfoDictionary];
				UIImage *editedIage = [infoDictionary objectForKey: UIImagePickerControllerEditedImage];
				[[self mailAttachmentImageView] setImage: editedIage];
				[[self mailAttachmentImageView] setHidden: NO];
				
				break;
				
			default:
				
				[[self mailAttachmentImageView] setHidden: YES];
				break;
		}
		
	}
}

@end
