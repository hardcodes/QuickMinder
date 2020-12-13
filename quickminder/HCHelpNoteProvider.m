//
// Created by sven on 06.06.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "HCHelpNoteProvider.h"

@interface HCHelpNoteProvider()

@property (retain, nonatomic) NSMutableDictionary *tag2HelpNoteIdentifier;

@end

@implementation HCHelpNoteProvider {

@private
	NSMutableDictionary *_tag2HelpNoteIdentifier;
}
@synthesize tag2HelpNoteIdentifier = _tag2HelpNoteIdentifier;


- (id)init {
	self = [super init];
	if (self) {
		[self prepareTag2HelpNoteDictionary];
	}

	return self;
}

- (void)dealloc {

	[[self tag2HelpNoteIdentifier] release];
	[super dealloc];
}


- (NSString *)helpNoteForTag:(NSInteger)aTag {

	NSString *helpNoteIdentifier = [[self tag2HelpNoteIdentifier] objectForKey: [NSString stringWithFormat: @"%i", aTag]];
	return NSLocalizedString(helpNoteIdentifier, nil);
}


- (void) prepareTag2HelpNoteDictionary{

	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
	[dictionary setObject: @"HCMailReceiverHelpNote" forKey: [NSString stringWithFormat: @"%i", 1]];
	[self setTag2HelpNoteIdentifier: dictionary];
	[dictionary release];
}


@end