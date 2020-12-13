//
//  HCAppDelegate.m
//  quickminder
//
//  Created by Putze Sven on 21.12.11.
//  Copyright (c) 2011 hardcodes.de. All rights reserved.
//

#import "HCAppDelegate.h"
#import "HCDefaultStrings.h"

@implementation HCAppDelegate

@synthesize window = _window;

- (void)dealloc
{
	DLog(@"");
	[_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	DLog(@"");
		// Override point for customization after application launch.	
		// register the default values
	NSMutableDictionary *userDefaults = [NSMutableDictionary dictionary];
	[userDefaults setObject: HCMailReceiver1Value forKey: HCMailReceiver1Key];
	[userDefaults setObject: HCMailReceiver2Value forKey: HCMailReceiver2Key];
	[userDefaults setObject: HCMailReceiver3Value forKey: HCMailReceiver3Key];
	[userDefaults setObject: HCMailReceiver4Value forKey: HCMailReceiver4Key];
	[userDefaults setObject: HCMailReceiverAlias1Value forKey: HCMailReceiverAlias1Key];
	[userDefaults setObject: HCMailReceiverAlias2Value forKey: HCMailReceiverAlias2Key];
	[userDefaults setObject: HCMailReceiverAlias3Value forKey: HCMailReceiverAlias3Key];
	[userDefaults setObject: HCMailReceiverAlias4Value forKey: HCMailReceiverAlias4Key];

	[userDefaults setObject: HCMailSubjectValue forKey: HCMailSubjectKey];
	[userDefaults setValue: [NSNumber numberWithBool:NO] forKey: HCWordCorrectionKey];
	[userDefaults setValue: [NSNumber numberWithBool:NO] forKey: HCAutoDeleteKey];
	[userDefaults setValue: [NSNumber numberWithBool:NO] forKey: HCSavePhotosKey];
	[userDefaults setValue: [NSNumber numberWithFloat: 1.0] forKey: HCPhotoCompressionKey];
	[userDefaults setValue: [NSNumber numberWithFloat: 0.5] forKey: HCPhotoResizingKey];
	[userDefaults setValue: [NSNumber numberWithBool:YES] forKey: HCShowKeyboardKey];
	[userDefaults setValue: [NSNumber numberWithInteger: 1] forKey: HCPhotoFlashSegmentKey];
	
	[userDefaults setValue: [NSNumber numberWithInteger: HCLocationManagerTimeoutValue] forKey: HCLocationManagerTimeoutKey];

	[userDefaults setObject: NSLocalizedString(@"Send", nil) forKey: HCSendMailButtonLabelKey];
	[userDefaults setObject: @"" forKey: HCTextViewMailBodyKey];
	[userDefaults setObject: @"" forKey: HCTextViewMailSubjectKey];
	[userDefaults setValue: [NSNumber numberWithBool:NO] forKey: HCAutoSendMailKey];
	
	[userDefaults setValue: [NSNumber numberWithBool:NO] forKey: HCMailHasAttachmentKey];

	[userDefaults setValue: [NSNumber numberWithBool:YES] forKey: HCUseTextExpander];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults: userDefaults];
	
#if DEBUG
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//	NSEnumerator *enumerator = [infoDictionary keyEnumerator];
//	id infoDictionaryKey;
//	while ((infoDictionaryKey = [enumerator nextObject])) {
//			NSLog(@"%@=%@", infoDictionaryKey,  [[[NSBundle mainBundle] infoDictionary] objectForKey: infoDictionaryKey]);
//	}
//	NSLog(@"%@", [[infoDictionary allKeys] componentsJoinedByString: @", "]);
	NSLog(@"Device: %@", [[UIDevice currentDevice] model]);
	NSLog(@"CFBundleName=%@", [infoDictionary objectForKey:@"CFBundleName"]);
	NSLog(@"CFBundleShortVersionString=%@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]);
	NSLog(@"CFBundleVersion=%@", [infoDictionary objectForKey:@"CFBundleVersion"]);
	
	NSLog(@"GIT_COMMIT_HASH=%@", [infoDictionary objectForKey:@"GIT_COMMIT_HASH"]);
	NSLog(@"GIT_COMMIT_DATE=%@", [infoDictionary objectForKey:@"GIT_COMMIT_DATE"]);
#endif
	
#if defined (BETA_VERSION)
	DLog(@"BETA_VERSION=1");
#endif


    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
	
		// is followed by UIApplicationWillResignActiveNotification notification
	DLog(@"");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	DLog(@"");
	
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
	
		// is followed by UIApplicationWillEnterForegroundNotification notification
	DLog(@"");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	DLog(@"");
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
	DLog(@"");
}

@end
