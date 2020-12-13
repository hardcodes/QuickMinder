//
//  HCStaticMethods.m
//  quickminder
//
//  Created by Putze Sven on 29.12.11.
//  Copyright (c) 2011 hardcodes.de. All rights reserved.
//

#import "HCStaticMethods.h"
#import "HCDefaultStrings.h"
#import "HCOverlayWarningView.h"

@implementation HCStaticMethods


+ (void)showWarningMessage: (NSString*) aWarningMessage{
	
	DLog(@"");
	
	UIAlertView* alertView = [[UIAlertView alloc]
							  initWithTitle: NSLocalizedString(@"Ooops", nil)
							  message: aWarningMessage
							  delegate: self
							  cancelButtonTitle: NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

	// selector returns the given latitude and longitude as google maps URL
+ (NSString*) googleMapsFormattedURLForLatitude: (CLLocationDegrees) aLatitude andLongitude: (CLLocationDegrees) aLongitude{
	
	DLog(@"");
	return [NSString stringWithFormat: @"Google maps URL:\thttp://maps.google.com/maps?q=%+.6f,%+.6f", aLatitude, aLongitude];
}


+ (NSString*) coordinatesInDegreeAndArcMinutesForLatitude: (CLLocationDegrees) aLatitude andLongitude: (CLLocationDegrees) aLongitude{
	
	DLog(@"");
	
	CLLocationDegrees latitudeDegrees;
	CLLocationDegrees latitudeArcMinutes;
	CLLocationDegrees longitudeDegrees;
	CLLocationDegrees longitudeArcMinutes;
	NSString *latitudeNS;
	NSString *longitudeEW;
	
	if(aLatitude < 0) latitudeNS=@"S";
	else latitudeNS=@"N";

	if(aLongitude < 0) longitudeEW=@"W";
	else longitudeEW=@"E";
	
		// get digits defore and  after .
	latitudeArcMinutes = modf(aLatitude, &latitudeDegrees);
		// convert to arc minutes
	latitudeArcMinutes *= 60;
	// get digits defore and  after .
	longitudeArcMinutes = modf(aLongitude, &longitudeDegrees);
	// convert to arc minutes
	longitudeArcMinutes *= 60;

	return [NSString stringWithFormat: @"DDD°MM.MMM':\t%@%.0f°%02.3f' %@%.0f°%02.3f'", latitudeNS, fabs(latitudeDegrees), fabs(latitudeArcMinutes), longitudeEW, fabs(longitudeDegrees), fabs(longitudeArcMinutes)];
}



+ (NSString*) coordinatesInDegreeAndArcMinutesAndArcSecondsForLatitude: (CLLocationDegrees) aLatitude andLongitude: (CLLocationDegrees) aLongitude{

	DLog(@"");
	
	CLLocationDegrees latitudeArcMinutes;
	CLLocationDegrees latitudeArcSeconds;
	CLLocationDegrees longitudeArcMinutes;
	CLLocationDegrees longitudeArcSeconds;
	NSString *latitudeNS;
	NSString *longitudeEW;
	
	if(aLatitude < 0) latitudeNS=@"S";
	else latitudeNS=@"N";
	
	if(aLongitude < 0) longitudeEW=@"W";
	else longitudeEW=@"E";
	
		
	latitudeArcMinutes = (aLatitude - floor(aLatitude)) * 60;
	latitudeArcSeconds = roundDoubleWithPrecision((latitudeArcMinutes - floor(latitudeArcMinutes)) * 60,3);
	
	longitudeArcMinutes = (aLongitude - floor(aLongitude)) * 60;
	longitudeArcSeconds = roundDoubleWithPrecision((longitudeArcMinutes - floor(longitudeArcMinutes)) * 60,3);
	
	return [NSString stringWithFormat: @"DDD°MM'SS.SSS\":\t%@%.0f°%.0f'%02.3f\" %@%.0f°%.0f'%02.3f\"", latitudeNS, fabs(aLatitude), fabs(latitudeArcMinutes), fabs(latitudeArcSeconds), longitudeEW, fabs(aLongitude), fabs(longitudeArcMinutes), fabs(longitudeArcSeconds)];

	
}



#if DEBUG
void dumpViews(UIView* view, NSString *text, NSString *indent) 
{
    Class cl = [view class];
    NSString *classDescription = [cl description];
	
	UIButton *control = nil;
	
	if([classDescription isEqualToString:@"UINavigationButton"]){
		control = (UIButton*)cl;
	}
    while ([cl superclass]) 
		{
        cl = [cl superclass];
        classDescription = [classDescription stringByAppendingFormat:@":%@", [cl description]];
		}
	
	
    if ([text compare:@""] == NSOrderedSame){
		
        NSLog(@"%@ %@", classDescription, NSStringFromCGRect(view.frame));
	}
    else
        NSLog(@"%@ %@ %@", text, classDescription, NSStringFromCGRect(view.frame));
	if(control!=nil){
		
		
	}

	
    for (NSUInteger i = 0; i < [view.subviews count]; i++)
		{
        UIView *subView = [view.subviews objectAtIndex:i];
        NSString *newIndent = [[NSString alloc] initWithFormat:@"  %@", indent];
        NSString *msg = [[NSString alloc] initWithFormat:@"%@%d:", newIndent, i];
        dumpViews(subView, msg, newIndent);
        [msg release];
        [newIndent release];
		}
}
#endif


double round_double(double num, int prec)
{
    double tmp = pow(10.0, prec);
    double result = floor(num * tmp + 0.5);
    result /= tmp;
    return result;
}

double roundDoubleWithPrecision(double number, int precision){
	return round(number * pow(10, precision)) / pow(10, precision);
}

@end
