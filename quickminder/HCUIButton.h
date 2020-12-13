//
//  HCUIButton.h
//  QuickMinder
//
//  Created by Putze Sven on 06.02.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HCUIButtonDisabledAlpha 0.1
#define HCUIButtonCornerRadius 10.0

enum HCButtonImageType{
	HCButtomImageTrash,
	HCButtonImageGPS,
	HCButtonImageCamera
};

typedef int HCButtonImageType;

@interface HCUIButton : UIButton

+ (UIImage*)ImageOfType: (HCButtonImageType) imageType;
- (void) setDeviceIndependentImageOfType: (HCButtonImageType) imageType;
- (void) setDeviceIndependentFrameBasedOnPhoneFrame: (CGRect) aPhoneFrame;

@end
