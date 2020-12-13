//
//  HCMailAttachment.m
//  QuickMinder
//
//  Created by Putze Sven on 21.02.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import "HCMailAttachment.h"

NSString* const HCAttachmentType=@"HCAttachmentType";
NSString* const HCAttachmentInfoDictionary=@"HCAttachmentInfoDictionary";
NSString* const HCAttachmentFileName=@"HCAttachmentFileName";
NSString* const HCMimeTypeJpeg=@"image/jpeg";
NSString* const HCAttachmentAssetURL=@"HCAttachmentAssetURL";


#pragma mark - implementation

@implementation HCMailAttachment

@synthesize attachmentType = _attachmentType;
@synthesize attachmentInfoDictionary = _attachmentInfoDictionary;
@synthesize attachmentFileName = _attachmentFileName;
@synthesize assetURL = _assetURL;


- (void)dealloc{
	
	DLog(@"");
	
	
	[[self attachmentInfoDictionary] release];
	[[self attachmentFileName] release];
	[[self assetURL] release];
	[super dealloc];
}


#pragma mark - accessing attachment content

- (UIImage*)imageRepresentationOfAttachment{
	
	UIImage *image = nil;
	
	switch (self.attachmentType) {
			
		case HCAttachmentUIImagePicker:;

			NSDictionary *infoDictionary = [self attachmentInfoDictionary];
			image = [infoDictionary objectForKey: UIImagePickerControllerEditedImage];
			if(!image) image = [infoDictionary objectForKey: UIImagePickerControllerOriginalImage];

			break;
			
			default:
			break;
	}
	
	return image;
}



#pragma mark - Archiving

- (id)initWithCoder:(NSCoder *)aDecoder{

	DLog(@"");
	
	self = [super init];
	if (self){
		self.attachmentType = [aDecoder decodeIntForKey: HCAttachmentType];
		self.attachmentInfoDictionary = [aDecoder decodeObjectForKey: HCAttachmentInfoDictionary];
		self.attachmentFileName = [aDecoder decodeObjectForKey: HCAttachmentFileName];
		self.assetURL = [aDecoder decodeObjectForKey: HCAttachmentAssetURL];
	}
	return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{

	DLog(@"");
	
	[aCoder encodeInteger: [self attachmentType] forKey: HCAttachmentType];
	[aCoder encodeObject: [self attachmentInfoDictionary] forKey: HCAttachmentInfoDictionary];
	[aCoder encodeObject: [self attachmentFileName] forKey: HCAttachmentFileName];
	[aCoder encodeObject: [self assetURL] forKey: HCAttachmentAssetURL];

}


@end
