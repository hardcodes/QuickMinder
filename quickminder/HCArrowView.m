//
//  HCArrowView.m
//  QuickMinder
//
//  Created by Putze Sven on 16.02.12.
//  Copyright (c) 2012 hardcodes.de. All rights reserved.
//

#import "HCArrowView.h"

#pragma mark - private interface

@interface HCArrowView()

@end


#pragma mark - implementation

@implementation HCArrowView

@synthesize drawingColor = _drawingColor;
@synthesize lineWidth = _lineWidth;
@synthesize arrowDirection = _arrowDirection;


- (id)initWithFrame:(CGRect)frame
{
	DLog(@"");
	
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setLineWidth: 1.0];
		[self setDrawingColor: [UIColor blackColor]];
		[self setArrowDirection: HCArrowUp];
		[self setOpaque: NO];
    }
    return self;
}

-(void)dealloc{
	
	DLog(@"");
	
	[_drawingColor release];
	[super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	DLog(@"");
	
    // Drawing code
	CGContextRef graphicsContext = UIGraphicsGetCurrentContext();
	CGRect	drawingFrame = self.bounds;
		// Set the line width to self.lineWidth and inset the rectangle by
		// 1/2 self.lineWidth pixels on all sides to compensate for the width of the line.
	CGContextSetLineWidth(graphicsContext, self.lineWidth);
	CGFloat inset = floorf(self.lineWidth/2);
	CGRectInset(drawingFrame, inset, inset);
	[self.drawingColor set];
	[self.drawingColor setFill];
	
	CGContextBeginPath(graphicsContext);
	
	CGPoint arrowPoints[4];
	
	switch (self.arrowDirection) {
			
		case HCArrowUp:

			arrowPoints[0]=CGPointMake(0, drawingFrame.size.height);
			arrowPoints[1]=CGPointMake(drawingFrame.size.width, drawingFrame.size.height);
			arrowPoints[2]=CGPointMake(drawingFrame.size.width/2,0);
			arrowPoints[3]=CGPointMake(0, drawingFrame.size.height);
			
			break;
			
		case HCArrowRight:
			
			arrowPoints[0]=CGPointMake(0, drawingFrame.size.height);
			arrowPoints[1]=CGPointMake(drawingFrame.size.width, drawingFrame.size.height);
			arrowPoints[2]=CGPointMake(drawingFrame.size.width/2,0);
			arrowPoints[3]=CGPointMake(0, drawingFrame.size.height);
			
			break;
			
		case HCArrowDown:
			
			arrowPoints[0]=CGPointMake(0, drawingFrame.size.height);
			arrowPoints[1]=CGPointMake(drawingFrame.size.width, drawingFrame.size.height);
			arrowPoints[2]=CGPointMake(drawingFrame.size.width/2,0);
			arrowPoints[3]=CGPointMake(0, drawingFrame.size.height);
			
			break;
			
		case HCArrowLeft:
			
			arrowPoints[0]=CGPointMake(0, drawingFrame.size.height);
			arrowPoints[1]=CGPointMake(drawingFrame.size.width, drawingFrame.size.height);
			arrowPoints[2]=CGPointMake(drawingFrame.size.width/2,0);
			arrowPoints[3]=CGPointMake(0, drawingFrame.size.height);
			
			break;
			
			
		default:
				// should never happen
			break;
	}
	
	CGContextAddLines(graphicsContext,arrowPoints,4);
	CGContextFillPath(graphicsContext);
}


@end
