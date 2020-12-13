//
//  HCUISegmentedControl.h
//  QuickMinder
//
//  Created by Putze Sven on 08.03.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCUISegmentedControl : UISegmentedControl

- (UIImagePickerControllerCameraFlashMode)cameraFlashModeForSelectedSegment;
+ (UIImagePickerControllerCameraFlashMode)cameraFlashModeForSelectedSegment: (NSInteger) segment;

@end
