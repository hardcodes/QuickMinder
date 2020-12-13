//
//  Created by sven on 4/19/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UIScrollView+CalculateContentSize.h"

#define HCContentSizeOffset 10


@interface UIScrollView ()



@end

@implementation UIScrollView (CalculateContentSize)

- (void)SetCalculatedContentSize{

	if([[self subviews] count] ==0) return;
    
    CGRect newRect = CGRectNull;
    CGFloat startHeight = 0;
	for (NSUInteger i = 0; i < [self.subviews count]; i++){
		
		UIView *enumeratedSubView = [self.subviews objectAtIndex:i];
        if(enumeratedSubView.frame.origin.y > startHeight){
            startHeight = enumeratedSubView.frame.origin.y;
            newRect = enumeratedSubView.frame;
        }
	}
    
    CGFloat newHeight = newRect.origin.y + newRect.size.height + HCContentSizeOffset;
    CGSize newContentSize = CGSizeMake(self.bounds.size.width, newHeight);
    [self setContentSize: newContentSize];
    DLog(@"newContentSize=%@", NSStringFromCGSize(newContentSize));

}
@end