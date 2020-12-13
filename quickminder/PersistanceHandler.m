//
//  PersistanceHandler.m
//  Jumpy
//
//  Created by Sven Putze on 29.06.11.
//  Copyright 2011 hardcodes.de. All rights reserved.
//

#import "PersistanceHandler.h"


#pragma mark - implementation

@implementation PersistanceHandler




+ (BOOL) archiveObject: (id) aObject toNSDocumentDirectoryWithFileName: (NSString*) aFileName{
	
	
	NSString *archivePath = [PersistanceHandler archivePathForFileName: aFileName];
	DLog(@"archiving/saving object %@ to %@", aObject, archivePath);
	return [NSKeyedArchiver archiveRootObject: aObject toFile: archivePath];
}



+ (id) decodeObjectFromNSDocumentDirectoryWithFileName: (NSString*) aFileName{
	
	NSString *archivePath = [PersistanceHandler archivePathForFileName: aFileName];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath: archivePath];
	if(fileExists==NO){
		DLog(@"file '%@' does not exist", aFileName);
		return nil;
	}
	DLog(@"loading object from %@", archivePath);
	return [NSKeyedUnarchiver unarchiveObjectWithFile: archivePath];
	
}


+ (NSString*)archivePathForFileName: (NSString*) aFileName{

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *archivePath = [documentsDirectory stringByAppendingPathComponent: aFileName];
	return archivePath;
	
}


@end
