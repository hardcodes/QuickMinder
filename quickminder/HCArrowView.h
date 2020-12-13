//
//  HCArrowView.h
//  QuickMinder
//
//  Created by Putze Sven on 16.02.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import <UIKit/UIKit.h>

enum HCArrowViewDirections{
	HCArrowUp,
	HCArrowRight,
	HCArrowDown,
	HCArrowLeft
};

@interface HCArrowView : UIView{
	
}

@property (retain, nonatomic) UIColor *drawingColor;
@property (assign, nonatomic) GLfloat lineWidth;
@property (assign, nonatomic) NSInteger arrowDirection;

@end
