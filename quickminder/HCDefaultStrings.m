//
//  HCDefaultStrings.m
//  quickminder
//
//  Created by Putze Sven on 26.12.11.
//  Copyright (c) 2011 hardcodes.de. All rights reserved.
//

#import "HCDefaultStrings.h"

NSString* const HCMailReceiver1Key=@"Mail#1";
NSString* const HCMailReceiver2Key=@"Mail#2";
NSString* const HCMailReceiver3Key=@"Mail#3";
NSString* const HCMailReceiver4Key=@"Mail#4";
NSString* const HCMailReceiverAlias1Key=@"Mail#1Alias";
NSString* const HCMailReceiverAlias2Key=@"Mail#2Alias";
NSString* const HCMailReceiverAlias3Key=@"Mail#3Alias";
NSString* const HCMailReceiverAlias4Key=@"Mail#4Alias";

NSString* const HCMailSubjectKey=@"Subject";
NSString* const HCWordCorrectionKey=@"WordCorrection";
NSString* const HCAutoDeleteKey=@"AutoDelete";
NSString* const HCShowKeyboardKey=@"ShowKeyboard";
NSString* const HCTextViewMailBodyKey=@"Mailbody";
NSString* const HCTextViewMailSubjectKey=@"MailSubject";

NSString* const HCMailReceiver1Value=@"";
NSString* const HCMailReceiver2Value=@"";
NSString* const HCMailReceiver3Value=@"";
NSString* const HCMailReceiver4Value=@"";
NSString* const HCMailReceiverAlias1Value=@"";
NSString* const HCMailReceiverAlias2Value=@"";
NSString* const HCMailReceiverAlias3Value=@"";
NSString* const HCMailReceiverAlias4Value=@"";


NSString* const HCMailSubjectValue=@"QuickMinder: ";

NSString* const HCValidEmailAddressRegexPattern=@"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}$";
NSString* const HCValidEmailAddressesRegexPattern=@"^(([A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6})(,|,\\s)){1,19}([A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}){1}$";

NSString* const HCLocationManagerTimeoutKey=@"LocationManagerTimeout";
NSString* const HCLocationManagerTimeoutMinKey=@"LocationManagerTimeoutMin";
NSString* const HCLocationManagerTimeoutMaxKey=@"LocationManagerTimeoutMax";
NSTimeInterval const HCLocationManagerTimeoutValue=20.0;
NSTimeInterval const HCLocationManagerTimeoutMinValue=5.0;
NSTimeInterval const HCLocationManagerTimeoutMaxValue=60.0;

NSString* const HCSendMailButtonLabelKey = @"SendMailButtonLabel";
NSString* const HCSendMailButtonLabelValue = @"Send";
NSString* const HCAutoSendMailKey=@"AutoSendMailSwitch";
NSString* const HCSavePhotosKey=@"SavePhotos";
NSString* const HCPhotoCompressionKey=@"PhotoCompression";
NSString* const HCPhotoResizingKey=@"HCPhotoResizingKey";
NSString* const HCPhotoFlashSegmentKey=@"HCPhotoFlashSegmentKey";

NSString* const HCGroupImage32=@"Group";
NSString* const HCPng=@"png";

NSString* const HCGPSiPhoneImage=@"locationservice~iphone";
NSString* const HCGPSiPadImage=@"locationservice~ipad";

NSString* const HCCameraiPhoneImage=@"camera~iphone";
NSString* const HCCameraiPadImage=@"cameraipad";

NSString* const HCAttachmentIcon=@"Attachment";

NSString* const HCMailHasAttachmentKey = @"MailHasAttachment";
NSString* const HCAttachmentsStorageFileName = @"MailAttachments.plist";

NSString* const HCUseTextExpander = @"HCUseTextExpander";

@implementation HCDefaultStrings

@end
