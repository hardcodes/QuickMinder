//
// Created by sven on 01.06.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "HCMailConfigItem.h"
#import "HCDefaultStrings.h"


NSString* const HCMailConfigItemMailReceiver=@"HCMailConfigItemMailReceiver";
NSString* const HCMailConfigItemButtonAlias=@"HCMailConfigItemButtonAlias";


@implementation HCMailConfigItem {


}

@synthesize mailReceiver = _mailReceiver;
@synthesize buttonAlias = _buttonAlias;


- (void)dealloc{

	DLog(@"");


	[[self mailReceiver] release];
	[[self buttonAlias] release];
	[super dealloc];
}


#pragma mark - Archiving

- (id)initWithCoder:(NSCoder *)aDecoder{

	DLog(@"");

	self = [super init];
	if (self){
		self.mailReceiver = [aDecoder decodeObjectForKey: HCMailConfigItemMailReceiver];
		self.buttonAlias = [aDecoder decodeObjectForKey: HCMailConfigItemButtonAlias];
	}
	return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{

	DLog(@"");

	[aCoder encodeObject: [self mailReceiver] forKey: HCMailConfigItemMailReceiver];
	[aCoder encodeObject: [self buttonAlias] forKey: HCMailConfigItemButtonAlias];

}


#pragma mark - class methods

// selector checks if he given mail recipient is a valid email address
+ (BOOL) mailRecipientIsValid: (NSString*) aMailRecipient{
	
	
	NSError *error = NULL;
	NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern: HCValidEmailAddressRegexPattern
																					   options: NSRegularExpressionCaseInsensitive
																						 error: &error];
	
	if([regularExpression numberOfMatchesInString: aMailRecipient options: 0 range: NSMakeRange(0, [aMailRecipient length])]==0) return NO;
	return YES;
}


+ (BOOL) mailRecipientAliasIsValid: (NSString*) aMailRecipientAlias{
	
	
	if([aMailRecipientAlias isEqualToString: @""]) return NO;
	return YES;
}


// Selector returns YES if aMailRecipient contains  one valid email address
+ (BOOL) mailRecipientsAreValid: (NSString*) mailRecipients{
	
	NSError *error = NULL;
	NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern: HCValidEmailAddressesRegexPattern
																					   options: NSRegularExpressionCaseInsensitive
																						 error: &error];
	
	if([regularExpression numberOfMatchesInString: mailRecipients options: 0 range: NSMakeRange(0, [mailRecipients length])]==0) return NO;
	return YES;
}


@end