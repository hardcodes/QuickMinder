//
//  HCStaticMethods.h
//  quickminder
//
//  Created by Putze Sven on 29.12.11.
//  Copyright (c) 2011 hardcodes.de. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CoreLocation.h>
#import "HCMailComposeViewController.h"

#define HCMailBodyCapacity 1024


@interface HCStaticMethods : NSObject

+ (void)showWarningMessage: (NSString*) aWarningMessage;


+ (NSString*) googleMapsFormattedURLForLatitude: (CLLocationDegrees) aLatitude andLongitude: (CLLocationDegrees) aLongitude;


+ (NSString*) coordinatesInDegreeAndArcMinutesForLatitude: (CLLocationDegrees) aLatitude andLongitude: (CLLocationDegrees) aLongitude;


+ (NSString*) coordinatesInDegreeAndArcMinutesAndArcSecondsForLatitude: (CLLocationDegrees) aLatitude andLongitude: (CLLocationDegrees) aLongitude;


#if DEBUG
	// should not be in production code
void dumpViews(UIView* view, NSString *text, NSString *indent);
#endif

	// first approach
double round_double(double num, int prec);
	// from Stefan's website http://yeswecache.de/includes/upload/Browsertools/Koordinatenumrechnung.htm
double roundDoubleWithPrecision(double number, int precision);

@end
