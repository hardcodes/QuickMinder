//
//  HCMailAttachment.h
//  QuickMinder
//
//  Created by Putze Sven on 21.02.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import <Foundation/Foundation.h>

enum HCAttachmentTypes{
	HCAttachmentUIImagePicker,
	HCAttachmentITunesShared,
	HCAttachmentDropboxShared
};

extern NSString* const HCAttachmentType;
extern NSString* const HCAttachmentInfoDictionary;
extern NSString* const HCAttachmentFileName;
extern NSString* const HCAttachmentAssetURL;

extern NSString* const HCMimeTypeJpeg;

@interface HCMailAttachment : NSObject{
		
}

@property (assign, nonatomic) NSInteger attachmentType;
@property (retain, nonatomic) NSDictionary *attachmentInfoDictionary;
@property (retain, nonatomic) NSString *attachmentFileName;
@property (retain, nonatomic) NSURL *assetURL;


- (UIImage*)imageRepresentationOfAttachment;


@end
