//
// Created by sven on 01.06.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

extern NSString* const HCMailConfigItemMailReceiver;
extern NSString* const HCMailConfigItemButtonAlias;

@interface HCMailConfigItem : NSObject

@property (retain, nonatomic) NSString *mailReceiver;
@property (retain, nonatomic) NSString *buttonAlias;

// Selector returns YES if aMailRecipient contains  one valid email address
+ (BOOL) mailRecipientIsValid: (NSString*) aMailRecipient;

// Selector returns YES if aMailRecipient contains  one valid email address
+ (BOOL) mailRecipientsAreValid: (NSString*) mailRecipients;

// Selector returns YES is aMailRecipientAlias has a valid alias
+ (BOOL) mailRecipientAliasIsValid: (NSString*) aMailRecipientAlias;


@end