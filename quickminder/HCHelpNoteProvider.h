//
// Created by sven on 06.06.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface HCHelpNoteProvider : NSObject

// get the language independant help message that is associated with the given tag number
- (NSString *) helpNoteForTag: (NSInteger) aTag;

@end