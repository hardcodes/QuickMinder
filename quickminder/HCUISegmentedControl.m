//
//  HCUISegmentedControl.m
//  QuickMinder
//
//  Created by Putze Sven on 08.03.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import "HCUISegmentedControl.h"


#pragma mark - implementation

@implementation HCUISegmentedControl

- (UIImagePickerControllerCameraFlashMode)cameraFlashModeForSelectedSegment{
	
	return [HCUISegmentedControl cameraFlashModeForSelectedSegment: self.selectedSegmentIndex];
}

+ (UIImagePickerControllerCameraFlashMode)cameraFlashModeForSelectedSegment: (NSInteger) segment{
	
	UIImagePickerControllerCameraFlashMode cameraFlashMode;
	
	switch (segment) {
		case 1:
			cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
			break;
			
		case 2:
			cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
			break;
			
		default:
			cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
			break;
	}
	
	return cameraFlashMode;
}

@end
