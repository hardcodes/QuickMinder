//
//  HCUIPopoverViewController.h
//  QuickMinder
//
//  Created by Putze Sven on 13.02.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCUIViewRoundedCorners.h"
#import "HCUIViewTouchCatcher.h"

#define HCUIPopoverViewControllerHPadding 2.0
#define HCUIPopoverViewControllerVPadding 2.0
#define HCUIPopoverViewControllerArrowBase 20.0
#define HCUIPopoverViewControllerArrowHeight 10.0
#define HCUIPopoverViewControllerAlpha 1.0
#define HCUIPopoverViewControllerAnimationDuration 0.3
#define HCUIPopoverViewControllerContentLayerRadius 10.0

@class HCUIPopoverViewController;

@protocol HCUIPopoverViewControllerDelegate<NSObject>
@required
	// delegate is called on loadView. If the optional delegate contentViewForPopOverViewController: does not return
	// a view, those buttons are programmatically added to the contentView.
	// delegate must suply an array that contains all the buttons that should be displayed in the contentview
	// this is not done in -(id)init, so we can save memory until we are loaded
	// caller is reponsible for setting tags
- (NSArray*)addButtonsToContentViewForPopOverViewController: (HCUIPopoverViewController*) aPopoverViewController;
	// Usually UIViewControllers are the controlling part in the MVC paradigm, thus should know about the buttons
	// and what to do if a button was touched
	// HCUIPopoverViewController works just like a proxy that does know (almost) nothing about the views it displays.
	// So the superview must implement this method to handle button touches
- (void)popoverViewController: (HCUIPopoverViewController*) aPopoverViewController buttonTouched: (id) sender;
	// superview must implement this method to be notified that it can close us
- (void)dismissPopoverViewController: (HCUIPopoverViewController*) aPopoverViewController animated: (BOOL) isAnimated;

@optional
	// If HCUIPopoverViewController should be used to display any individual view this method can be implemented.
	// Superviews that respond to this method can deliver the view that should be display.
	// addButtonsToContentViewForPopOverViewController: is called to get the buttons which actions should be set to
	// self. The receiver should deliver an autoreleased object!
- (UIView*)contentViewForPopOverViewController: (HCUIPopoverViewController*) aPopoverViewController;

@end


@interface HCUIPopoverViewController : UIViewController <HCUIViewTouchCatcherDelegate>{
}

@property (assign, nonatomic) id <HCUIPopoverViewControllerDelegate> delegate;
@property (assign, nonatomic) GLfloat verticalPadding;
@property (assign, nonatomic) GLfloat horizontalPadding;
@property (assign, nonatomic) NSUInteger buttonControlEvent;
@property (retain, nonatomic) UIColor *contentBackgroundColor;
@property (assign, nonatomic) GLfloat contentAplha;
@property (nonatomic, readonly, getter=popoverIsVisible) BOOL popoverVisible;

	// aAlignmentRect must be converted coordinates from aSuperView
- (void)presentHCUIPopoverViewControllerInSuperView: (UIView*) aSuperView forAlignmentRect: (CGRect) aAlignmentRect animated: (BOOL) isAnimated;
- (void)dismissHCUIPopoverViewControllerFromSuperViewAnimated: (BOOL) isAnimated;

@end
